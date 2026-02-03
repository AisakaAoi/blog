---
title: Python-第22篇《数据库基础：SQLite入门》
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐果果课程
abbrlink: 7e12eba1
date: 2026-02-04 00:30:19
tags:
---

### 导语

上篇我们用正则表达式从文本里“捞”出了金子，但这些数据放哪儿？存Excel？文件一多就乱套。存CSV？查询起来翻遍文件夹。是时候请出数据管理的“终极神器”——数据库！它就像公司的档案室，有专门的管理员（SQL语言），想找“去年交易额超过50万的客户”，1秒就搞定。今天我们从最轻量级的SQLite开始，不用安装服务器，像操作Excel一样简单！

<!--more-->

***

### 本篇目标

- 理解数据库的“表”和“记录”概念
- 掌握SQL的“增删改查”四大操作
- 学会用Python操作SQLite数据库
- 实战：构建可查询的客户管理系统
- 实现数据的导入导出

***

### 一、准备工作：安装库

SQLite是Python内置的，但操作它需要`sqlite3`模块（Python 3自带）。再加个辅助库：

```python
# 命令行运行
# pip install pandas openpyxl

import sqlite3
import pandas as pd
from datetime import datetime
import os

print("✅ SQLite环境准备就绪！")
```

***

### 二、理解数据库：从Excel表格说起

#### 2.1 数据库 vs Excel

| Excel   | SQLite数据库     |
| ------- | ------------- |
| 一个文件一个表 | 一个文件多个表（像工作簿） |
| 用鼠标操作   | 用SQL命令操作      |
| 数据量大了卡顿 | 百万级数据依然飞快     |
| 容易误删改   | 有事务保护，安全      |
| 难以多条件查询 | SQL一句话搞定复杂查询  |

**核心概念：**
- **数据库（Database）** = 一个`.db`文件 = 整个档案柜
- **表（Table）** = 一张二维表格 = 档案柜中的一个抽屉
- **记录（Record/Row）** = 一行数据 = 一份档案
- **字段（Field/Column）** = 一列数据 = 档案的某个属性（姓名、电话）

***

#### 2.2 创建第一个数据库

```python
# ========== 创建客户管理数据库 ==========
def create_customer_db():
    """
    创建SQLite数据库和customer表
    就像新建一个Excel文件，并在里面创建"客户信息"工作表
    """
    
    # 1. 连接数据库（如果文件不存在会自动创建）
    conn = sqlite3.connect('customer_management.db')
    cursor = conn.cursor()
    
    print("✅ 成功连接到数据库")
    
    # 2. 创建表（定义表结构）
    # IF NOT EXISTS：如果表已存在就不创建（避免重复报错）
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  -- 客户ID，主键，自动递增
        name TEXT NOT NULL,                    -- 姓名，文本类型，不能为空
        company TEXT,                          -- 公司名称
        phone TEXT UNIQUE,                     -- 电话，唯一（不能重复）
        email TEXT,                            -- 邮箱
        level TEXT DEFAULT '普通',             -- 客户等级，默认值
        total_amount REAL DEFAULT 0.0,         -- 累计交易金额
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- 创建时间，自动记录
    )
    """
    
    cursor.execute(create_table_sql)
    print("✅ 客户表创建成功！")
    
    # 3. 提交并关闭
    conn.commit()
    conn.close()
    print("📁 数据库文件已保存: customer_management.db")

# 创建数据库
create_customer_db()
```

**查看数据库内容：**
创建后，当前文件夹会出现`customer_management.db`文件。可以用**DB Browser for SQLite**（免费图形化工具）打开查看，像操作Excel一样直观！

***

### 三、SQL基础：数据的“增删改查”

SQL（Structured Query Language）是数据库的“普通话”，学会这四句，走遍天下都不怕：

#### 3.1 INSERT - 增加记录（添加客户）

