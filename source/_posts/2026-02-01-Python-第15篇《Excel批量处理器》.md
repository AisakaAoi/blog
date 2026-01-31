---
title: Python-第15篇《Excel批量处理器》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐果果课程
abbrlink: e7947d0f
date: 2026-02-01 02:27:39
tags:
---

### 导语

上篇我们用Python管理个人账目，但工作中更常见的是“成堆的Excel文件”——月度报表、部门预算、项目台账...一个个手动调整格式、合并数据，简直是体力活！今天我们去芜存菁，写一个Excel批量处理器：批量改格式、批量转文件、批量合并数据。一次编写，解放双手！

<!--more-->

***

### 本篇目标

- 掌握`openpyxl`库操作Excel单元格
- 实现批量格式调整（字体、颜色、列宽）
- 完成Excel ↔ CSV批量互转
- 实现多文件数据自动合并
- 打造带进度显示的批量处理工具

***

### 一、准备工作：安装必要库

```python
# 在命令行运行
# pip install openpyxl pandas

import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter
import pandas as pd
import os
import glob
from datetime import datetime
```

***

### 二、认识Excel的“骨架”

用`openpyxl`操作Excel，先理解三层结构：
- **Workbook**：整个Excel文件（工作簿）
- **Worksheet**：工作表（Sheet）
- **Cell**：单元格

```python
# ========== 探索Excel结构 ==========
def explore_excel(file_path):
    """查看Excel文件结构"""
    wb = openpyxl.load_workbook(file_path)
    
    print(f"📊 Excel文件包含 {len(wb.sheetnames)} 个工作表:")
    for i, name in enumerate(wb.sheetnames, 1):
        print(f"  {i}. {name}")
    
    # 查看第一个表的数据
    ws = wb.active  # 获取活动工作表
    print(f"\n表名: {ws.title}")
    print(f"最大行数: {ws.max_row}")
    print(f"最大列数: {ws.max_column}")
    
    # 读取A1单元格
    cell = ws['A1']
    print(f"A1单元格值: {cell.value}")
    print(f"A1单元格类型: {type(cell.value)}")
    
    wb.close()

# 创建一个测试文件来演示
def create_test_excel():
    """创建测试Excel"""
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "销售数据"
    
    # 写入标题
    data = [
        ["日期", "产品", "销售额", "成本", "利润"],
        ["2026-01-01", "产品A", 5000, 3000, 2000],
        ["2026-01-02", "产品B", 8000, 4500, 3500]
    ]
    
    for row in data:
        ws.append(row)
    
    wb.save("测试数据.xlsx")
    print("✅ 创建测试文件: 测试数据.xlsx")
    return "测试数据.xlsx"

# 运行测试
# test_file = create_test_excel()
# explore_excel(test_file)
```

***

### 三、自动化重复操作：批量美化格式

例如需要统一的格式：标题加粗、数字用千分位、利润标红...手动调10个文件眼睛都花了！

```python
# ========== 批量格式美化 ==========
def beautify_excel(file_path):
    """美化单个Excel文件"""
    wb = openpyxl.load_workbook(file_path)
    ws = wb.active
    
    print(f"🎨 正在美化: {file_path}")
    
    # 1. 标题行加粗、背景色
    header_fill = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
    header_font = Font(bold=True, color="FFFFFF", size=12)
    
    for col in range(1, ws.max_column + 1):
        cell = ws.cell(row=1, column=col)
        cell.fill = header_fill
        cell.font = header_font
        cell.alignment = Alignment(horizontal="center", vertical="center")
    
    # 2. 数字列添加千分位符
    for row in range(2, ws.max_row + 1):
        for col in [3, 4, 5]:  # 假设第3、4、5列是数字
            cell = ws.cell(row=row, column=col)
            if isinstance(cell.value, (int, float)):
                cell.number_format = '#,##0.00'  # 千分位保留2位小数
    
    # 3. 利润列自动标红（负利润）
    for row in range(2, ws.max_row + 1):
        profit_cell = ws.cell(row=row, column=5)
        if isinstance(profit_cell.value, (int, float)) and profit_cell.value < 0:
            profit_cell.font = Font(color="FF0000", bold=True)
    
    # 4. 自动调整列宽
    for col in range(1, ws.max_column + 1):
        max_length = 0
        column_letter = get_column_letter(col)
        
        for row in range(1, ws.max_row + 1):
            cell = ws.cell(row=row, column=col)
            try:
                if cell.value:
                    max_length = max(max_length, len(str(cell.value)))
            except:
                pass
        
        # 设置列宽（字符数+2）
        ws.column_dimensions[column_letter].width = min(max_length + 2, 50)
    
    # 5. 添加边框
    from openpyxl.styles import Border, Side
    
    thin_border = Border(
        left=Side(style='thin'),
        right=Side(style='thin'),
        top=Side(style='thin'),
        bottom=Side(style='thin')
    )
    
    for row in range(1, ws.max_row + 1):
        for col in range(1, ws.max_column + 1):
            ws.cell(row=row, column=col).border = thin_border
    
    # 保存
    new_path = file_path.replace('.xlsx', '_美化.xlsx')
    wb.save(new_path)
    wb.close()
    print(f"✅ 美化完成，保存为: {new_path}")

# 测试美化
# beautify_excel("测试数据.xlsx")
```

