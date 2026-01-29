---
title: Python-第9篇《pandas入门：数据处理的瑞士军刀》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐果果课程
abbrlink: '889621e3'
date: 2026-01-30 03:03:20
tags:
---

### 📖 开篇语

还记得你第一次用数据透视表的情景吗？
> “哇，拖拽几下就能统计出各种维度的数据，太神奇了！”
今天我们要学的pandas，就是Python的“超级数据透视表”。
它不仅能做Excel的所有操作，还能做得更快、更智能、更自动化！

<!--more-->

**想象一下：**
- 几秒钟就能处理几十万行数据
- 一行代码完成复杂的分组统计
- 自动识别数据类型，智能处理缺失值
- 轻松实现Excel做不到的高级分析
这就是pandas——数据处理的终极效率神器！

***

### 🎯 今日学习目标

- 理解DataFrame概念（Excel表格的升级版）
- 掌握基本的数据筛选和统计（比数据透视表更快）
- 实战销售数据分析（自动生成分析报告）

***

### 🐼 什么是pandas？

**pandas = Python Data Analysis Library**

pandas是Python最专业的数据处理库，就像：
- Excel的“超级加强版”
- 数据透视表的“终极形态”
- 数据处理的“瑞士军刀”

**为什么财务人员要学pandas？**
| Excel操作      | pandas代码                       | 效率提升 |
| ------------ | ------------------------------ | ---- |
| 手动筛选10000行数据 | `df[df['金额']>1000]`            | 10倍  |
| 数据透视表统计      | `df.groupby('部门')['金额'].sum()` | 5倍   |
| VLOOKUP查找    | `df.merge(另一个表, on='客户ID')`    | 8倍   |
| 手动制作图表       | `df.plot(kind='bar')`          | 6倍   |

***

### 📊 DataFrame：Excel表格的升级版

**什么是DataFrame？**

想象Excel工作表：
- 有行号（1,2,3...）
- 有列名（A,B,C...或自定义）
- 每个格子有数据
- 
DataFrame就是一样的概念，但更强大！
```python
import pandas as pd

# 创建财务DataFrame（就像创建Excel表格）
销售数据 = pd.DataFrame({
    '日期': ['2024-01-01', '2024-01-02', '2024-01-03', '2024-01-04'],
    '销售员': ['张三', '李四', '王五', '张三'],
    '客户': ['客户A', '客户B', '客户C', '客户A'],
    '产品': ['产品1', '产品2', '产品1', '产品3'],
    '数量': [100, 150, 200, 80],
    '单价': [50, 80, 50, 120],
    '金额': [5000, 12000, 10000, 9600]
})

print("销售数据表：")
print(销售数据)
```

输出结果：
```
         日期 销售员   客户   产品  数量   单价   金额
0  2024-01-01  张三  客户A  产品1  100   50  5000
1  2024-01-02  李四  客户B  产品2  150   80 12000
2  2024-01-03  王五  客户C  产品1  200   50 10000
3  2024-01-04  张三  客户A  产品3   80  120  9600
```

**DataFrame vs Excel表格**
| Excel      | DataFrame                      | 优势    |
| ---------- | ------------------------------ | ----- |
| A1, B1, C1 | df\['日期'], df\['销售员']          | 列名更直观 |
| 筛选：手动点击    | df\[df\['金额']>10000]           | 代码自动化 |
| 统计：数据透视表   | df.groupby('销售员')\['金额'].sum() | 一行代码  |
| 查找：VLOOKUP | df.merge(另一个表)                 | 更灵活强大 |

**读取Excel/CVS文件（数据入口）**
```python
# 从Excel读取财务数据（就像打开Excel文件）
财务数据 = pd.read_excel('月度财务报表.xlsx')
# 或
财务数据 = pd.read_csv('银行流水.csv')

print("数据形状：", 财务数据.shape)  # (行数, 列数)
print("列名：", 财务数据.columns.tolist())
print("前5行：")
print(财务数据.head())  # 就像Excel的前几行
print("数据类型：")
print(财务数据.dtypes)  # 自动识别每列的数据类型
```

**基本属性（了解你的数据）**
```python
# 继续使用上面的销售数据
print("数据基本信息：")
print(f"形状：{销售数据.shape}")  # (4行, 7列)
print(f"列名：{销售数据.columns.tolist()}")
print(f"索引：{销售数据.index.tolist()}")

print("\n每列的数据类型：")
print(销售数据.dtypes)
# 日期    object
# 销售员   object  
# 客户    object
# 产品    object
# 数量     int64
# 单价     int64
# 金额     int64

print("\n数据统计摘要：")
print(销售数据.describe())  # 就像Excel的描述性统计
```

***

### 🔍 数据筛选：比Excel筛选更智能

