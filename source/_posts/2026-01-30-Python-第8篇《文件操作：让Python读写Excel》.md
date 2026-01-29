---
title: Python-第8篇《文件操作：让Python读写Excel》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐果果课程
abbrlink: c0084aa4
date: 2026-01-30 02:39:00
tags:
---

### 📖 开篇语

还记得你第一次用Excel打开CSV文件的情景吗？

> “哇，原来Python生成的数据可以直接在Excel里打开！”

今天我们要反过来——**让Python直接读写Excel文件**。
从此告别“复制粘贴”的机械劳动，实现真正的自动化办公！

想象一下这个场景：
`每天早上9点，Python自动下载银行对账单 → 读取公司账目 → 自动对账 → 生成差异报告 → 发送到你的邮箱`
而你只需要喝杯咖啡，看看报告就行！

<!--more-->

***

### 🎯 今日学习目标

- 学会读取CSV文件（Python的“数据入口”）
- 掌握写入Excel文件（Python的“数据出口”）
- 实现自动化银行对账（告别手工对账）

***

### 📖 读取CSV文件：Python的数据入口

**什么是CSV文件？**

CSV = Comma Separated Values（逗号分隔值）
就是纯文本的表格，用逗号分隔列，用换行分隔行

举个栗子🌰：

```csv
日期,摘要,收入,支出,余额
2024-01-01,工资收入,8000.00,,8000.00
2024-01-02,超市购物,,150.50,7849.50
2024-01-03,交通费,,25.00,7824.50
```

**用Python读取CSV文件**

**方法1：普通读取（适合简单场景）**
```python
# 读取银行流水CSV文件
print("=== 读取银行流水 ===")

# 打开文件
with open("银行流水.csv", "r", encoding="utf-8") as 文件:
    # 读取所有行
    所有行 = 文件.readlines()
    
    # 第一行是表头
    表头 = 所有行[0].strip().split(",")
    print(f"表头：{表头}")
    
    # 其余行是数据
    银行流水 = []
    for 行 in 所有行[1:]:  # 跳过表头
        数据 = 行.strip().split(",")
        银行流水.append(数据)
    
    # 显示前几行
    print("\n银行流水数据：")
    for i, 记录 in enumerate(银行流水[:5], 1):
        print(f"{i}. 日期：{记录[0]}，摘要：{记录[1]}，收入：{记录[2]}，支出：{记录[3]}，余额：{记录[4]}")

# 计算总收入和总支出
总收入 = sum(float(记录[2]) if 记录[2] else 0 for 记录 in 银行流水)
总支出 = sum(float(记录[3]) if 记录[3] else 0 for 记录 in 银行流水)

print(f"\n💰 汇总统计：")
print(f"总收入：{总收入:,.2f}元")
print(f"总支出：{总支出:,.2f}元")
print(f"净收支：{总收入 - 总支出:,.2f}元")
```

**方法2：使用csv模块（推荐方法）**
```python
import csv

# 更专业的CSV读取
print("=== 专业CSV读取 ===")

def 读取银行流水(文件名):
    """读取银行流水CSV文件"""
    流水列表 = []
    
    with open(文件名, "r", encoding="utf-8") as 文件:
        csv读取器 = csv.reader(文件)
        
        # 读取表头
        表头 = next(csv读取器)
        print(f"表头：{表头}")
        
        # 读取数据
        for 行号, 记录 in enumerate(csv读取器, 1):
            流水字典 = {
                "行号": 行号,
                "日期": 记录[0],
                "摘要": 记录[1],
                "收入": float(记录[2]) if 记录[2] else 0,
                "支出": float(记录[3]) if 记录[3] else 0,
                "余额": float(记录[4])
            }
            流水列表.append(流水字典)
    
    return 流水列表, 表头

# 使用函数读取
银行流水数据, 原始表头 = 读取银行流水("银行流水.csv")

# 数据分析
print(f"\n📊 数据分析：")
print(f"共读取到 {len(银行流水数据)} 条记录")

# 按条件筛选
大额收入 = [记录 for 记录 in 银行流水数据 if 记录["收入"] > 1000]
购物支出 = [记录 for 记录 in 银行流水数据 if "购物" in 记录["摘要"]]

print(f"\n大额收入（>1000元）：{len(大额收入)}笔")
for 记录 in 大额收入:
    print(f"  {记录['日期']}：{记录['收入']:,.2f}元")

print(f"\n购物支出：{len(购物支出)}笔")
购物总金额 = sum(记录["支出"] for 记录 in 购物支出)
print(f"购物总支出：{购物总金额:,.2f}元")
```

**方法3：读取并转换为DataFrame（为pandas做准备）**
```python
import csv
import pandas as pd

def csv转dataframe(csv文件):
    """将CSV文件转换为DataFrame格式"""
    数据列表 = []
    
    with open(csv文件, "r", encoding="utf-8") as 文件:
        csv读取器 = csv.DictReader(文件)
        
        for 行 in csv读取器:
            # 转换数值类型
            行["收入"] = float(行["收入"]) if 行["收入"] else 0
            行["支出"] = float(行["支出"]) if 行["支出"] else 0
            行["余额"] = float(行["余额"])
            
            数据列表.append(行)
    
    return 数据列表

# 读取数据
流水数据 = csv转dataframe("银行流水.csv")

# 转换为pandas DataFrame（为后续做准备）
df = pd.DataFrame(流水数据)
print(f"DataFrame形状：{df.shape}")
print(df.head())  # 显示前5行
```

<details>
<summary>实战：读取发票清单CSV</summary>

```python
# 读取发票清单并自动分类
print("=== 发票清单处理 ===")

def 处理发票清单(发票文件):
    """读取并处理发票清单"""
    发票列表 = []
    
    with open(发票文件, "r", encoding="utf-8") as 文件:
        csv读取器 = csv.DictReader(文件)
        
        for 发票 in csv读取器:
            # 数据清洗和转换
            发票信息 = {
                "发票代码": 发票["发票代码"],
                "发票号码": 发票["发票号码"],
                "开票日期": 发票["开票日期"],
                "金额": float(发票["金额"]),
                "税额": float(发票["税额"]),
                "价税合计": float(发票["价税合计"]),
                "发票类型": 发票["发票类型"],
                "发票状态": 发票["发票状态"],
                "销方名称": 发票["销方名称"],
                "发票内容": 发票["发票内容"]
            }
            发票列表.append(发票信息)
    
    return 发票列表

# 读取发票数据
发票数据 = 处理发票清单("发票清单.csv")

# 发票分类统计
有效发票 = [发票 for 发票 in 发票数据 if 发票["发票状态"] == "正常"]
作废发票 = [发票 for 发票 in 发票数据 if 发票["发票状态"] == "作废"]
专用发票 = [发票 for 发票 in 发票数据 if 发票["发票类型"] == "专用发票"]
普通发票 = [发票 for 发票 in 发票数据 if 发票["发票类型"] == "普通发票"]

print(f"📊 发票统计：")
print(f"总发票数：{len(发票数据)}张")
print(f"有效发票：{len(有效发票)}张")
print(f"作废发票：{len(作废发票)}张")
print(f"专用发票：{len(专用发票)}张")
print(f"普通发票：{len(普通发票)}张")

# 金额统计
有效发票总金额 = sum(发票["价税合计"] for 发票 in 有效发票)
专用发票总金额 = sum(发票["价税合计"] for 发票 in 专用发票)

print(f"\n💰 金额统计：")
print(f"有效发票总金额：{有效发票总金额:,.2f}元")
print(f"专用发票总金额：{专用发票总金额:,.2f}元")

# 按月份统计
月份统计 = {}
for 发票 in 有效发票:
    月份 = 发票["开票日期"][:7]  # 取年月部分
    if 月份 not in 月份统计:
        月份统计[月份] = {"数量": 0, "金额": 0}
    月份统计[月份]["数量"] += 1
    月份统计[月份]["金额"] += 发票["价税合计"]

print(f"\n📅 月度开票情况：")
for 月份 in sorted(月份统计.keys()):
    数量 = 月份统计[月份]["数量"]
    金额 = 月份统计[月份]["金额"]
    print(f"{月份}：{数量}张，{金额:,.2f}元")
```

