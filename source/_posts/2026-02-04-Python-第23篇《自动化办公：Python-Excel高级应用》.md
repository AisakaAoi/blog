---
title: Python-第23篇《自动化办公：Python+Excel高级应用》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐果果课程
abbrlink: 7cea4f2
date: 2026-02-04 05:28:17
tags:
---

### 导语

手动从系统导出数据，复制粘贴到报表模板，调整格式，更新公式，制作数据透视表，最后生成图表...一套流程下来，眼睛花了，手也酸了。今天咱们造一个“自动报表机器人”——它每月1号自动拉数据、算指标、生成带透视表的精美报表，还能邮件发给领导。一次编写，月月省心！

<!--more-->

***

### 本篇目标

- 用Python一键生成多sheet复杂报表
- 实现数据透视表的自动化创建
- 添加图表、公式、条件格式
- 实战：月度财务分析全自动流程
- 学会模板化，让程序“越用越聪明”

***

### 一、准备工作：安装库

```python
# 命令行运行
# pip install pandas openpyxl xlsxwriter

import pandas as pd
import numpy as np
from datetime import datetime
import os
from openpyxl import load_workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
```

***

### 二、构建报表骨架：多sheet工作簿

```python
# ========== 创建多sheet报表骨架 ==========
def create_report_skeleton():
    """
    创建包含多个sheet的报表模板
    就像财务提前准备好月度报表的各个分表
    """
    
    # 创建一个ExcelWriter对象（类似在Excel里新建文件）
    filename = f"财务分析报告_{datetime.now().strftime('%Y%m')}.xlsx"
    writer = pd.ExcelWriter(filename, engine='openpyxl')
    
    # Sheet1: 基础数据
    data = {
        '日期': pd.date_range('2025-01-01', periods=30, freq='D'),
        '收入': np.random.randint(50000, 150000, 30),
        '成本': np.random.randint(30000, 80000, 30),
        '费用': np.random.randint(5000, 20000, 30)
    }
    df = pd.DataFrame(data)
    df['利润'] = df['收入'] - df['成本'] - df['费用']
    df.to_excel(writer, sheet_name='原始数据', index=False)
    
    # Sheet2: 汇总数据
    summary = pd.DataFrame({
        '指标': ['总收入', '总成本', '总费用', '总利润', '利润率'],
        '金额': [df['收入'].sum(), df['成本'].sum(), df['费用'].sum(), 
                df['利润'].sum(), df['利润'].sum() / df['收入'].sum()]
    })
    summary.to_excel(writer, sheet_name='汇总指标', index=False)
    
    # 保存
    writer.save()
    print(f"✅ 报表骨架创建成功: {filename}")
    
    return filename

# 测试
# report_file = create_report_skeleton()
```

***

### 三、高级格式化：让报表“高大上”

```python
# ========== 报表美化与格式化 ==========
def beautify_report(filepath):
    """给报表添加专业格式"""
    
    # 加载现有工作簿
    wb = load_workbook(filepath)
    
    # 1. 美化"汇总指标"sheet
    ws = wb['汇总指标']
    
    # 设置列宽
    ws.column_dimensions['A'].width = 20
    ws.column_dimensions['B'].width = 18
    
    # 标题行样式
    header_font = Font(bold=True, color="FFFFFF", size=12)
    header_fill = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
    header_align = Alignment(horizontal="center", vertical="center")
    
    # 金额样式
    money_font = Font(color="006100")
    money_fill = PatternFill(start_color="C6EFCE", end_color="C6EFCE", fill_type="solid")
    
    # 利润率样式（条件格式模拟）
    percent_font = Font(color="9C5700")
    percent_fill = PatternFill(start_color="FFEB9C", end_color="FFEB9C", fill_type="solid")
    
    # 应用样式
    for row in range(1, ws.max_row + 1):
        for col in range(1, ws.max_column + 1):
            cell = ws.cell(row=row, column=col)
            
            # 标题行
            if row == 1:
                cell.font = header_font
                cell.fill = header_fill
                cell.alignment = header_align
            # 金额行（B列）
            elif col == 2 and row < ws.max_row:
                cell.font = money_font
                cell.fill = money_fill
                cell.number_format = '#,##0.00'  # 千分位格式
            # 利润率（最后一行）
            elif row == ws.max_row and col == 2:
                cell.font = percent_font
                cell.fill = percent_fill
                cell.number_format = '0.00%'  # 百分比格式
    
    # 2. 美化"原始数据"sheet
    ws_data = wb['原始数据']
    
    # 自动调整列宽
    for column in ws_data.columns:
        max_length = 0
        column_letter = get_column_letter(column[0].column)
        
        for cell in column:
            try:
                if cell.value:
                    max_length = max(max_length, len(str(cell.value)))
            except:
                pass
        
        ws_data.column_dimensions[column_letter].width = min(max_length + 2, 20)
    
    # 添加边框
    thin_border = Border(
        left=Side(style='thin'), right=Side(style='thin'),
        top=Side(style='thin'), bottom=Side(style='thin')
    )
    
    for row in ws_data.iter_rows(min_row=1, max_row=ws_data.max_row, 
                                min_col=1, max_col=ws_data.max_column):
        for cell in row:
            cell.border = thin_border
    
    # 保存
    wb.save(filepath)
    print(f"✅ 报表美化完成: {filepath}")

# 测试美化
# beautify_report(report_file)
```