```python
# ========== INSERT：添加新客户 ==========
def add_customers():
    """批量添加客户"""
    
    conn = sqlite3.connect('customer_management.db')
    cursor = conn.cursor()
    
    # 方法一：逐条插入
    customers = [
        ('张三', '智慧科技有限公司', '13800138001', 'zhangsan@example.com', 'VIP', 150000),
        ('李四', '创新贸易公司', '13900139002', 'lisi@example.com', '普通', 32000),
        ('王五', '优质服务集团', '13700137003', 'wangwu@example.com', '重要', 85000),
    ]
    
    # ？是占位符，防止SQL注入（安全）
    insert_sql = """
    INSERT INTO customers (name, company, phone, email, level, total_amount)
    VALUES (?, ?, ?, ?, ?, ?)
    """
    
    # 批量插入
    cursor.executemany(insert_sql, customers)
    
    # 提交（保存更改）
    conn.commit()
    
    print(f"✅ 成功插入 {cursor.rowcount} 条客户记录")
    
    # 方法二：插入单条并获取自动生成的ID
    single_customer = ('赵六', '快速发展企业', '13600136004', 'zhaoliu@example.com', 'VIP', 210000)
    
    cursor.execute(insert_sql, single_customer)
    conn.commit()
    
    # 获取刚插入的ID
    new_id = cursor.lastrowid
    print(f"✅ 新客户ID: {new_id}")
    
    conn.close()

# 测试添加
add_customers()
```

***

#### 3.2 SELECT - 查询记录（查找客户）

```python
# ========== SELECT：查询客户 ==========
def query_customers():
    """演示各种查询方式"""
    
    conn = sqlite3.connect('customer_management.db')
    cursor = conn.cursor()
    
    print("\n" + "=" * 50)
    print("客户查询演示")
    print("=" * 50)
    
    # 1. 查询所有客户（*表示所有列）
    print("\n1️⃣ 所有客户列表：")
    cursor.execute("SELECT * FROM customers")
    
    # fetchall()获取所有结果
    all_customers = cursor.fetchall()
    for customer in all_customers:
        print(f"ID: {customer[0]} | 姓名: {customer[1]} | 公司: {customer[2]} | 等级: {customer[5]} | 交易额: ¥{customer[6]:,.2f}")
    
    # 2. 条件查询：VIP客户
    print("\n2️⃣ VIP客户列表：")
    cursor.execute("SELECT name, company, total_amount FROM customers WHERE level = 'VIP'")
    vip_customers = cursor.fetchall()
    for name, company, amount in vip_customers:
        print(f"🏆 {name} ({company}) - 累计交易: ¥{amount:,.2f}")
    
    # 3. 模糊查询：公司名称包含"科技"
    print("\n3️⃣ 科技公司客户：")
    cursor.execute("SELECT * FROM customers WHERE company LIKE '%科技%'")
    tech_companies = cursor.fetchall()
    for customer in tech_companies:
        print(f"🔬 {customer[1]} - {customer[2]}")
    
    # 4. 范围查询：交易额超过5万
    print("\n4️⃣ 高价值客户（交易额>5万）：")
    cursor.execute("SELECT name, total_amount FROM customers WHERE total_amount > 50000 ORDER BY total_amount DESC")
    high_value = cursor.fetchall()
    for name, amount in high_value:
        print(f"💎 {name} - ¥{amount:,.2f}")
    
    # 5. 聚合查询：统计客户数量、平均交易额
    print("\n5️⃣ 客户统计：")
    cursor.execute("""
    SELECT 
        COUNT(*) as 客户总数,
        AVG(total_amount) as 平均交易额,
        SUM(total_amount) as 总交易额,
        MAX(total_amount) as 最高交易额,
        MIN(total_amount) as 最低交易额
    FROM customers
    """)
    stats = cursor.fetchone()
    print(f"👥 客户总数: {stats[0]}人")
    print(f"💵 平均交易额: ¥{stats[1]:,.2f}")
    print(f"💰 总交易额: ¥{stats[2]:,.2f}")
    print(f"📈 最高交易: ¥{stats[3]:,.2f}")
    print(f"📉 最低交易: ¥{stats[4]:,.2f}")
    
    conn.close()

query_customers()
```

***

#### 3.3 UPDATE - 修改记录（更新客户信息）

```python
# ========== UPDATE：更新客户信息 ==========
def update_customer():
    """更新客户数据"""
    
    conn = sqlite3.connect('customer_management.db')
    cursor = conn.cursor()
    
    print("\n" + "=" * 50)
    print("更新客户信息")
    print("=" * 50)
    
    # 场景：张三晋升为重要客户，交易额增加了5万
    update_sql = """
    UPDATE customers
    SET level = ?, total_amount = total_amount + ?
    WHERE name = ?
    """
    
    cursor.execute(update_sql, ('重要', 50000, '张三'))
    
    # 检查更新行数
    if cursor.rowcount > 0:
        conn.commit()
        print(f"✅ 更新成功！影响 {cursor.rowcount} 条记录")
    else:
        print("⚠️ 未找到匹配的记录")
    
    # 批量更新：所有普通客户交易额增加10%（奖励）
    cursor.execute("""
    UPDATE customers
    SET total_amount = total_amount * 1.10
    WHERE level = '普通'
    """)
    
    conn.commit()
    print(f"✅ 批量更新完成！奖励了 {cursor.rowcount} 位普通客户")
    
    conn.close()

update_customer()
```