</details>

***

### 📊 写入Excel文件：Python的数据出口

**安装必备库**
```bash
# 需要安装openpyxl库
pip install openpyxl
```

**基础Excel写入**
```python
from openpyxl import Workbook
from openpyxl.styles import Font, Alignment, PatternFill
import csv

# 创建Excel工作簿
def 创建财务报告():
    """创建专业的财务报告Excel文件"""
    
    # 创建工作簿
    wb = Workbook()
    
    # 删除默认工作表
    wb.remove(wb.active)
    
    # 创建多个工作表
    汇总表 = wb.create_sheet("财务汇总", 0)
    明细表 = wb.create_sheet("收支明细", 1)
    分析表 = wb.create_sheet("分析报告", 2)
    
    # ===== 1. 财务汇总表 =====
    汇总表["A1"] = "财务汇总报告"
    汇总表["A1"].font = Font(size=16, bold=True)
    汇总表.merge_cells("A1:E1")
    
    # 添加汇总数据
    汇总数据 = [
        ["项目", "本月", "上月", "环比变化", "备注"],
        ["总收入", "50,000", "45,000", "+11.1%", "工资收入"],
        ["总支出", "35,000", "32,000", "+9.4%", "日常开支"],
        ["净结余", "15,000", "13,000", "+15.4%", "储蓄增加"],
        ["投资收入", "2,500", "2,000", "+25.0%", "理财收益"],
        ["应收账款", "8,500", "7,200", "+18.1%", "待收款"]
    ]
    
    for 行号, 数据行 in enumerate(汇总数据, 2):
        for 列号, 值 in enumerate(数据行, 1):
            单元格 = 汇总表.cell(row=行号, column=列号, value=值)
            if 行号 == 2:  # 表头
                单元格.font = Font(bold=True)
                单元格.fill = PatternFill(start_color="CCCCCC", end_color="CCCCCC", fill_type="solid")
    
    # 调整列宽
    for 列 in ["A", "B", "C", "D", "E"]:
        汇总表.column_dimensions[列].width = 15
    
    # ===== 2. 收支明细表 =====
    明细表["A1"] = "收支明细表"
    明细表["A1"].font = Font(size=14, bold=True)
    
    # 读取CSV数据并写入Excel
    try:
        with open("银行流水.csv", "r", encoding="utf-8") as 文件:
            csv读取器 = csv.reader(文件)
            
            # 写入表头
            表头 = next(csv读取器)
            for 列号, 标题 in enumerate(表头, 1):
                明细表.cell(row=2, column=列号, value=标题)
                明细表.cell(row=2, column=列号).font = Font(bold=True)
            
            # 写入数据
            for 行号, 数据行 in enumerate(csv读取器, 3):
                for 列号, 值 in enumerate(数据行, 1):
                    明细表.cell(row=行号, column=列号, value=值)
        
        print("✅ CSV数据已成功导入Excel！")
        
    except FileNotFoundError:
        # 如果没有CSV文件，生成示例数据
        示例数据 = [
            ["2024-01-01", "工资收入", "8000", "", "8000"],
            ["2024-01-02", "超市购物", "", "150.50", "7849.50"],
            ["2024-01-03", "交通费", "", "25.00", "7824.50"],
            ["2024-01-05", "餐饮消费", "", "180.00", "7644.50"],
            ["2024-01-10", "兼职收入", "1200", "", "8844.50"]
        ]
        
        for 行号, 数据行 in enumerate(示例数据, 3):
            for 列号, 值 in enumerate(数据行, 1):
                明细表.cell(row=行号, column=列号, value=值)
        
        print("✅ 示例数据已写入Excel！")
    
    # ===== 3. 分析报告表 =====
    分析表["A1"] = "财务分析报告"
    分析表["A1"].font = Font(size=14, bold=True)
    
    # 添加分析内容
    分析内容 = [
        ["分析项目", "结果", "建议"],
        ["收支比率", "1.43", "收入大于支出，财务状况良好"],
        ["储蓄率", "30%", "储蓄率较高，可适当增加投资"],
        ["最大支出", "餐饮消费", "建议控制餐饮支出，自己做饭"],
        ["收入稳定性", "高", "主要收入为工资，建议开拓副业"],
        ["投资建议", "稳健型", "可考虑定投指数基金"]
    ]
    
    for 行号, 数据行 in enumerate(分析内容, 2):
        for 列号, 值 in enumerate(数据行, 1):
            单元格 = 分析表.cell(row=行号, column=列号, value=值)
            if 行号 == 2:
                单元格.font = Font(bold=True)
                单元格.fill = PatternFill(start_color="E8F4FD", end_color="E8F4FD", fill_type="solid")
    
    # 调整格式
    for 列 in ["A", "B", "C"]:
        分析表.column_dimensions[列].width = 20
    
    # ===== 保存文件 =====
    文件名 = "财务报告_2024.xlsx"
    wb.save(文件名)
    print(f"✅ Excel文件已保存：{文件名}")
    
    return 文件名

# 创建报告
报告文件 = 创建财务报告()
```

<details>
<summary>进阶：自动生成图表</summary>

```python
from openpyxl.chart import LineChart, Reference, BarChart
from openpyxl.utils.dataframe import dataframe_to_rows
import pandas as pd

def 生成带图表的财务报告():
    """生成包含图表的财务报告"""
    
    # 创建工作簿
    wb = Workbook()
    数据表 = wb.active
    数据表.title = "月度数据"
    
    # 创建示例数据
    月份数据 = {
        "月份": ["1月", "2月", "3月", "4月", "5月", "6月"],
        "收入": [25000, 28000, 26000, 30000, 32000, 35000],
        "支出": [18000, 19500, 18500, 21000, 22000, 23000],
        "结余": [7000, 8500, 7500, 9000, 10000, 12000]
    }
    
    df = pd.DataFrame(月份数据)
    
    # 写入数据到Excel
    for 行 in dataframe_to_rows(df, index=False, header=True):
        数据表.append(行)
    
    # 创建折线图
    折线图 = LineChart()
    折线图.title = "月度收支趋势图"
    折线图.style = 2
    折线图.y_axis.title = "金额（元）"
    折线图.x_axis.title = "月份"
    
    # 添加数据
    数据范围 = Reference(数据表, min_col=2, min_row=1, max_col=4, max_row=7)
    折线图.add_data(数据范围, titles_from_data=True)
    
    # 添加图表到工作表
    数据表.add_chart(折线图, "F2")
    
    # 创建柱状图
    柱状图 = BarChart()
    柱状图.title = "月度结余对比"
    柱状图.style = 10
    柱状图.y_axis.title = "金额（元）"
    柱状图.x_axis.title = "月份"
    
    # 只显示结余数据
    结余数据 = Reference(数据表, min_col=4, min_row=1, max_col=4, max_row=7)
    月份标签 = Reference(数据表, min_col=1, min_row=2, max_row=7)
    
    柱状图.add_data(结余数据, titles_from_data=True)
    柱状图.set_categories(月份标签)
    
    # 添加图表
    数据表.add_chart(柱状图, "F18")
    
    # 保存文件
    文件名 = "财务报告_带图表.xlsx"
    wb.save(文件名)
    print(f"✅ 带图表的Excel报告已生成：{文件名}")
    
    return 文件名

# 生成带图表的报告
图表报告 = 生成带图表的财务报告()
```