**基础筛选（类似Excel的自动筛选）**
```python
# 筛选出张三的销售记录
张三的销售 = 销售数据[销售数据['销售员'] == '张三']
print("张三的销售记录：")
print(张三的销售)

# 筛选出金额大于10000的记录
大额销售 = 销售数据[销售数据['金额'] > 10000]
print("\n大额销售（>10000元）：")
print(大额销售)

# 多条件筛选（Excel需要高级筛选，pandas只需要&符号）
张三的大额销售 = 销售数据[(销售数据['销售员'] == '张三') & (销售数据['金额'] > 5000)]
print("\n张三的大额销售：")
print(张三的大额销售)

# 筛选特定日期的销售
一月上旬销售 = 销售数据[销售数据['日期'].isin(['2024-01-01', '2024-01-02'])]
print("\n一月上旬销售：")
print(一月上旬销售)
```

**高级筛选（Excel做不到的筛选）**
```python
# 字符串筛选
产品1销售 = 销售数据[销售数据['产品'].str.contains('产品1')]
print("产品1的销售记录：")
print(产品1销售)

# 多值筛选
重点客户 = ['客户A', '客户C']
重点客户销售 = 销售数据[销售数据['客户'].isin(重点客户)]
print("\n重点客户的销售：")
print(重点客户销售)

# 范围筛选
中等金额销售 = 销售数据[(销售_data['金额'] >= 8000) & (销售_data['金额'] <= 12000)]
print("\n中等金额销售（8000-12000元）：")
print(中等金额销售)
```

***

### 📈 数据统计：比数据透视表更快

**基础统计（一行代码搞定）**
```python
# 计算总销售额
总销售额 = 销售数据['金额'].sum()
print(f"总销售额：{总销售额:,}元")

# 平均销售额
平均销售额 = 销售数据['金额'].mean()
print(f"平均销售额：{平均销售额:,.2f}元")

# 最大/最小销售额
最大销售额 = 销售数据['金额'].max()
最小销售额 = 销售_data['金额'].min()
print(f"最大销售额：{最大销售额:,}元")
print(f"最小销售额：{最小销售额:,}元")

# 销售数量统计
总销售数量 = 销售数据['数量'].sum()
平均单价 = 销售数据['单价'].mean()
print(f"总销售数量：{总销售数量:,}件")
print(f"平均单价：{平均单价:,.2f}元")
```

**分组统计（超级数据透视表）**
```python
# 按销售员统计销售额（类似数据透视表）
销售员统计 = 销售_data.groupby('销售员')['金额'].sum()
print("各销售员销售额：")
print(销售员统计)

# 按客户统计（多列统计）
客户统计 = 销售数据.groupby('客户').agg({
    '金额': 'sum',      # 总金额
    '数量': 'sum',      # 总数量
    '单价': 'mean'      # 平均单价
})
print("\n各客户购买统计：")
print(客户统计)

# 多层分组（销售员+客户）
多层统计 = 销售数据.groupby(['销售员', '客户'])['金额'].sum()
print("\n销售员-客户销售额：")
print(多层统计)

# 重置索引，让结果更美观
多层统计_df = 销售数据.groupby(['销售员', '客户']).agg({
    '金额': 'sum',
    '数量': 'sum'
}).reset_index()
print("\n销售员-客户统计表：")
print(多层统计_df)
```

***

### 🧮 财务实战：销售数据分析

<details>
<summary>版本1.0：基础销售分析</summary>

```python
# 销售数据分析 - 基础版
print("=== 销售数据分析系统 ===")

import pandas as pd
import numpy as np

# 创建更真实的销售数据
np.random.seed(42)  # 保证结果可重复

# 生成月度销售数据
日期范围 = pd.date_range('2024-01-01', '2024-01-31', freq='D')
销售员列表 = ['张三', '李四', '王五', '赵六', '钱七']
客户列表 = ['客户A', '客户B', '客户C', '客户D', '客户E']
产品列表 = ['产品1', '产品2', '产品3', '产品4']

销售数据 = []
for 日期 in 日期范围:
    # 每天随机2-5笔销售
    日销售笔数 = np.random.randint(2, 6)
    
    for _ in range(日销售笔数):
        销售员 = np.random.choice(销售员_list)
        客户 = np.random.choice(客户_list)
        产品 = np.random.choice(产品列表)
        数量 = np.random.randint(10, 201)
        单价 = np.random.randint(50, 201)
        
        销售数据.append({
            '日期': 日期,
            '销售员': 销售员,
            '客户': 客户,
            '产品': 产品,
            '数量': 数量,
            '单价': 单价,
            '金额': 数量 * 单价
        })

# 创建DataFrame
df = pd.DataFrame(销售数据)
df['日期'] = pd.to_datetime(df['日期'])  # 确保日期格式正确

print("📊 销售数据概览：")
print(f"数据形状：{df.shape}")
print(f"日期范围：{df['日期'].min()} 到 {df['日期'].max()}")
print(f"总销售额：{df['金额'].sum():,.2f}元")

# 基础分析
print("\n=== 基础销售分析 ===")

# 1. 日销售额统计
日销售额 = df.groupby('日期')['金额'].sum()
print(f"\n📅 日销售额统计（前5天）：")
print(日销售额.head())

# 2. 销售员业绩排名
销售员业绩 = df.groupby('销售员').agg({
    '金额': 'sum',
    '数量': 'sum',
    '日期': 'count'  # 销售笔数
}).round(2)
销售员业绩.columns = ['总销售额', '总数量', '销售笔数']
销售员业绩 = 销售员业绩.sort_values('总销售额', ascending=False)
print(f"\n🏆 销售员业绩排名：")
print(销售员业绩)

# 3. 客户购买分析
客户分析 = df.groupby('客户').agg({
    '金额': ['sum', 'mean', 'count'],
    '数量': 'sum'
}).round(2)
客户分析.columns = ['总购买额', '平均购买额', '购买次数', '总数量']
客户分析 = 客户分析.sort_values('总购买额', ascending=False)
print(f"\n💰 客户购买分析：")
print(客户分析)

# 4. 产品销售分析
产品分析 = df.groupby('产品').agg({
    '金额': 'sum',
    '数量': 'sum',
    '单价': 'mean'
}).round(2)
产品分析 = 产品分析.sort_values('金额', ascending=False)
产品分析.columns = ['销售额', '销售数量', '平均单价']
print(f"\n📦 产品销售分析：")
print(产品分析)
```