***

#### 3.4 DELETE - 删除记录（删除客户）

```python
# ========== DELETE：删除客户 ==========
def delete_customer():
    """删除客户（谨慎操作！）"""
    
    conn = sqlite3.connect('customer_management.db')
    cursor = conn.cursor()
    
    print("\n" + "=" * 50)
    print("删除客户")
    print("=" * 50)
    
    # 场景：删除交易额低于1万的客户（清理小客户）
    # 先查询要删除哪些
    cursor.execute("SELECT id, name, total_amount FROM customers WHERE total_amount < 10000")
    to_delete = cursor.fetchall()
    
    if to_delete:
        print("即将删除以下客户：")
        for cid, name, amount in to_delete:
            print(f"  ID {cid}: {name}（交易额¥{amount:,.2f}）")
        
        confirm = input("确认删除？(y/n): ").strip()
        if confirm.lower() == 'y':
            # 执行删除
            cursor.execute("DELETE FROM customers WHERE total_amount < 10000")
            conn.commit()
            print(f"✅ 已删除 {cursor.rowcount} 位客户")
        else:
            print("❌ 操作已取消")
    else:
        print("ℹ️ 没有符合条件的客户")
    
    conn.close()

delete_customer()
```

***

### 四、Python + SQL：更优雅的操作方式

#### 4.1 使用Pandas操作SQLite

```python
# ========== Pandas + SQLite ==========
def pandas_with_sqlite():
    """用Pandas读写SQLite，像Excel一样简单"""
    
    # 1. 从数据库读取到DataFrame
    conn = sqlite3.connect('customer_management.db')
    
    # 读取整个表
    df = pd.read_sql("SELECT * FROM customers", conn)
    print("\n📊 客户数据DataFrame：")
    print(df.head())
    
    # 2. 复杂查询
    vip_df = pd.read_sql("""
    SELECT name, company, total_amount 
    FROM customers 
    WHERE level = 'VIP' 
    ORDER BY total_amount DESC
    """, conn)
    print("\n🏆 VIP客户DataFrame：")
    print(vip_df)
    
    # 3. 用Pandas处理数据（筛选、计算）
    # 找出交易额超过平均值的客户
    avg_amount = df['total_amount'].mean()
    high_value = df[df['total_amount'] > avg_amount]
    print(f"\n💎 高于平均值(¥{avg_amount:,.2f})的客户：{len(high_value)}人")
    print(high_value[['name', 'total_amount']])
    
    # 4. 将Pandas数据写回数据库
    # 新建一个"客户统计"表
    stats_df = df.groupby('level').agg({
        'id': 'count',
        'total_amount': ['sum', 'mean']
    }).round(2)
    
    stats_df.columns = ['客户数', '总交易额', '平均交易额']
    stats_df = stats_df.reset_index()
    
    # 写入数据库（如果表已存在则替换）
    stats_df.to_sql('customer_stats', conn, if_exists='replace', index=False)
    
    print("\n✅ 统计表已写入数据库")
    
    # 5. 从数据库读取统计表验证
    stats_from_db = pd.read_sql("SELECT * FROM customer_stats", conn)
    print("\n📈 客户等级统计：")
    print(stats_from_db)
    
    conn.close()

pandas_with_sqlite()
```

***

### 五、实战：构建客户管理系统