***

### 四、批量格式转换

#### 4.1 Excel批量转CSV

CSV更轻量，适合数据交换：

```python
# ========== Excel转CSV ==========
def excel_to_csv(excel_path):
    """单个Excel转CSV"""
    try:
        # 读取Excel的第一个sheet
        df = pd.read_excel(excel_path, sheet_name=0)
        
        # 生成CSV文件名
        csv_path = excel_path.replace('.xlsx', '.csv').replace('.xls', '.csv')
        
        # 保存为CSV
        df.to_csv(csv_path, index=False, encoding='utf-8-sig')  # utf-8-sig防止中文乱码
        
        print(f"✅ {excel_path} -> {csv_path}")
        return True
    except Exception as e:
        print(f"❌ 转换失败 {excel_path}: {e}")
        return False

def batch_excel_to_csv(folder_path):
    """批量转换文件夹内所有Excel"""
    print(f"\n📂 开始批量转换: {folder_path}")
    
    # 查找所有Excel文件
    excel_files = glob.glob(os.path.join(folder_path, "*.xlsx")) + \
                  glob.glob(os.path.join(folder_path, "*.xls"))
    
    if not excel_files:
        print("⚠️ 未找到Excel文件")
        return
    
    success = 0
    for file in excel_files:
        if excel_to_csv(file):
            success += 1
    
    print(f"\n📊 完成！成功转换 {success}/{len(excel_files)} 个文件")

# 测试转换
# 先创建几个测试文件
def create_test_files():
    os.makedirs("测试文件夹", exist_ok=True)
    for i in range(3):
        wb = openpyxl.Workbook()
        ws = wb.active
        ws.append(["日期", f"数据{i+1}"])
        for row in range(5):
            ws.append([f"2026-01-{row+1}", (row+1)*100])
        wb.save(f"测试文件夹/报表_{i+1}.xlsx")
    print("✅ 创建测试文件完成")

# create_test_files()
# batch_excel_to_csv("测试文件夹")
```

***

#### 4.2 CSV批量转Excel

反向转换同样简单：

```python
# ========== CSV转Excel ==========
def csv_to_excel(csv_path):
    """单个CSV转Excel"""
    try:
        df = pd.read_csv(csv_path)
        excel_path = csv_path.replace('.csv', '.xlsx')
        df.to_excel(excel_path, index=False, engine='openpyxl')
        print(f"✅ {csv_path} -> {excel_path}")
        return True
    except Exception as e:
        print(f"❌ 转换失败 {csv_path}: {e}")
        return False

def batch_csv_to_excel(folder_path):
    """批量转换CSV到Excel"""
    print(f"\n📂 开始批量转换: {folder_path}")
    
    csv_files = glob.glob(os.path.join(folder_path, "*.csv"))
    
    if not csv_files:
        print("⚠️ 未找到CSV文件")
        return
    
    success = 0
    for file in csv_files:
        if csv_to_excel(file):
            success += 1
    
    print(f"\n📊 完成！成功转换 {success}/{len(csv_files)} 个文件")
```

***

### 五、多文件数据合并

最常见的场景：合并各部门的月度报表、汇总各项目成本...

```python
# ========== 多文件数据合并 ==========
def merge_excels(file_list, output_path="合并结果.xlsx"):
    """
    合并多个Excel文件的数据（垂直合并）
    file_list: Excel文件路径列表
    """
    print(f"\n🔗 开始合并 {len(file_list)} 个文件...")
    
    all_data = []
    
    for i, file_path in enumerate(file_list, 1):
        print(f"  [{i}/{len(file_list)}] 读取: {os.path.basename(file_path)}")
        
        try:
            # 读取每个文件的第一个sheet
            df = pd.read_excel(file_path)
            # 添加来源标记
            df['来源文件'] = os.path.basename(file_path)
            all_data.append(df)
        except Exception as e:
            print(f"  ❌ 读取失败: {e}")
    
    if not all_data:
        print("⚠️ 没有成功读取任何文件")
        return
    
    # 合并所有数据
    merged_df = pd.concat(all_data, ignore_index=True)
    
    # 保存结果
    merged_df.to_excel(output_path, index=False, engine='openpyxl')
    print(f"\n✅ 合并完成！共 {len(merged_df)} 行数据")
    print(f"📊 保存为: {output_path}")
    
    # 显示前5行预览
    print("\n预览前5行：")
    print(merged_df.head().to_string())
    
    return merged_df

def merge_all_in_folder(folder_path, output_path=None):
    """合并文件夹内所有Excel文件"""
    excel_files = glob.glob(os.path.join(folder_path, "*.xlsx")) + \
                  glob.glob(os.path.join(folder_path, "*.xls"))
    
    if not excel_files:
        print("⚠️ 未找到Excel文件")
        return
    
    if output_path is None:
        output_path = os.path.join(folder_path, "合并结果.xlsx")
    
    return merge_excels(excel_files, output_path)

# 测试合并
# merge_all_in_folder("测试文件夹")
```