</details>

<details>
<summary>版本2.0：高级分析功能</summary>

```python
# 销售数据分析 - 高级版
print("\n=== 高级销售分析 ===")

# 1. 时间序列分析
print("\n📈 时间序列分析：")

# 按周统计
df['周'] = df['日期'].dt.isocalendar().week
周销售额 = df.groupby('周')['金额'].agg(['sum', 'mean', 'count'])
周销售额.columns = ['周销售总额', '日均销售额', '销售天数']
print("按周销售统计：")
print(周销售额)

# 工作日vs周末分析
df['是否周末'] = df['日期'].dt.dayofweek >= 5
周末分析 = df.groupby('是否周末')['金额'].agg(['sum', 'mean', 'count'])
周末分析.index = ['工作日', '周末']
周末分析.columns = ['销售额', '平均日销售额', '天数']
print("\n工作日vs周末销售对比：")
print(周末分析)

# 2. 交叉分析（数据透视表）
print("\n📊 交叉分析：")

# 销售员-客户交叉表
交叉表 = pd.crosstab(df['销售员'], df['客户'], values=df['金额'], aggfunc='sum')
交叉表 = 交叉表.fillna(0)  # 填充NaN为0
print("销售员-客户销售交叉表（金额）：")
print(交叉表)

# 销售员-产品交叉表（显示多个指标）
透视表 = df.pivot_table(values='金额', index='销售员', columns='产品', aggfunc='sum', fill_value=0)
print("\n销售员-产品销售透视表：")
print(透视表)

# 3. 排名和百分比分析
print("\n🏅 排名分析：")

# 销售员日销售额排名
日销售员排名 = df.groupby(['日期', '销售员'])['金额'].sum().reset_index()
日销售员排名['排名'] =日销售员排名.groupby('日期')['金额'].rank(ascending=False, method='dense')
print("每日销售员排名（前10名）：")
print(日销售员排名.head(10))

# 4. 异常检测
print("\n⚠️ 异常检测：")

# 检测异常高销售额（超过平均值2个标准差）
平均日销售额 = df.groupby('日期')['金额'].sum().mean()
日销售额标准差 = df.groupby('日期')['金额'].sum().std()
异常阈值 = 平均日销售额 + 2 * 日销售额标准差

异常日期 = df.groupby('日期')['金额'].sum()[df.groupby('日期')['金额'].sum() > 异常阈值]
if len(异常日期) > 0:
    print("异常高销售额日期：")
    for 日期, 金额 in 异常日期.items():
        print(f"  {日期.strftime('%Y-%m-%d')}：{金额:,.2f}元（超出正常范围）")
else:
    print("  未发现异常高销售额日期")

# 检测异常单价
产品单价统计 = df.groupby('产品')['单价'].agg(['mean', 'std'])
for 产品 in 产品单价统计.index:
    平均单价 = 产品单价统计.loc[产品, 'mean']
    标准差 = 产品单价统计.loc[产品, 'std']
    if pd.notna(标准差) and 标准差 > 0:
        异常单价阈值 = 平均单价 + 2 * 标准差
        异常记录 = df[(df['产品'] == 产品) & (df['单价'] > 异常单价阈值)]
        if len(异常记录) > 0:
            print(f"\n{产品}异常高单价记录：")
            for _, 记录 in 异常记录.iterrows():
                print(f"  {记录['日期'].strftime('%Y-%m-%d')}：单价{记录['单价']}元（平均{平均单价:.0f}元）")
```

</details>

<details>
<summary>版本3.0：专业分析报告</summary>