```python
# ========== 客户管理系统 - 完整版 ==========
class CustomerManagementSystem:
    """客户管理系统（SQLite版）"""
    
    def __init__(self, db_file='customer_management.db'):
        self.db_file = db_file
        self.init_database()
    
    def init_database(self):
        """初始化数据库和表"""
        conn = sqlite3.connect(self.db_file)
        cursor = conn.cursor()
        
        create_table_sql = """
        CREATE TABLE IF NOT EXISTS customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            company TEXT,
            phone TEXT UNIQUE,
            email TEXT,
            level TEXT DEFAULT '普通',
            total_amount REAL DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        """
        
        cursor.execute(create_table_sql)
        
        # 创建交互记录表（进阶）
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS interactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_id INTEGER,
            type TEXT,
            content TEXT,
            amount REAL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (customer_id) REFERENCES customers(id)
        )
        """)
        
        conn.commit()
        conn.close()
    
    def add_customer(self):
        """交互式添加客户"""
        print("\n" + "=" * 40)
        print("添加新客户")
        print("=" * 40)
        
        name = input("姓名: ").strip()
        if not name:
            print("❌ 姓名不能为空")
            return
        
        company = input("公司: ").strip()
        phone = input("电话: ").strip()
        email = input("邮箱: ").strip()
        level = input("等级（VIP/重要/普通，默认普通）: ").strip() or '普通'
        
        try:
            amount = float(input("累计交易金额: ").strip() or 0)
        except:
            amount = 0
        
        conn = sqlite3.connect(self.db_file)
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
            INSERT INTO customers (name, company, phone, email, level, total_amount)
            VALUES (?, ?, ?, ?, ?, ?)
            """, (name, company, phone, email, level, amount))
            
            conn.commit()
            print(f"✅ 客户添加成功！ID: {cursor.lastrowid}")
            
        except sqlite3.IntegrityError:
            print("❌ 错误：电话号码已存在，请使用其他号码")
        
        finally:
            conn.close()
    
    def search_customers(self):
        """高级查询"""
        print("\n" + "=" * 40)
        print("客户查询")
        print("=" * 40)
        
        keyword = input("输入搜索关键词（姓名/公司/电话）: ").strip()
        
        conn = sqlite3.connect(self.db_file)
        
        # 使用参数化查询防止SQL注入
        query = """
        SELECT * FROM customers 
        WHERE name LIKE ? OR company LIKE ? OR phone LIKE ?
        ORDER BY total_amount DESC
        """
        
        # %表示模糊匹配
        keyword_pattern = f'%{keyword}%'
        df = pd.read_sql(query, conn, params=[keyword_pattern, keyword_pattern, keyword_pattern])
        
        conn.close()
        
        if df.empty:
            print("📭 未找到匹配的客户")
        else:
            print(f"\n🔍 找到 {len(df)} 位客户：")
            print(df.to_string(index=False))
    
    def record_interaction(self):
        """记录客户交互（订单、投诉、回访）"""
        print("\n" + "=" * 40)
        print("记录客户交互")
        print("=" * 40)
        
        customer_id = input("客户ID: ").strip()
        interaction_type = input("交互类型（订单/投诉/回访/付款）: ").strip()
        content = input("交互内容: ").strip()
        
        try:
            amount = float(input("涉及金额（无则回车）: ").strip() or 0)
        except:
            amount = 0
        
        conn = sqlite3.connect(self.db_file)
        cursor = conn.cursor()
        
        # 插入交互记录
        cursor.execute("""
        INSERT INTO interactions (customer_id, type, content, amount)
        VALUES (?, ?, ?, ?)
        """, (customer_id, interaction_type, content, amount))
        
        # 如果是订单，更新客户累计交易金额
        if interaction_type == '订单':
            cursor.execute("""
            UPDATE customers 
            SET total_amount = total_amount + ?
            WHERE id = ?
            """, (amount, customer_id))
            
            print(f"✅ 订单记录成功，客户累计交易已更新")
        
        conn.commit()
        conn.close()
        print("✅ 交互记录已保存")
    
    def generate_report(self):
        """生成客户分析报告"""
        conn = sqlite3.connect(self.db_file)
        
        print("\n" + "=" * 50)
        print("客户分析报告")
        print("=" * 50)
        
        # 客户分布统计
        stats_df = pd.read_sql("""
        SELECT 
            level as 客户等级,
            COUNT(*) as 客户数量,
            ROUND(AVG(total_amount), 2) as 平均交易额,
            ROUND(SUM(total_amount), 2) as 总交易额
        FROM customers
        GROUP BY level
        ORDER BY 总交易额 DESC
        """, conn)
        
        print("\n📊 客户等级分布：")
        print(stats_df.to_string(index=False))
        
        # 本月新增客户
        new_customers = pd.read_sql("""
        SELECT name, company, created_at 
        FROM customers 
        WHERE created_at >= date('now', '-30 days')
        ORDER BY created_at DESC
        """, conn)
        
        if not new_customers.empty:
            print(f"\n🆕 本月新增客户（{len(new_customers)}人）：")
            print(new_customers.to_string(index=False))
        else:
            print("\n🆕 本月暂无新客户")
        
        # 高价值客户TOP5
        top5 = pd.read_sql("""
        SELECT name, company, total_amount, level
        FROM customers
        ORDER BY total_amount DESC
        LIMIT 5
        """, conn)
        
        print("\n💎 高价值客户TOP5：")
        print(top5.to_string(index=False))
        
        # 交互统计
        interaction_stats = pd.read_sql("""
        SELECT 
            type as 交互类型,
            COUNT(*) as 次数,
            ROUND(SUM(amount), 2) as 总金额
        FROM interactions
        WHERE created_at >= date('now', '-30 days')
        GROUP BY type
        ORDER BY 次数 DESC
        """, conn)
        
        if not interaction_stats.empty:
            print("\n📞 本月交互统计：")
            print(interaction_stats.to_string(index=False))
        
        conn.close()
        
        # 保存报告
        with pd.ExcelWriter('客户分析报告.xlsx', engine='openpyxl') as writer:
            stats_df.to_excel(writer, sheet_name='客户统计', index=False)
            if not new_customers.empty:
                new_customers.to_excel(writer, sheet_name='新客户', index=False)
            top5.to_excel(writer, sheet_name='TOP5客户', index=False)
            if not interaction_stats.empty:
                interaction_stats.to_excel(writer, sheet_name='交互统计', index=False)
        
        print("\n✅ 报告已保存: 客户分析报告.xlsx")

def main():
    """主菜单"""
    cms = CustomerManagementSystem()
    
    print("=" * 55)
    print("客户管理系统")
    print("数据库版 - 数据安全可靠，查询快速")
    print("=" * 55)
    
    while True:
        print("\n" + "=" * 45)
        print("功能菜单")
        print("=" * 45)
        print("1. 添加客户")
        print("2. 查询客户")
        print("3. 记录客户交互")
        print("4. 生成分析报告")
        print("5. 退出")
        print("=" * 45)
        
        choice = input("请选择: ").strip()
        
        if choice == "1":
            cms.add_customer()
        elif choice == "2":
            cms.search_customers()
        elif choice == "3":
            cms.record_interaction()
        elif choice == "4":
            cms.generate_report()
        elif choice == "5":
            print("👋 感谢使用，数据已安全保存！")
            break
        else:
            print("请输入1-5！")

if __name__ == "__main__":
    main()
```