***

### 四、自动化数据透视表

```python
# ========== 自动生成数据透视表 ==========
def create_pivot_table(filepath):
    """
    在Excel中创建数据透视表
    类似Excel的"插入透视表"功能
    """
    
    # 先用pandas创建透视数据
    # 读取原始数据
    df = pd.read_excel(filepath, sheet_name='原始数据')
    
    # 添加分类列（模拟财务分类）
    df['类别'] = np.random.choice(['产品A', '产品B', '服务C', '服务D'], len(df))
    
    # 创建透视表
    pivot = df.pivot_table(
        values=['收入', '成本', '利润'],  # 值字段
        index='类别',                     # 行标签
        aggfunc={'收入': 'sum', '成本': 'sum', '利润': 'sum'},  # 聚合方式
        margins=True,                     # 显示总计
        margins_name='总计'               # 总计名称
    )
    
    # 使用xlsxwriter引擎写入透视表（openpyxl不支持直接创建透视表）
    with pd.ExcelWriter(filepath, engine='openpyxl', mode='a') as writer:
        # mode='a'表示追加，不覆盖原有数据
        pivot.to_excel(writer, sheet_name='透视分析')
    
    print("✅ 透视表创建成功")
    
    # 重新打开文件，美化透视表sheet
    wb = load_workbook(filepath)
    ws_pivot = wb['透视分析']
    
    # 设置标题样式
    ws_pivot['A1'] = "月度利润分析透视表"
    ws_pivot['A1'].font = Font(bold=True, size=14)
    ws_pivot.merge_cells('A1:E1')  # 合并单元格
    
    wb.save(filepath)
    print("✅ 透视表美化完成")

# 测试
# create_pivot_table(report_file)
```

***

### 五、添加图表：让数据“说话”

```python
# ========== 自动生成图表 ==========
def add_charts(filepath):
    """在Excel中插入图表"""
    
    wb = load_workbook(filepath)
    
    # 从数据sheet创建图表
    ws_data = wb['原始数据']
    
    # 创建柱状图（收入趋势）
    from openpyxl.chart import BarChart, LineChart, Reference
    
    # 准备数据引用
    # 日期列A，收入列B
    dates = Reference(ws_data, min_col=1, min_row=2, max_row=31)
    income = Reference(ws_data, min_col=2, min_row=2, max_row=31)
    
    # 创建图表
    chart = BarChart()
    chart.type = "col"
    chart.style = 10
    chart.title = "每日收入趋势"
    chart.y_axis.title = '收入（元）'
    chart.x_axis.title = '日期'
    
    # 添加数据
    chart.add_data(income, titles_from_data=True)
    chart.set_categories(dates)
    
    # 将图表添加到新的sheet
    ws_chart = wb.create_sheet(title="图表分析")
    ws_chart.add_chart(chart, "A1")
    
    # 创建折线图（利润走势）
    line_chart = LineChart()
    line_chart.style = 12
    line_chart.title = "利润走势"
    line_chart.y_axis.title = '利润（元）'
    line_chart.x_axis.title = '日期'
    
    profit = Reference(ws_data, min_col=5, min_row=2, max_row=31)  # 利润在第5列
    line_chart.add_data(profit, titles_from_data=True)
    line_chart.set_categories(dates)
    
    ws_chart.add_chart(line_chart, "J1")
    
    # 保存
    wb.save(filepath)
    print(f"✅ 图表添加完成: {filepath}")

# 测试
# add_charts(report_file)
```