```python
# 销售数据分析 - 专业版
print("\n=== 专业销售分析报告 ===")

from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.chart import LineChart, BarChart, Reference
import matplotlib.pyplot as plt

def 生成专业销售报告(df, 文件名="销售分析报告.xlsx"):
    """生成专业的销售分析报告"""
    
    # 创建工作簿
    wb = Workbook()
    
    # 1. 执行汇总表
    汇总表 = wb.active
    汇总表.title = "执行汇总"
    
    # 标题
    汇总表["A1"] = "销售数据分析报告"
    汇总表["A1"].font = Font(size=18, bold=True, color="FFFFFF")
    汇总表["A1"].fill = PatternFill(start_color="366092", end_color="366092", fill_type="solid")
    汇总表.merge_cells("A1:H1")
    汇总表["A1"].alignment = Alignment(horizontal="center")
    
    # 基本信息
    汇总表["A3"] = f"报告生成时间：{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
    汇总表["A4"] = f"分析期间：{df['日期'].min().strftime('%Y-%m-%d')} 至 {df['日期'].max().strftime('%Y-%m-%d')}"
    汇总表["A5"] = f"数据记录数：{len(df)}笔"
    
    # 关键指标
    关键指标 = [
        ["关键指标", "数值", "单位", "说明"],
        ["总销售额", f"{df['金额'].sum():,.2f}", "元", "期间内所有销售金额合计"],
        ["平均日销售额", f"{df.groupby('日期')['金额'].sum().mean():,.2f}", "元", "日均销售水平"],
        ["总销售数量", f"{df['数量'].sum():,}", "件", "期间内所有销售数量合计"],
        ["平均单价", f"{df['单价'].mean():.2f}", "元", "所有产品的平均单价"],
        ["销售笔数", f"{len(df):,}", "笔", "期间内总销售笔数"],
        ["客单价", f"{df['金额'].mean():.2f}", "元", "平均每笔销售金额"],
        ["销售员数量", f"{df['销售员'].nunique()}", "人", "参与销售的销售员人数"],
        ["客户数量", f"{df['客户'].nunique()}", "个", "购买产品的客户数量"],
        ["产品种类", f"{df['产品'].nunique()}", "种", "销售的产品种类数量"]
    ]
    
    起始行 = 7
    for 行号, 数据行 in enumerate(关键指标, 起始行):
        for 列号, 值 in enumerate(数据行, 1):
            单元格 = 汇总表.cell(row=行号, column=列号, value=值)
            if 行号 == 起始行:
                单元格.font = Font(bold=True)
                单元格.fill = PatternFill(start_color="D9E2F3", end_color="D9E2F3", fill_type="solid")
    
    # 调整列宽
    for 列 in ["A", "B", "C", "D"]:
        汇总表.column_dimensions[列].width = 20
    
    # 2. 销售员业绩表
    业绩表 = wb.create_sheet("销售员业绩")
    
    业绩表["A1"] = "销售员业绩排名"
    业绩表["A1"].font = Font(size=14, bold=True)
    
    # 获取业绩数据
    销售员业绩 = df.groupby('销售员').agg({
        '金额': ['sum', 'mean', 'count'],
        '数量': 'sum'
    }).round(2)
    
    销售员业绩.columns = ['总销售额', '平均销售额', '销售笔数', '总数量']
    销售员业绩 = 销售员业绩.sort_values('总销售额', ascending=False)
    销售员业绩['排名'] = range(1, len(销售员业绩) + 1)
    
    # 写入表头
    表头 = ['排名', '销售员', '总销售额', '平均销售额', '销售笔数', '总数量', '占比']
    for 列号, 标题 in enumerate(表头, 1):
        单元格 = 业绩表.cell(row=3, column=列号, value=标题)
        单元格.font = Font(bold=True)
        单元格.fill = PatternFill(start_color="E8F4FD", end_color="E8F4FD", fill_type="solid")
    
    # 写入数据
    总销售额 = df['金额'].sum()
    for 行号, (销售员, 数据) in enumerate(销售员业绩.iterrows(), 4):
        业绩表.cell(row=行号, column=1, value=数据['排名'])
        业绩表.cell(row=行号, column=2, value=销售员)
        业绩表.cell(row=行号, column=3, value=数据['总销售额'])
        业绩表.cell(row=行号, column=4, value=数据['平均销售额'])
        业绩表.cell(row=行号, column=5, value=数据['销售笔数'])
        业绩表.cell(row=行号, column=6, value=数据['总数量'])
        业绩表.cell(row=行号, column=7, value=f"{数据['总销售额']/总销售额*100:.1f}%")
    
    # 添加图表数据
    图表数据起始行 = len(销售员业绩) + 6
    业绩表.cell(row=图表数据起始行, column=1, value="图表数据")
    业绩表.cell(row=图表数据起始行, column=1).font = Font(bold=True)
    
    for i, (销售员, 数据) in enumerate(销售员业绩.iterrows(), 图表数据起始行 + 1):
        业绩表.cell(row=i, column=1, value=销售员)
        业绩表.cell(row=i, column=2, value=数据['总销售额'])
    
    # 创建柱状图
    图表 = BarChart()
    图表.title = "销售员销售额对比"
    图表.style = 10
    图表.y_axis.title = '销售额（元）'
    图表.x_axis.title = '销售员'
    
    数据 = Reference(业绩表, min_col=2, min_row=图表数据起始行 + 1, max_row=图表数据起始行 + len(销售员业绩), max_col=2)
    分类 = Reference(业绩表, min_col=1, min_row=图表数据起始行 + 1, max_row=图表数据起始行 + len(销售员业绩))
    
    图表.add_data(data)
    图表.set_categories(分类)
    业绩表.add_chart(图表, "I3")
    
    # 3. 客户分析表
    客户表 = wb.create_sheet("客户分析")
    
    客户表["A1"] = "客户购买分析"
    客户表["A1"].font = Font(size=14, bold=True)
    
    # 客户分析数据
    客户分析 = df.groupby('客户').agg({
        '金额': ['sum', 'mean', 'count'],
        '数量': 'sum'
    }).round(2)
    
    客户分析.columns = ['总购买额', '平均购买额', '购买次数', '总数量']
    客户分析 = 客户分析.sort_values('总购买额', ascending=False)
    
    # 写入数据
    表头 = ['客户', '总购买额', '平均购买额', '购买次数', '总数量', '客单价', '等级']
    for 列号, 标题 in enumerate(表头, 1):
        单元格 = 客户表.cell(row=3, column=列号, value=标题)
        单元格.font = Font(bold=True)
        单元格.fill = PatternFill(start_color="E8F4FD", end_color="E8F4FD", fill_type="solid")
    
    for 行号, (客户, 数据) in enumerate(客户分析.iterrows(), 4):
        客户表.cell(row=行号, column=1, value=客户)
        客户表.cell(row=行号, column=2, value=数据['总购买额'])
        客户表.cell(row=行号, column=3, value=数据['平均购买额'])
        客户表.cell(row=行号, column=4, value=数据['购买次数'])
        客户表.cell(row=行号, column=5, value=数据['总数量'])
        客户表.cell(row=行号, column=6, value=数据['总购买额']/数据['购买次数'])
        
        # 客户分级
        if 数据['总购买额'] > 20000:
            等级 = "VIP客户"
        elif 数据['总购买额'] > 10000:
            等级 = "重点客户"
        elif 数据['总购买额'] > 5000:
            等级 = "普通客户"
        else:
            等级 = "小客户"
        
        客户表.cell(row=行号, column=7, value=等级)
    
    # 4. 时间分析表
    时间表 = wb.create_sheet("时间分析")
    
    时间表["A1"] = "时间序列分析"
    时间表["A1"].font = Font(size=14, bold=True)
    
    # 日销售额
    日销售额 = df.groupby('日期')['金额'].agg(['sum', 'count']).reset_index()
    日销售额.columns = ['日期', '销售额', '笔数']
    
    # 写入数据
    时间表["A3"] = "日销售额统计"
    时间表["A3"].font = Font(bold=True)
    
    表头 = ['日期', '销售额', '笔数', '日均单价']
    for 列号, 标题 in enumerate(表头, 1):
        单元格 = 时间表.cell(row=5, column=列号, value=标题)
        单元格.font = Font(bold=True)
    
    for 行号, (_, 数据) in enumerate(日销售额.iterrows(), 6):
        时间表.cell(row=行号, column=1, value=数据['日期'].strftime('%m-%d'))
        时间表.cell(row=行号, column=2, value=数据['销售额'])
        时间表.cell(row=行号, column=3, value=数据['笔数'])
        时间表.cell(row=行号, column=4, value=数据['销售额']/数据['笔数'] if 数据['笔数'] > 0 else 0)
    
    # 创建折线图
    折线图 = LineChart()
    折线图.title = "日销售额趋势"
    折线图.style = 2
    折线图.y_axis.title = '销售额（元）'
    折线图.x_axis.title = '日期'
    
    数据 = Reference(时间表, min_col=2, min_row=6, max_row=6 + len(日销售额), max_col=2)
    分类 = Reference(时间表, min_col=1, min_row=6, max_row=6 + len(日销售额))
    
    折线图.add_data(data, titles_from_data=True)
    折线图.set_categories(分类)
    时间表.add_chart(折线图, "F5")
    
    # 保存文件
    wb.save(文件名)
    print(f"✅ 专业销售报告已生成：{文件名}")
    
    return 文件名

# 生成专业报告
专业报告 = 生成专业销售报告(df)

# 额外：生成数据可视化图表（matplotlib）
print("\n📊 生成数据可视化图表...")

plt.rcParams['font.sans-serif'] = ['SimHei']  # 设置中文字体
plt.rcParams['axes.unicode_minus'] = False   # 正确显示负号

# 1. 销售员业绩柱状图
plt.figure(figsize=(10, 6))
销售员业绩 = df.groupby('销售员')['金额'].sum().sort_values(ascending=False)
plt.bar(销售员业绩.index, 销售员业绩.values, color='skyblue')
plt.title('销售员业绩对比', fontsize=16)
plt.xlabel('销售员', fontsize=12)
plt.ylabel('销售额（元）', fontsize=12)
plt.xticks(rotation=45)
for i, v in enumerate(销售员业绩.values):
    plt.text(i, v + 1000, f'{v:,.0f}', ha='center', va='bottom')
plt.tight_layout()
plt.savefig('销售员业绩对比.png', dpi=300, bbox_inches='tight')
plt.close()

# 2. 客户购买额饼图
plt.figure(figsize=(8, 8))
客户购买 = df.groupby('客户')['金额'].sum()
plt.pie(客户购买.values, labels=客户购买.index, autopct='%1.1f%%', startangle=90)
plt.title('客户购买分布', fontsize=16)
plt.axis('equal')
plt.savefig('客户购买分布.png', dpi=300, bbox_inches='tight')
plt.close()

# 3. 日销售额趋势图
plt.figure(figsize=(12, 6))
日销售额 = df.groupby('日期')['金额'].sum()
plt.plot(日销售额.index, 日销售额.values, marker='o', linewidth=2, markersize=4)
plt.title('日销售额趋势', fontsize=16)
plt.xlabel('日期', fontsize=12)
plt.ylabel('销售额（元）', fontsize=12)
plt.grid(True, alpha=0.3)
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('日销售额趋势.png', dpi=300, bbox_inches='tight')
plt.close()

print("✅ 可视化图表已生成！")
```