***

### 六、知识点加油站

#### 6.1 SQL语句速查

```python
"""
-- 查询
SELECT 列1, 列2 FROM 表 WHERE 条件 ORDER BY 列
-- 模糊查询
SELECT * FROM customers WHERE name LIKE '张%'
-- 聚合函数
COUNT(), SUM(), AVG(), MAX(), MIN()
-- 分组
SELECT level, COUNT(*) FROM customers GROUP BY level

-- 插入
INSERT INTO 表 (列1, 列2) VALUES (值1, 值2)

-- 更新
UPDATE 表 SET 列=值 WHERE 条件

-- 删除
DELETE FROM 表 WHERE 条件

-- 创建表
CREATE TABLE IF NOT EXISTS 表名 (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    列名 类型 约束,
    ...
)

-- 数据类型
INTEGER  整数
REAL     浮点数
TEXT     文本
BLOB     二进制
TIMESTAMP 时间戳
"""
```

***

#### 6.2 SQLite vs 其他数据库

| 特性   | SQLite      | MySQL/PostgreSQL |
| ---- | ----------- | ---------------- |
| 安装   | 无需安装，文件即数据库 | 需安装服务器           |
| 适用场景 | 小型应用、单机、学习  | 大型应用、多用户、企业级     |
| 性能   | 百万级数据良好     | 千万级以上优秀          |
| 并发   | 适合低并发       | 高并发优化            |
| 学习成本 | 极低，上手快      | 较高，需配置管理         |

**结论**：对于个人财务管理、小型企业应用，SQLite完全够用！

***

### 七、总结

- ✅ 数据库核心概念（表、记录、字段）
- ✅ SQL四大操作：增删改查
- ✅ Python操作SQLite
- ✅ Pandas与SQLite结合
- ✅ 构建完整的客户管理系统

***

### 下篇预告

第23篇《自动化办公：Python+Excel高级应用》——自动生成复杂报表、数据透视表自动化！

***

> 🤖 Powered by Kimi K2 Thinking 💻 内容经葵葵🌻审核与修改

***