***

### 六、完整项目：Excel批量处理器

整合所有功能，打造一个带菜单的工具：

```python
# ========== Excel批量处理器 - 完整版 ==========
import os
import glob
import openpyxl
import pandas as pd
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from datetime import datetime

def show_menu():
    """显示菜单"""
    print("\n" + "=" * 55)
    print("Excel批量处理器 v1.0")
    print("=" * 55)
    print("1. 批量美化Excel格式")
    print("2. Excel批量转CSV")
    print("3. CSV批量转Excel")
    print("4. 合并多个Excel文件")
    print("5. 退出")
    print("=" * 55)

def get_folder_path():
    """获取文件夹路径"""
    path = input("\n请输入文件夹路径（直接回车使用当前目录）: ").strip()
    if not path:
        path = os.getcwd()
    if not os.path.isdir(path):
        print("❌ 路径不存在！")
        return None
    return path

def batch_beautify():
    """批量美化"""
    folder = get_folder_path()
    if not folder:
        return
    
    excel_files = glob.glob(os.path.join(folder, "*.xlsx"))
    if not excel_files:
        print("⚠️ 未找到Excel文件")
        return
    
    print(f"\n🎨 开始批量美化 {len(excel_files)} 个文件...")
    for file in excel_files:
        try:
            beautify_excel(file)
        except Exception as e:
            print(f"处理失败: {e}")
    
    print("\n✅ 全部美化完成！")

def batch_excel_to_csv():
    """批量Excel转CSV"""
    folder = get_folder_path()
    if folder:
        batch_excel_to_csv_impl(folder)

def batch_csv_to_excel():
    """批量CSV转Excel"""
    folder = get_folder_path()
    if folder:
        batch_csv_to_excel_impl(folder)

def merge_files():
    """合并文件"""
    folder = get_folder_path()
    if folder:
        output = input("输出文件名（默认：合并结果.xlsx）: ").strip() or "合并结果.xlsx"
        merge_all_in_folder(folder, output)

def main():
    while True:
        show_menu()
        choice = input("\n请选择功能（1-5）: ").strip()
        
        if choice == "1":
            batch_beautify()
        elif choice == "2":
            batch_excel_to_csv()
        elif choice == "3":
            batch_excel_to_csv()
        elif choice == "4":
            merge_files()
        elif choice == "5":
            print("👋 感谢使用，再见！")
            break
        else:
            print("请输入1-5之间的数字！")

# ============= 实现函数 =============
def beautify_excel(file_path):
    """美化单个文件"""
    wb = openpyxl.load_workbook(file_path)
    ws = wb.active
    
    # 标题样式
    header_fill = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
    header_font = Font(bold=True, color="FFFFFF", size=12)
    
    for col in range(1, ws.max_column + 1):
        cell = ws.cell(row=1, column=col)
        cell.fill = header_fill
        cell.font = header_font
        cell.alignment = Alignment(horizontal="center")
    
    # 数字格式
    for row in range(2, ws.max_row + 1):
        for col in range(1, ws.max_column + 1):
            cell = ws.cell(row=row, column=col)
            if isinstance(cell.value, (int, float)):
                cell.number_format = '#,##0.00'
    
    # 列宽自适应
    for col in range(1, ws.max_column + 1):
        max_len = 0
        col_letter = get_column_letter(col)
        for row in range(1, ws.max_row + 1):
            val = ws.cell(row=row, column=col).value
            if val:
                max_len = max(max_len, len(str(val)))
        ws.column_dimensions[col_letter].width = min(max_len + 2, 50)
    
    # 边框
    thin_border = Border(
        left=Side(style='thin'), right=Side(style='thin'),
        top=Side(style='thin'), bottom=Side(style='thin')
    )
    for row in range(1, ws.max_row + 1):
        for col in range(1, ws.max_column + 1):
            ws.cell(row=row, column=col).border = thin_border
    
    new_path = file_path.replace('.xlsx', '_美化.xlsx')
    wb.save(new_path)
    wb.close()
    print(f"  ✅ {os.path.basename(file_path)}")

def batch_excel_to_csv_impl(folder_path):
    """Excel转CSV实现"""
    excel_files = glob.glob(os.path.join(folder_path, "*.xlsx")) + \
                  glob.glob(os.path.join(folder_path, "*.xls"))
    
    if not excel_files:
        print("⚠️ 未找到Excel文件")
        return
    
    print(f"\n📂 开始批量转换 {len(excel_files)} 个文件...")
    success = 0
    
    for file in excel_files:
        try:
            df = pd.read_excel(file)
            csv_path = file.replace('.xlsx', '.csv').replace('.xls', '.csv')
            df.to_csv(csv_path, index=False, encoding='utf-8-sig')
            print(f"  ✅ {os.path.basename(file)}")
            success += 1
        except Exception as e:
            print(f"  ❌ {os.path.basename(file)}: {e}")
    
    print(f"\n📊 完成！成功转换 {success}/{len(excel_files)} 个文件")

def batch_csv_to_excel_impl(folder_path):
    """CSV转Excel实现"""
    csv_files = glob.glob(os.path.join(folder_path, "*.csv"))
    
    if not csv_files:
        print("⚠️ 未找到CSV文件")
        return
    
    print(f"\n📂 开始批量转换 {len(csv_files)} 个文件...")
    success = 0
    
    for file in csv_files:
        try:
            df = pd.read_csv(file)
            excel_path = file.replace('.csv', '.xlsx')
            df.to_excel(excel_path, index=False, engine='openpyxl')
            print(f"  ✅ {os.path.basename(file)}")
            success += 1
        except Exception as e:
            print(f"  ❌ {os.path.basename(file)}: {e}")
    
    print(f"\n📊 完成！成功转换 {success}/{len(csv_files)} 个文件")

def merge_all_in_folder(folder_path, output_path):
    """合并文件夹内所有Excel"""
    excel_files = glob.glob(os.path.join(folder_path, "*.xlsx")) + \
                  glob.glob(os.path.join(folder_path, "*.xls"))
    
    if not excel_files:
        print("⚠️ 未找到Excel文件")
        return
    
    print(f"\n🔗 开始合并 {len(excel_files)} 个文件...")
    all_data = []
    
    for i, file in enumerate(excel_files, 1):
        print(f"  [{i}/{len(excel_files)}] {os.path.basename(file)}")
        try:
            df = pd.read_excel(file)
            df['来源文件'] = os.path.basename(file)
            all_data.append(df)
        except Exception as e:
            print(f"    ⚠️ 读取失败: {e}")
    
    if not all_data:
        print("❌ 没有成功读取任何文件")
        return
    
    merged = pd.concat(all_data, ignore_index=True)
    merged.to_excel(output_path, index=False, engine='openpyxl')
    
    print(f"\n✅ 合并完成！共 {len(merged)} 行数据")
    print(f"📊 保存为: {output_path}")

# ============= 入口 =============
if __name__ == "__main__":
    # 创建测试数据（首次运行）
    if not os.path.exists("测试文件夹"):
        create_test_files()
        print("\n✅ 已创建测试数据在'测试文件夹'中")
        print("可以运行功能4（合并文件）测试效果")
    
    main()
```