***

### 六、实战：月度财务分析全自动流程

```python
# ========== 月度财务分析自动化系统 ==========
class MonthlyFinanceAutomation:
    """月度财务分析全自动系统"""
    
    def __init__(self, output_folder='月度报表'):
        self.output_folder = output_folder
        os.makedirs(output_folder, exist_ok=True)
        self.data = None
        self.report_file = None
    
    def load_data(self, source='auto'):
        """
        加载数据（支持：CSV/Excel/模拟数据）
        source: 'auto' - 自动查找data文件夹
                'mock' - 生成模拟数据
        """
        if source == 'mock':
            print("📊 生成模拟财务数据...")
            self.data = self._generate_mock_data()
            print(f"✅ 生成 {len(self.data)} 条记录")
            return
        
        # 自动查找数据文件
        data_files = []
        if os.path.exists('data'):
            data_files.extend([f for f in os.listdir('data') if f.endswith(('.csv', '.xlsx'))])
        
        if not data_files:
            print("⚠️ 未找到数据文件，使用模拟数据")
            self.data = self._generate_mock_data()
            return
        
        # 使用最新的数据文件
        latest_file = sorted(data_files)[-1]
        filepath = os.path.join('data', latest_file)
        
        print(f"📄 加载数据文件: {latest_file}")
        
        try:
            if latest_file.endswith('.csv'):
                self.data = pd.read_csv(filepath)
            else:
                self.data = pd.read_excel(filepath)
            
            print(f"✅ 加载成功: {len(self.data)} 行，{len(self.data.columns)} 列")
            
        except Exception as e:
            print(f"❌ 加载失败: {e}，将使用模拟数据")
            self.data = self._generate_mock_data()
    
    def _generate_mock_data(self):
        """生成模拟财务数据"""
        np.random.seed(42)  # 保证数据可复现
        
        # 生成1000条交易记录
        n_records = 1000
        
        data = {
            '日期': pd.date_range('2025-01-01', periods=n_records, freq='D'),
            '部门': np.random.choice(['销售部', '市场部', '技术部', '财务部'], n_records),
            '产品': np.random.choice(['产品A', '产品B', '服务C', '服务D', '产品E'], n_records),
            '客户类型': np.random.choice(['新客户', '老客户', 'VIP客户'], n_records, p=[0.3, 0.5, 0.2]),
            '收入': np.random.randint(5000, 50000, n_records),
            '成本': np.random.randint(2000, 25000, n_records),
            '费用': np.random.randint(500, 8000, n_records)
        }
        
        df = pd.DataFrame(data)
        df['利润'] = df['收入'] - df['成本'] - df['费用']
        df['利润率'] = df['利润'] / df['收入']
        
        return df
    
    def generate_report(self, month='2025-01'):
        """
        生成完整月度财务分析报告
        """
        if self.data is None:
            print("⚠️ 请先加载数据")
            return
        
        print(f"\n{'='*60}")
        print(f"开始生成 {month} 月度财务分析报告")
        print(f"{'='*60}")
        
        # 筛选当月数据
        monthly_data = self.data[self.data['日期'].dt.strftime('%Y-%m') == month]
        
        if monthly_data.empty:
            print(f"⚠️ 没有找到 {month} 的数据")
            return
        
        # 创建文件名
        self.report_file = os.path.join(
            self.output_folder, 
            f"财务分析报告_{month}.xlsx"
        )
        
        # 步骤1: 写入基础数据
        print("\n1️⃣ 写入基础数据...")
        with pd.ExcelWriter(self.report_file, engine='xlsxwriter') as writer:
            monthly_data.to_excel(writer, sheet_name='原始数据', index=False)
            
            # 步骤2: 创建汇总sheet
            print("2️⃣ 创建汇总指标...")
            summary_data = {
                '指标': [
                    '月度总收入', '月度总成本', '月度总费用', '月度净利润',
                    '平均利润率', '交易笔数', '日均收入', '最高单日收入'
                ],
                '金额': [
                    monthly_data['收入'].sum(),
                    monthly_data['成本'].sum(),
                    monthly_data['费用'].sum(),
                    monthly_data['利润'].sum(),
                    monthly_data['利润率'].mean(),
                    len(monthly_data),
                    monthly_data.groupby(monthly_data['日期'].dt.day)['收入'].sum().mean(),
                    monthly_data.groupby(monthly_data['日期'].dt.day)['收入'].sum().max()
                ],
                '单位': ['元', '元', '元', '元', '%', '笔', '元', '元']
            }
            summary_df = pd.DataFrame(summary_data)
            summary_df.to_excel(writer, sheet_name='汇总指标', index=False)
            
            # 步骤3: 创建透视表
            print("3️⃣ 生成数据透视表...")
            
            # 透视表1：部门业绩
            pivot_dept = monthly_data.pivot_table(
                values=['收入', '利润'], 
                index='部门',
                aggfunc='sum',
                margins=True,
                margins_name='总计'
            )
            pivot_dept.to_excel(writer, sheet_name='部门分析')
            
            # 透视表2：产品分析
            pivot_product = monthly_data.pivot_table(
                values=['收入', '利润', '利润率'],
                index='产品',
                aggfunc={'收入': 'sum', '利润': 'sum', '利润率': 'mean'}
            )
            pivot_product.to_excel(writer, sheet_name='产品分析')
            
            # 透视表3：客户类型分析
            pivot_customer = monthly_data.pivot_table(
                values=['收入', '利润'],
                index='客户类型',
                columns='部门',
                aggfunc='sum',
                fill_value=0
            )
            pivot_customer.to_excel(writer, sheet_name='客户分析')
        
        print("✅ 数据写入完成")
        
        # 步骤4: 美化报表
        print("4️⃣ 美化报表格式...")
        self._beautify_report()
        
        # 步骤5: 添加图表
        print("5️⃣ 插入分析图表...")
        self._add_charts_to_report()
        
        print(f"\n🎉 月度财务分析报告生成完成！")
        print(f"📊 文件位置: {self.report_file}")
    
    def _beautify_report(self):
        """美化报表格式"""
        wb = load_workbook(self.report_file)
        
        # 美化汇总指标sheet
        ws_summary = wb['汇总指标']
        
        # 设置列宽
        ws_summary.column_dimensions['A'].width = 20
        ws_summary.column_dimensions['B'].width = 18
        ws_summary.column_dimensions['C'].width = 10
        
        # 标题样式
        header_font = Font(bold=True, color="FFFFFF", size=11)
        header_fill = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
        header_align = Alignment(horizontal="center", vertical="center")
        
        # 数据样式
        money_font = Font(color="006100")
        money_fill = PatternFill(start_color="C6EFCE", end_color="C6EFCE", fill_type="solid")
        
        # 应用样式
        for row in range(1, ws_summary.max_row + 1):
            for col in range(1, ws_summary.max_column + 1):
                cell = ws_summary.cell(row=row, column=col)
                
                if row == 1:  # 标题行
                    cell.font = header_font
                    cell.fill = header_fill
                    cell.alignment = header_align
                elif col == 2:  # 金额列
                    cell.font = money_font
                    cell.fill = money_fill
                    cell.number_format = '#,##0.00'
                elif col == 3:  # 单位列
                    cell.alignment = Alignment(horizontal="center")
        
        # 添加边框
        thin_border = Border(
            left=Side(style='thin'), right=Side(style='thin'),
            top=Side(style='thin'), bottom=Side(style='thin')
        )
        
        for row in ws_summary.iter_rows(min_row=1, max_row=ws_summary.max_row,
                                       min_col=1, max_col=ws_summary.max_column):
            for cell in row:
                cell.border = thin_border
        
        wb.save(self.report_file)
    
    def _add_charts_to_report(self):
        """添加图表"""
        wb = load_workbook(self.report_file)
        
        # 读取数据
        ws_data = wb['原始数据']
        
        # 创建图表sheet
        ws_chart = wb.create_sheet(title='图表分析', index=0)  # 放在最前面
        
        # 部门收入对比图
        from openpyxl.chart import BarChart, LineChart, Reference
        
        # 准备数据（从透视表读取）
        ws_dept = wb['部门分析']
        
        # 柱状图
        chart = BarChart()
        chart.title = "各部门收入与利润对比"
        chart.style = 10
        chart.y_axis.title = '金额（元）'
        chart.x_axis.title = '部门'
        
        # 数据引用
        data = Reference(ws_dept, min_col=2, min_row=1, max_row=ws_dept.max_row, max_col=3)
        categories = Reference(ws_dept, min_col=1, min_row=2, max_row=ws_dept.max_row)
        
        chart.add_data(data, titles_from_data=True)
        chart.set_categories(categories)
        
        # 添加到图表sheet
        ws_chart.add_chart(chart, "A1")
        
        # 客户类型收入占比（饼图）
        from openpyxl.chart import PieChart
        
        pie = PieChart()
        pie.title = "客户类型收入占比"
        
        ws_customer = wb['客户分析']
        pie_data = Reference(ws_customer, min_col=2, min_row=1, max_row=ws_customer.max_row)
        pie_cat = Reference(ws_customer, min_col=1, min_row=2, max_row=ws_customer.max_row)
        
        pie.add_data(pie_data, titles_from_data=True)
        pie.set_categories(pie_cat)
        
        ws_chart.add_chart(pie, "J1")
        
        wb.save(self.report_file)
    
    def run_automation(self):
        """运行完整自动化流程"""
        print("🤖 启动月度财务分析自动化流程")
        
        self.load_data('auto')
        month = input("请输入月份（如2025-01，回车使用数据中的月份）: ").strip() or '2025-01'
        
        self.generate_report(month)
        
        print("\n🚀 流程执行完毕！报表已生成并保存")

def main():
    """主菜单"""
    automation = MonthlyFinanceAutomation()
    
    print("=" * 60)
    print("月度财务分析自动化系统")
    print("一键完成：加载数据 → 生成报表 → 插入透视表 → 添加图表")
    print("=" * 60)
    
    while True:
        print("\n" + "=" * 45)
        print("功能菜单")
        print("=" * 45)
        print("1. 加载数据")
        print("2. 生成月度报表")
        print("3. 运行完整自动化")
        print("4. 创建示例数据文件")
        print("5. 退出")
        print("=" * 45)
        
        choice = input("请选择: ").strip()
        
        if choice == "1":
            source = input("数据来源（auto/mock）: ").strip() or 'auto'
            automation.load_data(source)
        
        elif choice == "2":
            if automation.data is None:
                print("⚠️ 请先加载数据")
                continue
            month = input("月份（如2025-01）: ").strip() or '2025-01'
            automation.generate_report(month)
        
        elif choice == "3":
            automation.run_automation()
        
        elif choice == "4":
            # 创建示例数据文件
            os.makedirs("data", exist_ok=True)
            mock_data = automation._generate_mock_data()
            mock_data.to_excel("data/2025-01-财务数据.xlsx", index=False)
            print("✅ 示例数据已创建: data/2025-01-财务数据.xlsx")
        
        elif choice == "5":
            print("👋 感谢使用，自动化让工作更轻松！")
            break
        
        else:
            print("请输入1-5！")

if __name__ == "__main__":
    main()
```