</details>

***

### 🏦 实战项目：自动化银行对账

<details>
<summary>版本1.0：基础对账功能</summary>

```python
# 自动化银行对账系统 - 基础版
print("=== 自动化银行对账系统 ===")

import csv
from datetime import datetime
import os

def 读取银行对账单(文件名):
    """读取银行对账单"""
    对账单 = []
    
    try:
        with open(文件名, "r", encoding="utf-8") as 文件:
            csv读取器 = csv.DictReader(文件)
            
            for 记录 in csv读取器:
                对账单.append({
                    "日期": 记录["交易日期"],
                    "摘要": 记录["摘要"],
                    "借方": float(记录["借方金额"]) if 记录["借方金额"] else 0,
                    "贷方": float(记录["贷方金额"]) if 记录["贷方金额"] else 0,
                    "余额": float(记录["余额"]),
                    "对账单索引": len(对账单) + 1
                })
    except FileNotFoundError:
        print(f"❌ 文件 {文件名} 不存在！")
        return []
    
    return 对账单

def 读取企业账目(文件名):
    """读取企业账目"""
    企业账 = []
    
    try:
        with open(文件名, "r", encoding="utf-8") as 文件:
            csv读取器 = csv.DictReader(文件)
            
            for 记录 in csv读取器:
                企业账.append({
                    "日期": 记录["日期"],
                    "摘要": 记录["摘要"],
                    "借方": float(记录["借方"]) if 记录["借方"] else 0,
                    "贷方": float(记录["贷方"]) if 记录["贷方"] else 0,
                    "余额": float(记录["余额"]),
                    "账目索引": len(企业账) + 1
                })
    except FileNotFoundError:
        print(f"❌ 文件 {文件名} 不存在！")
        return []
    
    return 企业账

def 基础对账(银行对账单, 企业账目):
    """执行基础对账功能"""
    对账结果 = {
        "匹配记录": [],
        "银行未达": [],
        "企业未达": [],
        "差异记录": []
    }
    
    # 创建索引以提高查找效率
    银行交易索引 = {}
    for 交易 in 银行对账单:
        关键信息 = f"{交易['日期']}_{交易['借方']}_{交易['贷方']}_{交易['摘要'][:10]}"
        if 关键信息 not in 银行交易索引:
            银行交易索引[关键信息] = []
        银行交易索引[关键信息].append(交易)
    
    # 对账：以企业账目为准
    for 企业交易 in 企业账目:
        关键信息 = f"{企业交易['日期']}_{企业交易['借方']}_{企业交易['贷方']}_{企业交易['摘要'][:10]}"
        
        if 关键信息 in 银行交易索引:
            # 找到匹配记录
            匹配记录 = 银行交易索引[关键信息].pop(0)  # 取出一个匹配
            if not 银行交易索引[关键信息]:  # 如果列表空了，删除键
                del 银行交易索引[关键信息]
            
            对账结果["匹配记录"].append({
                "企业记录": 企业交易,
                "银行记录": 匹配记录,
                "状态": "完全匹配"
            })
        else:
            # 企业有，银行没有 - 企业未达
            对账结果["企业未达"].append(企业交易)
    
    # 银行未达：银行有，企业没有
    for 关键信息, 交易列表 in 银行交易索引.items():
        对账结果["银行未达"].extend(交易列表)
    
    # 检查余额差异
    if 银行对账单 and 企业账目:
        银行最终余额 = 银行对账单[-1]["余额"]
        企业最终余额 = 企业账目[-1]["余额"]
        余额差异 = 银行最终余额 - 企业最终余额
        
        if abs(余额差异) > 0.01:  # 差异大于1分钱
            对账结果["差异记录"].append({
                "类型": "余额差异",
                "银行余额": 银行最终余额,
                "企业余额": 企业最终余额,
                "差异金额": 余额差异
            })
    
    return 对账结果

# 生成对账报告
def 生成对账报告(对账结果, 输出文件名="对账报告.txt"):
    """生成对账报告"""
    
    with open(输出文件名, "w", encoding="utf-8") as 报告文件:
        报告文件.write("银行对账报告\n")
        报告文件.write("=" * 50 + "\n")
        报告文件.write(f"生成时间：{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        
        # 匹配记录
        报告文件.write(f"✅ 匹配记录：{len(对账结果['匹配记录'])}笔\n")
        if len(对账结果['匹配记录']) > 0:
            报告文件.write("前5笔匹配记录：\n")
            for i, 匹配 in enumerate(对账结果['匹配记录'][:5], 1):
                企业 = 匹配["企业记录"]
                银行 = 匹配["银行记录"]
                报告文件.write(f"  {i}. {企业['日期']} - {企业['摘要'][:10]} - {企业['贷方'] - 企业['借方']:,.2f}元\n")
        
        报告文件.write(f"\n⚠️ 银行未达账项：{len(对账结果['银行未达'])}笔\n")
        for i, 交易 in enumerate(对账结果['银行未达'], 1):
            报告文件.write(f"  {i}. {交易['日期']} - {交易['摘要'][:10]} - {交易['贷方'] - 交易['借方']:,.2f}元\n")
        
        报告文件.write(f"\n⚠️ 企业未达账项：{len(对账结果['企业未达'])}笔\n")
        for i, 交易 in enumerate(对账结果['企业未达'], 1):
            报告文件.write(f"  {i}. {交易['日期']} - {交易['摘要'][:10]} - {交易['贷方'] - 交易['借方']:,.2f}元\n")
        
        if 对账结果['差异记录']:
            报告文件.write(f"\n❌ 余额差异：\n")
            for 差异 in 对账结果['差异记录']:
                报告文件.write(f"  银行余额：{差异['银行余额']:,.2f}元\n")
                报告文件.write(f"  企业余额：{差异['企业余额']:,.2f}元\n")
                报告文件.write(f"  差异：{差异['差异金额']:,.2f}元\n")
        else:
            报告文件.write(f"\n✅ 余额核对一致！\n")
    
    return 输出文件名

# 使用对账系统
print("🔍 开始对账...")

# 读取数据
银行数据 = 读取银行对账单("银行对账单.csv")
企业数据 = 读取企业账目("企业账目.csv")

print(f"📊 数据加载完成：")
print(f"银行对账单：{len(银行数据)}笔记录")
print(f"企业账目：{len(企业数据)}笔记录")

# 执行对账
对账结果 = 基础对账(银行数据, 企业数据)

# 显示结果
print(f"\n📋 对账结果：")
print(f"匹配记录：{len(对账结果['匹配记录'])}笔")
print(f"银行未达：{len(对账结果['银行未达'])}笔")
print(f"企业未达：{len(对账结果['企业未达'])}笔")
print(f"差异记录：{len(对账结果['差异记录'])}笔")

# 生成报告
报告文件 = 生成对账报告(对账结果)
print(f"\n✅ 对账报告已生成：{报告文件}")

# 如果有差异，进一步分析
if 对账结果['差异记录']:
    print("\n🔍 差异分析：")
    for 差异 in 对账结果['差异记录']:
        print(f"余额差异：{差异['差异金额']:,.2f}元")
        if 差异['差异金额'] > 0:
            print("建议：检查银行是否有企业未记录的收入")
        else:
            print("建议：检查银行是否有企业未记录的支出")

if 对账结果['银行未达']:
    print("\n💡 银行未达处理建议：")
    print("1. 获取银行回单，补记企业账目")
    print("2. 检查是否有在途资金")

if 对账结果['企业未达']:
    print("\n💡 企业未达处理建议：")
    print("1. 检查银行是否已处理但企业未获取回单")
    print("2. 确认是否有未达账项需要调整")
```