</details>

***

### 🏃‍♀️ 进阶小挑战

<details>
<summary>挑战1：财务比率分析</summary>

```python
# 财务比率分析工具
print("=== 财务比率分析工具 ===")

def 计算财务比率(资产负债表, 利润表):
    """
    计算常用财务比率
    
    参数：
    资产负债表：包含资产、负债、所有者权益的DataFrame
    利润表：包含收入、成本、费用的DataFrame
    
    返回：
    财务比率字典
    """
    
    # 从数据中提取关键数据
    总资产 = 资产负债表['总资产'].iloc[-1]
    总负债 = 资产负债表['总负债'].iloc[-1]
    所有者权益 = 资产负债表['所有者权益'].iloc[-1]
    流动资产 = 资产负债表['流动资产'].iloc[-1]
    流动负债 = 资产负债表['流动负债'].iloc[-1]
    存货 = 资产负债表['存货'].iloc[-1]
    应收账款 = 资产负债表['应收账款'].iloc[-1]
    
    营业收入 = 利润表['营业收入'].iloc[-1]
    营业成本 = 利润表['营业成本'].iloc[-1]
    净利润 = 利润表['净利润'].iloc[-1]
    利息费用 = 利润表.get('利息费用', pd.Series([0])).iloc[-1]
    
    # 计算财务比率
    财务比率 = {
        # 偿债能力比率
        "流动比率": 流动资产 / 流动负债 if 流动负债 > 0 else None,
        "速动比率": (流动资产 - 存货) / 流动负债 if 流动负债 > 0 else None,
        "资产负债率": 总负债 / 总资产 if 总资产 > 0 else None,
        "权益乘数": 总资产 / 所有者权益 if 所有者权益 > 0 else None,
        
        # 营运能力比率
        "应收账款周转率": 营业收入 / 应收账款 if 应收账款 > 0 else None,
        "存货周转率": 营业成本 / 存货 if 存货 > 0 else None,
        "总资产周转率": 营业收入 / 总资产 if 总资产 > 0 else None,
        
        # 盈利能力比率
        "销售净利率": 净利润 / 营业收入 if 营业收入 > 0 else None,
        "资产净利率": 净利润 / 总资产 if 总资产 > 0 else None,
        "净资产收益率": 净利润 / 所有者权益 if 所有者权益 > 0 else None,
        
        # 杠杆比率
        "利息保障倍数": (净利润 + 利息费用) / 利息费用 if 利息费用 > 0 else None,
        "负债权益比": 总负债 / 所有者权益 if 所有者权益 > 0 else None
    }
    
    return 财务比率

# 创建示例财务数据
资产负债表 = pd.DataFrame({
    '项目': ['流动资产', '非流动资产', '总资产', '流动负债', '非流动负债', '总负债', '所有者权益'],
    '2023年末': [500000, 800000, 1300000, 300000, 200000, 500000, 800000],
    '2024年末': [600000, 900000, 1500000, 350000, 250000, 600000, 900000]
})

利润表 = pd.DataFrame({
    '项目': ['营业收入', '营业成本', '营业利润', '净利润', '利息费用'],
    '2024年度': [2000000, 1500000, 400000, 300000, 50000]
})

# 计算财务比率
比率结果 = 计算财务比率(资产负债表, 利润表)

print("📊 财务比率分析结果：")
print("\n偿债能力比率：")
for 比率, 数值 in 比率结果.items():
    if 比率 in ["流动比率", "速动比率", "资产负债率", "权益乘数"] and 数值 is not None:
        print(f"  {比率}：{数值:.2f}")

print("\n营运能力比率：")
for 比率, 数值 in 比率结果.items():
    if 比率 in ["应收账款周转率", "存货周转率", "总资产周转率"] and 数值 is not None:
        print(f"  {比率}：{数值:.2f}")

print("\n盈利能力比率：")
for 比率, 数值 in 比率结果.items():
    if 比率 in ["销售净利率", "资产净利率", "净资产收益率"] and 数值 is not None:
        print(f"  {比率}：{数值:.2%}")

# 比率分析和建议
print(f"\n💡 财务分析建议：")

if 比率结果['流动比率'] and 比率结果['流动比率'] < 1.5:
    print("⚠️ 流动比率偏低，短期偿债能力需要关注")
elif 比率结果['流动比率'] and 比率结果['流动比率'] > 3:
    print("💡 流动比率偏高，可能存在资金闲置")

if 比率结果['资产负债率'] and 比率结果['资产负债率'] > 0.7:
    print("⚠️ 资产负债率偏高，财务风险较大")
elif 比率结果['资产负债率'] and 比率结果['资产负债率'] < 0.3:
    print("💡 资产负债率偏低，可以考虑适当增加杠杆")

if 比率结果['净资产收益率'] and 比率结果['净资产收益率'] > 0.15:
    print("✅ 净资产收益率良好，股东回报较高")
elif 比率结果['净资产收益率'] and 比率结果['净资产收益率'] < 0.1:
    print("⚠️ 净资产收益率偏低，盈利能力需要提升")
```