***

### 七、知识点加油站

#### 7.1 Pandas透视表参数详解

```python
"""
pivot_table参数手册：

values: 要聚合的列（列表或字符串）
index: 行分组（列表或字符串）
columns: 列分组（可选）
aggfunc: 聚合函数（sum/mean/count/max/min）
        可以是字典：{'列名': '函数'}
fill_value: 填充缺失值
margins: 是否显示总计（True/False）
margins_name: 总计名称
dropna: 是否删除全为NaN的行/列

示例：
df.pivot_table(
    values=['收入', '利润'],
    index='部门',
    columns='月份',
    aggfunc={'收入': 'sum', '利润': 'mean'},
    fill_value=0,
    margins=True,
    margins_name='总计'
)
"""
```

***

#### 7.2 ExcelWriter引擎选择

```python
"""
engine='openpyxl':
- 优点：功能全面，支持.xlsx，可读取修改现有文件
- 缺点：不支持直接创建PivotTable（需用pandas生成）

engine='xlsxwriter':
- 优点：支持图表、格式、条件格式，功能强大
- 缺点：只能写入，不能读取修改

最佳实践：
1. 新建文件：用xlsxwriter
2. 修改文件：先用openpyxl读取，再修改保存
3. PivotTable：pandas生成数据表，再用openpyxl美化

mode参数：
'w' - 写入（覆盖）
'a' - 追加（在现有文件上添加sheet）
"""
```

***

### 八、总结

- ✅ 自动生成多sheet复杂财务报表
- ✅ 数据透视表的自动化创建
- ✅ 图表、公式、条件格式的自动插入
- ✅ 完整的月度财务分析自动化流程
- ✅ 报表美化与模板化

***

### 下篇预告

第24篇《网络编程：获取实时财经数据》——调用API获取实时汇率、股价，打造你的市场监控雷达！

***

> 🤖 Powered by Kimi K2 Thinking 💻 内容经葵葵🌻审核与修改

***