</details>

<details>
<summary>版本2.0：增强对账功能</summary>

```python
# 自动化银行对账系统 - 增强版
print("=== 增强版银行对账系统 ===")

import csv
import pandas as pd
from datetime import datetime, timedelta
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment

class 银行对账系统:
    def __init__(self):
        self.银行数据 = []
        self.企业数据 = []
        self.对账结果 = {}
        
    def 加载银行数据(self, 文件名, 日期列="日期", 金额列="金额", 摘要列="摘要", 余额列="余额"):
        """智能加载银行数据"""
        try:
            df = pd.read_csv(文件名)
            
            for _, 行 in df.iterrows():
                self.银行数据.append({
                    "日期": pd.to_datetime(行[日期列]),
                    "金额": float(行[金额列]),
                    "摘要": str(行[摘要列]),
                    "余额": float(行[余额列]) if 余额列 in 行 else 0,
                    "原始行": 行.to_dict()
                })
            
            print(f"✅ 银行数据加载成功：{len(self.银行数据)}笔")
            return True
            
        except Exception as e:
            print(f"❌ 银行数据加载失败：{e}")
            return False
    
    def 加载企业数据(self, 文件名, 日期列="日期", 借方列="借方", 贷方列="贷方", 摘要列="摘要", 余额列="余额"):
        """智能加载企业数据"""
        try:
            df = pd.read_csv(文件名)
            
            for _, 行 in df.iterrows():
                借方 = float(行[借方列]) if 借方列 in 行 and pd.notna(行[借方列]) else 0
                贷方 = float(行[贷方列]) if 贷方列 in 行 and pd.notna(行[贷方列]) else 0
                金额 = 贷方 - 借方
                
                self.企业数据.append({
                    "日期": pd.to_datetime(行[日期列]),
                    "金额": 金额,
                    "摘要": str(行[摘要列]) if 摘要列 in 行 else "",
                    "余额": float(行[余额列]) if 余额列 in 行 and pd.notna(行[余额列]) else 0,
                    "原始行": 行.to_dict()
                })
            
            print(f"✅ 企业数据加载成功：{len(self.企业数据)}笔")
            return True
            
        except Exception as e:
            print(f"❌ 企业数据加载失败：{e}")
            return False
    
    def 智能对账(self, 容差天数=3, 容差金额=0.01):
        """执行智能对账"""
        print("🔍 执行智能对账...")
        
        对账结果 = {
            "完全匹配": [],
            "金额匹配日期不同": [],
            "日期匹配金额不同": [],
            "银行独有": [],
            "企业独有": [],
            "余额差异": []
        }
        
        # 创建索引提高查找效率
        银行已匹配 = set()
        企业已匹配 = set()
        
        # 第一轮：精确匹配
        print("  第一轮：精确匹配...")
        for i, 银行交易 in enumerate(self.银行数据):
            for j, 企业交易 in enumerate(self.企业数据):
                if j in 企业已匹配:
                    continue
                    
                # 检查是否完全匹配
                if (abs((银行交易["日期"] - 企业交易["日期"]).days) <= 容差天数 and
                    abs(银行交易["金额"] - 企业交易["金额"]) <= 容差金额):
                    
                    对账结果["完全匹配"].append({
                        "银行记录": 银行交易,
                        "企业记录": 企业交易,
                        "差异天数": abs((银行交易["日期"] - 企业交易["日期"]).days)
                    })
                    
                    银行已匹配.add(i)
                    企业已匹配.add(j)
                    break
        
        # 第二轮：模糊匹配（仅金额匹配）
        print("  第二轮：金额模糊匹配...")
        未匹配银行 = [i for i in range(len(self.银行数据)) if i not in 银行已匹配]
        未匹配企业 = [j for j in range(len(self.企业数据)) if j not in 企业已匹配]
        
        for i in 未匹配银行[:]:  # 使用副本，避免修改列表
            if i in 银行已匹配:
                continue
                
            银行交易 = self.银行数据[i]
            
            for j in 未匹配企业[:]:
                if j in 企业已匹配:
                    continue
                    
                企业交易 = self.企业数据[j]
                
                # 仅金额匹配，日期差异较大
                if (abs(银行交易["金额"] - 企业交易["金额"]) <= 容差金额 and
                    abs((银行交易["日期"] - 企业交易["日期"]).days) <= 容差天数 * 2):
                    
                    对账结果["金额匹配日期不同"].append({
                        "银行记录": 银行交易,
                        "企业记录": 企业交易,
                        "差异天数": abs((银行交易["日期"] - 企业交易["日期"]).days)
                    })
                    
                    银行已匹配.add(i)
                    企业已匹配.add(j)
                    未匹配银行.remove(i)
                    未匹配企业.remove(j)
                    break
        
        # 剩余记录
        for i in 未匹配银行:
            对账结果["银行独有"].append(self.银行数据[i])
        
        for j in 未匹配企业:
            对账结果["企业独有"].append(self.企业数据[j])
        
        # 检查余额差异
        if self.银行数据 and self.企业数据:
            银行最终余额 = self.银行数据[-1]["余额"]
            企业最终余额 = self.企业数据[-1]["余额"]
            余额差异 = 银行最终余额 - 企业最终余额
            
            if abs(余额差异) > 容差金额:
                对账结果["余额差异"].append({
                    "银行余额": 银行最终余额,
                    "企业余额": 企业最终余额,
                    "差异金额": 余额差异
                })
        
        self.对账结果 = 对账结果
        return 对账结果
    
    def 生成Excel报告(self, 文件名="银行对账报告.xlsx"):
        """生成专业的Excel对账报告"""
        
        wb = Workbook()
        
        # 1. 汇总报告
        汇总表 = wb.active
        汇总表.title = "对账汇总"
        
        # 标题
        汇总表["A1"] = "银行对账汇总报告"
        汇总表["A1"].font = Font(size=16, bold=True, color="FFFFFF")
        汇总表["A1"].fill = PatternFill(start_color="366092", end_color="366092", fill_type="solid")
        汇总表.merge_cells("A1:F1")
        
        # 对账结果汇总
        汇总数据 = [
            ["对账项目", "笔数", "金额范围", "状态"],
            ["完全匹配", len(self.对账结果["完全匹配"]), "完全一致", "✅ 正常"],
            ["金额匹配日期不同", len(self.对账结果["金额匹配日期不同"]), "时间差异", "⚠️ 关注"],
            ["银行独有", len(self.对账结果["银行独有"]), "银行有企业无", "❌ 未达"],
            ["企业独有", len(self.对账结果["企业独有"]), "企业有银行无", "❌ 未达"],
            ["余额差异", len(self.对账结果["余额差异"]), "余额不符", "❌ 异常"]
        ]
        
        for 行号, 数据行 in enumerate(汇总数据, 3):
            for 列号, 值 in enumerate(数据行, 1):
                单元格 = 汇总表.cell(row=行号, column=列号, value=值)
                if 行号 == 3:  # 表头
                    单元格.font = Font(bold=True)
                    单元格.fill = PatternFill(start_color="D9E2F3", end_color="D9E2F3", fill_type="solid")
        
        # 2. 明细表
        明细表 = wb.create_sheet("对账明细")
        明细表["A1"] = "对账明细记录"
        明细表["A1"].font = Font(size=14, bold=True)
        
        # 完全匹配明细
        行号 = 3
        明细表.cell(row=行号, column=1, value="完全匹配记录")
        明细表.cell(row=行号, column=1).font = Font(bold=True, color="008000")
        行号 += 1
        
        # 表头
        表头 = ["类型", "日期", "摘要", "金额", "余额", "状态"]
        for 列号, 标题 in enumerate(表头, 1):
            明细表.cell(row=行号, column=列号, value=标题)
            明细表.cell(row=行号, column=列号).font = Font(bold=True)
        行号 += 1
        
        # 写入完全匹配记录
        for 匹配 in self.对账结果["完全匹配"][:10]:  # 只显示前10条
            银行 = 匹配["银行记录"]
            企业 = 匹配["企业记录"]
            
            明细表.cell(row=行号, column=1, value="银行")
            明细表.cell(row=行号, column=2, value=银行["日期"].strftime("%Y-%m-%d"))
            明细表.cell(row=行号, column=3, value=银行["摘要"][:20])
            明细表.cell(row=行号, column=4, value=银行["金额"])
            明细表.cell(row=行号, column=5, value=银行.get("余额", ""))
            明细表.cell(row=行号, column=6, value="✅ 匹配")
            行号 += 1
            
            明细表.cell(row=行号, column=1, value="企业")
            明细表.cell(row=行号, column=2, value=企业["日期"].strftime("%Y-%m-%d"))
            明细表.cell(row=行号, column=3, value=企业["摘要"][:20])
            明细表.cell(row=行号, column=4, value=企业["金额"])
            明细表.cell(row=行号, column=5, value=企业.get("余额", ""))
            明细表.cell(row=行号, column=6, value="✅ 匹配")
            行号 += 2  # 空一行
        
        # 未达账项
        明细表.cell(row=行号, column=1, value="未达账项")
        明细表.cell(row=行号, column=1).font = Font(bold=True, color="FF0000")
        行号 += 1
        
        # 银行未达
        for 交易 in self.对账结果["银行未达"]:
            明细表.cell(row=行号, column=1, value="银行未达")
            明细表.cell(row=行号, column=2, value=交易["日期"].strftime("%Y-%m-%d"))
            明细表.cell(row=行号, column=3, value=交易["摘要"][:20])
            明细表.cell(row=行号, column=4, value=交易["金额"])
            明细表.cell(row=行号, column=6, value="❌ 银行独有")
            行号 += 1
        
        # 企业未达
        for 交易 in self.对账结果["企业未达"]:
            明细表.cell(row=行号, column=1, value="企业未达")
            明细表.cell(row=行号, column=2, value=交易["日期"].strftime("%Y-%m-%d"))
            明细表.cell(row=行号, column=3, value=交易["摘要"][:20])
            明细表.cell(row=行号, column=4, value=交易["金额"])
            明细表.cell(row=行号, column=6, value="❌ 企业独有")
            行号 += 1
        
        # 调整列宽
        for 列 in ["A", "B", "C", "D", "E", "F"]:
            明细表.column_dimensions[列].width = 15
        
        # 3. 差异分析表
        if self.对账结果["余额差异"]:
            差异表 = wb.create_sheet("余额差异分析")
            差异表["A1"] = "余额差异分析"
            差异表["A1"].font = Font(size=14, bold=True, color="FF0000")
            
            差异 = self.对账结果["余额差异"][0]
            差异表["A3"] = f"银行最终余额：{差异['银行余额']:,.2f}元"
            差异表["A4"] = f"企业最终余额：{差异['企业余额']:,.2f}元"
            差异表["A5"] = f"差异金额：{差异['差异金额']:,.2f}元"
            
            # 差异原因分析
            差异表["A7"] = "可能原因分析："
            差异表["A7"].font = Font(bold=True)
            
            原因列表 = [
                "1. 银行已入账，企业未获取回单",
                "2. 企业已记账，银行尚未处理", 
                "3. 存在在途资金",
                "4. 记账时间差异",
                "5. 可能存在记账错误"
            ]
            
            for i, 原因 in enumerate(原因列表, 8):
                差异表.cell(row=i, column=1, value=原因)
        
        # 保存文件
        wb.save(文件名)
        print(f"✅ Excel对账报告已生成：{文件名}")
        
        return 文件名

# 使用增强版对账系统
对账系统 = 银行对账系统()

# 加载数据（如果没有文件，创建示例数据）
if not os.path.exists("银行对账单.csv"):
    # 创建示例银行对账单
    with open("银行对账单.csv", "w", encoding="utf-8", newline='') as f:
        writer = csv.writer(f)
        writer.writerow(["交易日期", "摘要", "借方金额", "贷方金额", "余额"])
        数据 = [
            ["2024-01-01", "上月结转", "", "", "50000.00"],
            ["2024-01-05", "客户A货款", "", "25000.00", "75000.00"],
            ["2024-01-10", "供应商B付款", "15000.00", "", "60000.00"],
            ["2024-01-15", "工资发放", "35000.00", "", "25000.00"],
            ["2024-01-20", "客户C货款", "", "30000.00", "55000.00"],
            ["2024-01-25", "水电费", "1200.00", "", "53800.00"],
            ["2024-01-28", "客户D货款", "", "20000.00", "73800.00"],
            ["2024-01-30", "银行手续费", "50.00", "", "73750.00"]
        ]
        writer.writerows(数据)

if not os.path.exists("企业账目.csv"):
    # 创建示例企业账目（故意制造一些差异）
    with open("企业账目.csv", "w", encoding="utf-8", newline='') as f:
        writer = csv.writer(f)
        writer.writerow(["日期", "摘要", "借方", "贷方", "余额"])
        数据 = [
            ["2024-01-01", "上月结转", "", "", "50000.00"],
            ["2024-01-05", "客户A货款", "", "25000.00", "75000.00"],
            ["2024-01-10", "供应商B付款", "15000.00", "", "60000.00"],
            ["2024-01-15", "工资发放", "35000.00", "", "25000.00"],
            # 企业未记录客户C的货款
            ["2024-01-22", "客户E货款（未达）", "", "15000.00", "40000.00"],  # 银行未记录
            ["2024-01-25", "水电费", "1200.00", "", "38800.00"],
            ["2024-01-28", "客户D货款", "", "20000.00", "58800.00"],
            ["2024-01-30", "银行手续费", "50.00", "", "58750.00"]
        ]
        writer.writerows(数据)

# 执行对账
对账系统.加载银行数据("银行对账单.csv", 日期列="交易日期", 金额列="贷方金额", 摘要列="摘要", 余额列="余额")
对账系统.加载企业数据("企业账目.csv", 日期列="日期", 贷方列="贷方", 借方列="借方", 摘要列="摘要", 余额列="余额")

对账结果 = 对账系统.智能对账(容差天数=3, 容差金额=0.01)
excel报告 = 对账系统.生成Excel报告("银行对账报告_2024.xlsx")

print(f"\n📊 对账完成！")
print(f"Excel报告：{excel报告}")
```