</details>

<details>
<summary>挑战2：预算差异分析</summary>

```python
# 预算差异分析系统
print("=== 预算差异分析系统 ===")

def 预算差异分析(实际数据, 预算数据, 分析维度=['部门', '项目']):
    """
    分析实际数据与预算数据的差异
    
    参数：
    实际数据：实际发生的数据DataFrame
    预算数据：预算数据DataFrame
    分析维度：按哪些维度进行分析
    
    返回：
    差异分析结果
    """
    
    # 确保数据格式一致
    实际数据 = 实际数据.copy()
    预算数据 = 预算数据.copy()
    
    # 按分析维度汇总
    实际汇总 = 实际数据.groupby(分析维度)['金额'].sum().reset_index()
    实际汇总.columns = 分析维度 + ['实际金额']
    
    预算汇总 = 预算数据.groupby(分析维度)['金额'].sum().reset_index()
    预算汇总.columns = 分析维度 + ['预算金额']
    
    # 合并数据
    差异分析 = pd.merge(实际汇总, 预算汇总, on=分析维度, how='outer').fillna(0)
    
    # 计算差异
    差异分析['差异金额'] = 差异分析['实际金额'] - 差异分析['预算金额']
    差异分析['差异率'] = 差异分析['差异金额'] / (差异分析['预算金额'] + 1e-10) * 100  # 加小值避免除零
    差异分析['完成率'] = 差异分析['实际金额'] / (差异分析['预算金额'] + 1e-10) * 100
    
    # 差异分级
    def 差异分级(差异率):
        if abs(差异率) <= 5:
            return "正常"
        elif abs(差异率) <= 10:
            return "轻微差异"
        elif abs(差异率) <= 20:
            return "显著差异"
        else:
            return "重大差异"
    
    差异分析['差异级别'] = 差异分析['差异率'].apply(差异分级)
    
    return 差异分析

def 生成预算分析报告(差异分析结果, 文件名="预算差异分析报告.xlsx"):
    """生成预算差异分析报告"""
    
    # 创建Excel工作簿
    wb = Workbook()
    
    # 1. 差异汇总表
    汇总表 = wb.active
    汇总表.title = "预算差异汇总"
    
    # 标题
    汇总表["A1"] = "预算差异分析报告"
    汇总表["A1"].font = Font(size=16, bold=True)
    汇总表.merge_cells("A1:F1")
    
    # 写入差异数据
    表头 = ['部门', '项目', '实际金额', '预算金额', '差异金额', '差异率', '完成率', '差异级别']
    for 列号, 标题 in enumerate(表头, 1):
        单元格 = 汇总表.cell(row=3, column=列号, value=标题)
        单元格.font = Font(bold=True)
        单元格.fill = PatternFill(start_color="E8F4FD", end_color="E8F4FD", fill_type="solid")
    
    for 行号, (_, 数据) in enumerate(差异分析结果.iterrows(), 4):
        for 列号, 列名 in enumerate(表头, 1):
            if 列名 == '差异率' or 列名 == '完成率':
                值 = f"{数据[列名]:.1f}%"
            elif '金额' in 列名:
                值 = f"{数据[列名]:,.2f}"
            else:
                值 = 数据[列名]
            汇总表.cell(row=行号, column=列号, value=值)
    
    # 2. 差异分级统计
    分级统计 = 差异分析结果.groupby('差异级别').agg({
        '差异金额': ['count', 'sum'],
        '差异率': 'mean'
    }).round(2)
    
    统计表 = wb.create_sheet("差异分级统计")
    统计表["A1"] = "差异分级统计"
    统计表["A1"].font = Font(size=14, bold=True)
    
    # 写入统计结果
    表头 = ['差异级别', '数量', '涉及金额', '平均差异率']
    for 列号, 标题 in enumerate(表头, 1):
        单元格 = 统计表.cell(row=3, column=列号, value=标题)
        单元格.font = Font(bold=True)
    
    for 行号, (级别, 数据) in enumerate(分级统计.iterrows(), 4):
        统计表.cell(row=行号, column=1, value=级别)
        统计表.cell(row=行号, column=2, value=数据[('差异金额', 'count')])
        统计表.cell(row=行号, column=3, value=f"{数据[('差异金额', 'sum')]:,.2f}")
        统计表.cell(row=行号, column=4, value=f"{数据[('差异率', 'mean')]:.1f}%")
    
    # 3. 主要差异项目
    重大差异 = 差异分析结果[差异分析结果['差异级别'].isin(['显著差异', '重大差异'])]
    if len(重大差异) > 0:
        重大差异 = 重大差异.sort_values('差异金额', key=abs, ascending=False)
        
        差异表 = wb.create_sheet("主要差异项目")
        差异表["A1"] = "主要差异项目（差异金额前10）"
        差异表["A1"].font = Font(size=14, bold=True)
        
        # 写入重大差异项目
        表头 = ['部门', '项目', '差异金额', '差异率', '可能原因']
        for 列号, 标题 in enumerate(表头, 1):
            单元格 = 差异表.cell(row=3, column=列号, value=标题)
            单元格.font = Font(bold=True)
        
        for 行号, (_, 数据) in enumerate(重大差异.head(10).iterrows(), 4):
            差异表.cell(row=行号, column=1, value=数据['部门'])
            差异表.cell(row=行号, column=2, value=数据['项目'])
            差异表.cell(row=行号, column=3, value=f"{数据['差异金额']:,.2f}")
            差异表.cell(row=行号, column=4, value=f"{数据['差异率']:.1f}%")
            
            # 根据差异率判断可能原因
            if 数据['差异率'] > 50:
                原因 = "远超预算，可能预算偏低或实际情况变化"
            elif 数据['差异率'] > 20:
                原因 = "显著超出预算，需要详细分析原因"
            elif 数据['差异率'] < -50:
                原因 = "远未达预算，可能预算过高或执行不力"
            elif 数据['差异率'] < -20:
                原因 = "显著低于预算，需要关注执行情况"
            else:
                原因 = "差异在正常范围内"
            
            差异表.cell(row=行号, column=5, value=原因)
    
    # 保存文件
    wb.save(文件名)
    print(f"✅ 预算差异分析报告已生成：{文件名}")
    
    return 文件名

# 创建示例预算数据
实际数据 = pd.DataFrame({
    '部门': ['销售部', '销售部', '市场部', '市场部', '技术部', '技术部'],
    '项目': ['差旅费', '招待费', '广告费', '推广费', '设备费', '培训费'],
    '金额': [25000, 15000, 80000, 60000, 120000, 25000]
})

预算数据 = pd.DataFrame({
    '部门': ['销售部', '销售部', '市场部', '市场部', '技术部', '技术部'],
    '项目': ['差旅费', '招待费', '广告费', '推广费', '设备费', '培训费'],
    '金额': [20000, 18000, 60000, 50000, 100000, 30000]
})

# 执行预算差异分析
差异结果 = 预算差异分析(实际数据, 预算_data)

print("📊 预算差异分析结果：")
print(差异结果)

# 生成分析报告
预算报告 = 生成预算分析报告(差异结果, "预算差异分析报告.xlsx")

# 分析建议
print(f"\n💡 预算管理建议：")

重大差异数量 = len(差异结果[差异结果['差异级别'].isin(['显著差异', '重大差异'])])
if 重大差异数量 > 0:
    print(f"⚠️ 发现{重大差异数量}个重大差异项目，需要重点关注")
    print("建议：")
    print("1. 对重大差异项目进行详细调查")
    print("2. 分析差异产生的原因")
    print("3. 根据分析结果调整下期预算")
    print("4. 加强预算执行监控")
else:
    print("✅ 预算执行情况良好，差异都在正常范围内")

超预算项目 = 差异结果[差异结果['差异金额'] > 0]
if len(超预算项目) > 0:
    print(f"\n📈 超预算项目：{len(超预算项目)}个")
    print("建议加强成本控制和预算管理")

低预算项目 = 差异结果[差异结果['差异金额'] < 0]
if len(低预算项目) > 0:
    print(f"\n📉 低预算项目：{len(低预算项目)}个")
    print("建议分析是否预算制定过高或执行不力")
```

</details>

***

### 💭 今日思考

通过今天的学习，我们发现：
- pandas的DataFrame就是Excel表格的"超级升级版"
- 数据筛选比Excel的自动筛选更灵活、更强大
- 分组统计比数据透视表更快、更直观
- 用pandas做财务分析，效率提升是数量级的

***

### 📝 课后小结

- ✅ 理解了DataFrame的概念和用途
- ✅ 掌握了数据筛选的各种方法
- ✅ 学会了分组统计和交叉分析
- ✅ 完成了专业级的销售数据分析

***

### 🎯 下节预告

下节我们将学习**数据清洗：让脏数据变干净**，学会处理现实世界中那些“不完美”的数据——缺失值、重复值、格式错误，让pandas帮你把“脏数据”变成“干净数据”！

***

### 💡 小贴士

- DataFrame是pandas的核心，多练习创建和操作
- 数据筛选条件要用括号括起来，多个条件用 `&` 或 `|` 连接
- groupby是财务分析的利器，要熟练掌握
- 多练习真实数据的分析，理论结合实践

***

> 🤖 Powered by Kimi K2 0905 💻 内容经葵葵🌻审核与修改

***