***

### 七、知识点加油站

#### 7.1 样式大全

```python
# 字体
font = Font(name='微软雅黑', size=12, bold=True, italic=False, 
            color='FF0000', underline='single')

# 填充
fill = PatternFill(fill_type='solid', start_color='FFFF00')

# 对齐
alignment = Alignment(horizontal='center', vertical='center', 
                      wrap_text=True)  # 自动换行

# 边框
border = Border(
    left=Side(style='thin'),      # 'thin', 'medium', 'thick', 'double'
    right=Side(style='thin'),
    top=Side(style='thin'),
    bottom=Side(style='thin')
)
```

***

#### 7.2 glob通配符

```python
import glob

glob.glob("*.xlsx")          # 当前目录所有xlsx
glob.glob("data/*.xlsx")     # data文件夹下的xlsx
glob.glob("**/*.xlsx", recursive=True)  # 所有子目录的xlsx（Python 3.5+）
```

***

### 八、总结

- ✅ `openpyxl`操作Excel样式
- ✅ 批量格式转换（Excel↔CSV）
- ✅ 多文件数据合并
- ✅ 带进度显示的批量处理

***

### 下篇预告

第16篇《个人税务助手》——自动计算个税、管理专项附加扣除、生成年度汇算清单，做自己的税务师！

***

> 🤖 Powered by Kimi K2 Thinking 💻 内容经葵葵🌻审核与修改

***