</details>

<details>
<summary>版本3.0：专业对账系统</summary>

```python
# 专业版银行对账系统
print("=== 专业银行对账系统 ===")

import sqlite3
import hashlib
from datetime import datetime, timedelta
import pandas as pd
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.chart import LineChart, Reference

class 专业对账系统:
    def __init__(self):
        self.conn = sqlite3.connect(':memory:')  # 使用内存数据库
        self.创建数据库表()
        
    def 创建数据库表(self):
        """创建数据库表结构"""
        cursor = self.conn.cursor()
        
        # 银行交易表
        cursor.execute('''
            CREATE TABLE 银行交易 (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                交易日期 DATE,
                摘要 TEXT,
                借方金额 REAL,
                贷方金额 REAL,
                余额 REAL,
                交易哈希 TEXT UNIQUE,
                对账状态 TEXT DEFAULT '未对账',
                对账时间 TIMESTAMP,
                差异说明 TEXT
            )
        ''')
        
        # 企业账目表
        cursor.execute('''
            CREATE TABLE 企业账目 (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                日期 DATE,
                摘要 TEXT,
                借方 REAL,
                贷方 REAL,
                金额 REAL,
                余额 REAL,
                交易哈希 TEXT UNIQUE,
                对账状态 TEXT DEFAULT '未对账',
                对账时间 TIMESTAMP,
                差异说明 TEXT
            )
        ''')
        
        # 对账结果表
        cursor.execute('''
            CREATE TABLE 对账结果 (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                银行交易ID INTEGER,
                企业账目ID INTEGER,
                对账类型 TEXT,
                匹配度 REAL,
                差异说明 TEXT,
                对账时间 TIMESTAMP,
                操作员 TEXT,
                FOREIGN KEY (银行交易ID) REFERENCES 银行交易(id),
                FOREIGN KEY (企业账目ID) REFERENCES 企业账目(id)
            )
        ''')
        
        self.conn.commit()
    
    def 计算交易哈希(self, 日期, 金额, 摘要):
        """计算交易唯一哈希值"""
        哈希字符串 = f"{日期}_{金额}_{摘要[:10]}"
        return hashlib.md5(哈希字符串.encode()).hexdigest()
    
    def 导入银行数据(self, 数据框):
        """导入银行数据"""
        cursor = self.conn.cursor()
        
        导入数量 = 0
        for _, 行 in 数据框.iterrows():
            交易哈希 = self.计算交易哈希(行['交易日期'], 行['贷方金额'] - 行['借方金额'], 行['摘要'])
            
            try:
                cursor.execute('''
                    INSERT INTO 银行交易 (交易日期, 摘要, 借方金额, 贷方金额, 余额, 交易哈希)
                    VALUES (?, ?, ?, ?, ?, ?)
                ''', (行['交易日期'], 行['摘要'], 行['借方金额'], 行['贷方金额'], 行['余额'], 交易哈希))
                导入数量 += 1
            except sqlite3.IntegrityError:
                # 重复交易，跳过
                continue
        
        self.conn.commit()
        print(f"✅ 银行数据导入完成：{导入数量}笔")
        return 导入数量
    
    def 导入企业数据(self, 数据框):
        """导入企业数据"""
        cursor = self.conn.cursor()
        
        导入数量 = 0
        for _, 行 in 数据框.iterrows():
            金额 = 行['贷方'] - 行['借方']
            交易哈希 = self.计算交易哈希(行['日期'], 金额, 行['摘要'])
            
            try:
                cursor.execute('''
                    INSERT INTO 企业账目 (日期, 摘要, 借方, 贷方, 金额, 余额, 交易哈希)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                ''', (行['日期'], 行['摘要'], 行['借方'], 行['贷方'], 金额, 行['余额'], 交易哈希))
                导入数量 += 1
            except sqlite3.IntegrityError:
                # 重复交易，跳过
                continue
        
        self.conn.commit()
        print(f"✅ 企业数据导入完成：{导入数量}笔")
        return 导入数量
    
    def 执行智能对账(self, 容差天数=2, 容差金额=0.01):
        """执行智能对账"""
        cursor = self.conn.cursor()
        
        print("🔍 执行智能对账...")
        
        # 1. 精确匹配（哈希值相同）
        cursor.execute('''
            SELECT b.id, c.id, b.交易日期, c.日期, b.金额, c.金额, b.摘要, c.摘要
            FROM 银行交易 b
            JOIN 企业账目 c ON b.交易哈希 = c.交易哈希
            WHERE b.对账状态 = '未对账' AND c.对账状态 = '未对账'
        ''')
        
        精确匹配 = cursor.fetchall()
        print(f"  精确匹配：{len(精确匹配)}笔")
        
        for 匹配 in 精确匹配:
            银行ID, 企业ID = 匹配[0], 匹配[1]
            
            # 更新对账状态
            cursor.execute('UPDATE 银行交易 SET 对账状态=?, 对账时间=? WHERE id=?', 
                         ('已匹配', datetime.now(), 银行ID))
            cursor.execute('UPDATE 企业账目 SET 对账状态=?, 对账时间=? WHERE id=?', 
                         ('已匹配', datetime.now(), 企业ID))
            
            # 记录对账结果
            cursor.execute('''
                INSERT INTO 对账结果 (银行交易ID, 企业账目ID, 对账类型, 匹配度, 对账时间)
                VALUES (?, ?, ?, ?, ?)
            ''', (银行ID, 企业ID, '精确匹配', 1.0, datetime.now()))
        
        # 2. 模糊匹配（日期和金额相近）
        cursor.execute('''
            SELECT b.id, c.id, b.交易日期, c.日期, b.金额, c.金额, b.摘要, c.摘要
            FROM 银行交易 b, 企业账目 c
            WHERE b.对账状态 = '未对账' AND c.对账状态 = '未对账'
            AND ABS(b.金额 - c.金额) <= ?
            AND ABS(JULIANDAY(b.交易日期) - JULIANDAY(c.日期)) <= ?
        ''', (容差金额, 容差天数))
        
        模糊匹配 = cursor.fetchall()
        print(f"  模糊匹配：{len(模糊匹配)}笔")
        
        for 匹配 in 模糊匹配:
            银行ID, 企业ID, 银行日期, 企业日期, 银行金额, 企业金额, 银行摘要, 企业摘要 = 匹配
            
            # 计算匹配度
            日期差异 = abs((pd.to_datetime(银行日期) - pd.to_datetime(企业日期)).days)
            金额差异 = abs(银行金额 - 企业金额)
            匹配度 = max(0, 1 - 日期差异/容差天数 * 0.5 - 金额差异/max(abs(银行金额), abs(企业金额)) * 0.5)
            
            # 更新对账状态
            cursor.execute('UPDATE 银行交易 SET 对账状态=?, 对账时间=?, 差异说明=? WHERE id=?', 
                         ('模糊匹配', datetime.now(), f'日期差异{日期差异}天', 银行ID))
            cursor.execute('UPDATE 企业账目 SET 对账状态=?, 对账时间=?, 差异说明=? WHERE id=?', 
                         ('模糊匹配', datetime.now(), f'金额差异{金额差异:.2f}元', 企业ID))
            
            # 记录对账结果
            cursor.execute('''
                INSERT INTO 对账结果 (银行交易ID, 企业账目ID, 对账类型, 匹配度, 差异说明, 对账时间)
                VALUES (?, ?, ?, ?, ?, ?)
            ''', (银行ID, 企业ID, '模糊匹配', 匹配度, f'日期差异{日期差异}天,金额差异{金额差异:.2f}元', datetime.now()))
        
        self.conn.commit()
        
        # 统计结果
        cursor.execute('SELECT COUNT(*) FROM 银行交易 WHERE 对账状态="已匹配"')
        银行已匹配 = cursor.fetchone()[0]
        
        cursor.execute('SELECT COUNT(*) FROM 企业账目 WHERE 对账状态="已匹配"')
        企业已匹配 = cursor.fetchone()[0]
        
        cursor.execute('SELECT COUNT(*) FROM 银行交易 WHERE 对账状态="未对账"')
        银行未匹配 = cursor.fetchone()[0]
        
        cursor.execute('SELECT COUNT(*) FROM 企业账目 WHERE 对账状态="未对账"')
        企业未匹配 = cursor.fetchone()[0]
        
        return {
            "银行已匹配": 银行已匹配,
            "企业已匹配": 企业已匹配,
            "银行未匹配": 银行未匹配,
            "企业未匹配": 企业未匹配,
            "精确匹配": len(精确匹配),
            "模糊匹配": len(模糊匹配)
        }
    
    def 生成专业报告(self, 文件名="专业对账报告.xlsx"):
        """生成专业的Excel对账报告"""
        
        wb = Workbook()
        
        # 获取对账数据
        cursor = self.conn.cursor()
        
        # 1. 执行汇总
        汇总结果 = self.执行智能对账()
        
        # 2. 汇总报告表
        汇总表 = wb.active
        汇总表.title = "对账汇总"
        
        # 标题
        汇总表["A1"] = "银行对账汇总报告"
        汇总表["A1"].font = Font(size=18, bold=True, color="FFFFFF")
        汇总表["A1"].fill = PatternFill(start_color="366092", end_color="366092", fill_type="solid")
        汇总表.merge_cells("A1:F1")
        汇总表["A1"].alignment = Alignment(horizontal="center")
        
        # 基本信息
        汇总表["A3"] = f"报告生成时间：{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
        汇总表["A3"].font = Font(size=10, italic=True)
        
        # 对账结果汇总
        汇总数据 = [
            ["对账结果", "笔数", "占比", "状态说明"],
            ["精确匹配", 汇总结果["精确匹配"], f"{汇总结果['精确匹配']/max(汇总结果['银行已匹配'], 1)*100:.1f}%", "完全一致"],
            ["模糊匹配", 汇总结果["模糊匹配"], f"{汇总结果['模糊匹配']/max(汇总结果['银行已匹配'], 1)*100:.1f}%", "金额相近，日期差异"],
            ["银行未匹配", 汇总结果["银行未匹配"], f"{汇总结果['银行未匹配']/max(len(self.银行数据), 1)*100:.1f}%", "银行有，企业无"],
            ["企业未匹配", 汇总结果["企业未匹配"], f"{汇总结果['企业未匹配']/max(len(self.企业数据), 1)*100:.1f}%", "企业有，银行无"]
        ]
        
        起始行 = 5
        for 行号, 数据行 in enumerate(汇总数据, 起始行):
            for 列号, 值 in enumerate(数据行, 1):
                单元格 = 汇总表.cell(row=行号, column=列号, value=值)
                if 行号 == 起始行:
                    单元格.font = Font(bold=True)
                    单元格.fill = PatternFill(start_color="D9E2F3", end_color="D9E2F3", fill_type="solid")
        
        # 3. 未匹配明细表
        明细表 = wb.create_sheet("未匹配明细")
        
        # 银行未匹配
        cursor.execute('''
            SELECT 交易日期, 摘要, 借方金额, 贷方金额, 余额, 差异说明
            FROM 银行交易
            WHERE 对账状态 = '未对账'
            ORDER BY 交易日期
        ''')
        
        银行未匹配 = cursor.fetchall()
        
        明细表["A1"] = "银行未达账项"
        明细表["A1"].font = Font(size=14, bold=True, color="FF0000")
        
        if 银行未匹配:
            # 表头
            表头 = ["日期", "摘要", "借方", "贷方", "余额", "备注"]
            for 列号, 标题 in enumerate(表头, 1):
                明细表.cell(row=3, column=列号, value=标题)
                明细表.cell(row=3, column=列号).font = Font(bold=True)
            
            # 数据
            for 行号, 记录 in enumerate(银行未匹配, 4):
                for 列号, 值 in enumerate(记录, 1):
                    明细表.cell(row=行号, column=列号, value=值)
            
            # 小计
            小计行 = len(银行未匹配) + 5
            明细表.cell(row=小计行, column=1, value="小计")
            明细表.cell(row=小计行, column=3, value=f"=SUM(C4:C{小计行-1})")  # 借方合计
            明细表.cell(row=小计行, column=4, value=f"=SUM(D4:D{小计行-1})")  # 贷方合计
            明细表.cell(row=小计行, column=1).font = Font(bold=True)
        
        # 企业未匹配
        起始行 = len(银行未匹配) + 8 if 银行未匹配 else 5
        明细表.cell(row=起始行, column=1, value="企业未达账项")
        明细表.cell(row=起始行, column=1).font = Font(size=14, bold=True, color="FF0000")
        
        cursor.execute('''
            SELECT 日期, 摘要, 借方, 贷方, 余额, 差异说明
            FROM 企业账目
            WHERE 对账状态 = '未对账'
            ORDER BY 日期
        ''')
        
        企业未匹配 = cursor.fetchall()
        
        if 企业未匹配:
            数据起始行 = 起始行 + 2
            # 表头
            for 列号, 标题 in enumerate(["日期", "摘要", "借方", "贷方", "余额", "备注"], 1):
                明细表.cell(row=数据起始行, column=列号, value=标题)
                明细表.cell(row=数据起始行, column=列号).font = Font(bold=True)
            
            # 数据
            for 行号, 记录 in enumerate(企业未匹配, 数据起始行 + 1):
                for 列号, 值 in enumerate(记录, 1):
                    明细表.cell(row=行号, column=列号, value=值)
        
        # 调整列宽
        for 列 in ["A", "B", "C", "D", "E", "F"]:
            明细表.column_dimensions[列].width = 15
        
        # 4. 调整分录建议表
        建议表 = wb.create_sheet("调整分录建议")
        建议表["A1"] = "调整分录建议"
        建议表["A1"].font = Font(size=14, bold=True)
        
        调整建议 = [
            ["序号", "调整事项", "会计分录", "金额", "说明"],
            ["1", "银行已收企业未收", "借：银行存款\n贷：应收账款", "按未达金额", "银行已入账，企业未获取回单"],
            ["2", "银行已付企业未付", "借：应付账款\n贷：银行存款", "按未达金额", "银行已扣款，企业未获取回单"],
            ["3", "企业已收银行未收", "借：其他应收款\n贷：应收账款", "按未达金额", "企业已记账，银行尚未到账"],
            ["4", "企业已付银行未付", "借：应付账款\n贷：其他应付款", "按未达金额", "企业已付款，银行尚未扣款"]
        ]
        
        for 行号, 数据行 in enumerate(调整建议, 3):
            for 列号, 值 in enumerate(数据行, 1):
                单元格 = 建议表.cell(row=行号, column=列号, value=值)
                if 行号 == 3:
                    单元格.font = Font(bold=True)
                    单元格.fill = PatternFill(start_color="E8F4FD", end_color="E8F4FD", fill_type="solid")
                if 列号 == 3:  # 会计分录列
                    单元格.alignment = Alignment(wrap_text=True)
        
        # 调整列宽
        for 列号, 宽度 in enumerate([5, 15, 20, 12, 30], 1):
            列字母 = chr(64 + 列号)
            建议表.column_dimensions[列字母].width = 宽度
        
        # 保存文件
        wb.save(文件名)
        print(f"✅ 专业对账报告已生成：{文件名}")
        
        return 文件名

# 使用专业对账系统
专业系统 = 专业对账系统()

# 创建示例数据（如果没有真实数据）
import random
from datetime import datetime, timedelta

def 生成示例银行数据(文件名="示例银行数据.csv", 记录数=20):
    """生成示例银行数据"""
    起始日期 = datetime(2024, 1, 1)
    当前余额 = 50000
    
    数据 = []
    数据.append(["交易日期", "摘要", "借方金额", "贷方金额", "余额"])
    
    for i in range(记录数):
        日期 = 起始日期 + timedelta(days=random.randint(1, 30))
        
        # 随机生成交易
        交易类型 = random.choice(["收入", "支出"])
        if 交易类型 == "收入":
            金额 = random.randint(1000, 10000)
            摘要 = random.choice(["客户货款", "利息收入", "退款"])
            借方, 贷方 = 0, 金额
            当前余额 += 金额
        else:
            金额 = random.randint(500, 5000)
            摘要 = random.choice(["供应商付款", "工资", "水电费", "办公费"])
            借方, 贷方 = 金额, 0
            当前余额 -= 金额
        
        数据.append([
            日期.strftime("%Y-%m-%d"),
            摘要,
            f"{借方:.2f}",
            f"{贷方:.2f}",
            f"{当前余额:.2f}"
        ])
    
    with open(文件名, "w", encoding="utf-8", newline='') as f:
        writer = csv.writer(f)
        writer.writerows(数据)
    
    return 文件名

def 生成示例企业数据(文件名="示例企业数据.csv", 记录数=18):
    """生成示例企业数据（故意制造一些差异）"""
    起始日期 = datetime(2024, 1, 1)
    当前余额 = 50000
    
    数据 = []
    数据.append(["日期", "摘要", "借方", "贷方", "余额"])
    
    交易列表 = [
        ("2024-01-01", "上月结转", 0, 0, 50000),
        ("2024-01-05", "客户A货款", 0, 25000, 75000),
        ("2024-01-10", "供应商B付款", 15000, 0, 60000),
        ("2024-01-15", "工资发放", 35000, 0, 25000),
        # 缺少客户C的记录（银行未达）
        ("2024-01-22", "客户E货款（未达）", 0, 15000, 40000),  # 银行没有这笔
        ("2024-01-25", "水电费", 1200, 0, 38800),
        ("2024-01-28", "客户D货款", 0, 20000, 58800),
        ("2024-01-30", "银行手续费", 50, 0, 58750),
        # 添加一些银行没有的交易
        ("2024-02-05", "预收客户款", 0, 8000, 66750),
        ("2024-02-10", "预付供应商款", 5000, 0, 61750),
    ]
    
    for 日期, 摘要, 借方, 贷方, 余额 in 交易列表:
        数据.append([日期, 摘要, f"{借方:.2f}", f"{贷方:.2f}", f"{余额:.2f}"])
    
    # 添加一些随机交易
    起始日期 = datetime(2024, 2, 15)
    for i in range(记录数 - len(交易列表)):
        日期 = 起始日期 + timedelta(days=random.randint(1, 30))
        
        交易类型 = random.choice(["收入", "支出"])
        if 交易类型 == "收入":
            金额 = random.randint(2000, 8000)
            摘要 = random.choice(["服务费收入", "其他收入"])
            借方, 贷方 = 0, 金额
        else:
            金额 = random.randint(1000, 3000)
            摘要 = random.choice(["办公费", "差旅费", "通讯费"])
            借方, 贷方 = 金额, 0
        
        当前余额 = 当前余额 - 借方 + 贷方
        
        数据.append([
            日期.strftime("%Y-%m-%d"),
            摘要,
            f"{借方:.2f}",
            f"{贷方:.2f}",
            f"{当前余额:.2f}"
        ])
    
    with open(文件名, "w", encoding="utf-8", newline='') as f:
        writer = csv.writer(f)
        writer.writerows(数据)
    
    return 文件名

# 生成示例数据
银行文件 = 生成示例银行数据("专业银行数据.csv", 25)
企业文件 = 生成示例企业数据("专业企业数据.csv", 22)

# 加载数据
银行df = pd.read_csv(银行文件)
企业df = pd.read_csv(企业文件)

# 数据预处理
银行df['交易日期'] = pd.to_datetime(银行df['交易日期'])
银行df['借方金额'] = pd.to_numeric(银行df['借方金额'], errors='coerce').fillna(0)
银行df['贷方金额'] = pd.to_numeric(银行df['贷方金额'], errors='coerce').fillna(0)
银行df['余额'] = pd.to_numeric(银行df['余额'], errors='coerce').fillna(0)

企业df['日期'] = pd.to_datetime(企业df['日期'])
企业df['借方'] = pd.to_numeric(企业df['借方'], errors='coerce').fillna(0)
企业df['贷方'] = pd.to_numeric(企业df['贷方'], errors='coerce').fillna(0)
企业df['余额'] = pd.to_numeric(企业df['余额'], errors='coerce').fillna(0)

# 导入数据
专业系统.导入银行数据(银行df)
专业系统.导入企业数据(企业df)

# 执行对账
对账统计 = 专业系统.执行智能对账(容差天数=3, 容差金额=0.01)

# 生成专业报告
专业报告 = 专业系统.生成专业报告("专业银行对账报告.xlsx")

print(f"\n📊 专业对账完成！")
print(f"报告文件：{专业报告}")
print(f"\n对账统计：")
for 项目, 数量 in 对账统计.items():
    print(f"  {项目}：{数量}")
```

</details>

***

### 💭 今日思考

通过今天的学习，我们发现：
- CSV文件是Python和Excel之间的桥梁，简单实用
- Python读写Excel比手工操作更快、更准确
- 自动化对账能大大减少财务人员的工作量
- 专业的对账系统能发现人工容易忽略的问题

***

### 📝 课后小结

- ✅ 学会了读取CSV文件的各种方法
- ✅ 掌握了写入Excel文件的技能
- ✅ 能够创建专业的财务报告
- ✅ 实现了自动化银行对账系统

***

### 🎯 下节预告

下节我们将学习**pandas入门：数据处理的瑞士军刀**，认识Python中最强大的数据处理库，它能让你像Excel一样处理数据，但比Excel更快、更智能！

**准备好迎接Python数据分析的终极武器了吗？**

***

### 💡 小贴士

- CSV文件要确保编码正确（通常是UTF-8）
- Excel写入时要注意数据格式和样式
- 对账系统要设置合理的容差范围
- 多练习文件操作，这是自动化办公的基础

***

> 🤖 Powered by Kimi K2 0905 💻 内容经葵葵🌻审核与修改

***
