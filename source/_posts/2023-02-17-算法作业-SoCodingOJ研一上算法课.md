---
title: 算法作业-SoCodingOJ研一上算法课
categories:
  - 🌙大学课程
  - ⭐算法设计与分析
abbrlink: f0fd6226
date: 2023-02-17 17:07:49
tags:
---

### Problem P01. [算法课分治] 最大二叉树

给定一个**不含重复元素**的整数数组 nums。以此数组直接递归构建的最大二叉树。最大二叉树定义如下：

- 二叉树的根是数组 nums 中的最大元素。
- 左子树是通过数组中最大值左边部分递归构造出的最大二叉树。
- 右子树是通过数组中最大值右边部分递归构造出的最大二叉树。

返回有给定数组 nums 构建的最大二叉树。

#### 输入

输入一行多个数字代表数组 nums。数字与数字之间用空格隔开。

以 EOF 作为结束输入（请参考 SCNUOJ 1001 题题解了解如何处理输入）。

- 1 ≤ nums.length ≤ 1000
- 0 ≤ nums[i] ≤ 1000
- nums中的所有整数互不相同

<!--more-->

#### 输出

输出一行字符代表二叉树的构造结果（前序遍历），具体请参考样例

#### 样例

```
标准输入：
3 2 1 6 0 5
标准输出：
6 3 null 2 null 1 5 0 null 

标准输入：
3 2 1
标准输出：
3 null 2 null 1
```

#### 解答

``` python
def find_max(a):
    for i in range(len(a)):
        if a[i] == max(a):
            return i, a[i]


def func(a):
    i, Max = find_max(a)
    res.append(Max)
    if len(a) == 1:
        return 0
    if i == 0:
        res.append("null")
    else:
        func(a[:i])
    if i == len(a) - 1:
        res.append("null")
    else:
        func(a[i + 1:])


num = input().split()
for i in range(len(num)):
    num[i] = int(num[i])

res = []
func(num)

for i in range(len(res)):
    res[i] = str(res[i])
print(" ".join(res))

```

***

### Problem P02. [算法课分治] 寻找多数

给定一个大小为 n 的整型数组 a，找到其中的多数元素，多数元素是指在数组中出现次数大于 ⌊n/2⌋ 的元素。

#### 输入

第一行输入一个整数 n (1 ≤ n ≤ 10^4) 代表数组的长度。

第二行输入一行数字代表数组 a (1 ≤ a_i ≤ 10^4)，数字与数字之间用空格间开。

保证给定的数组总是存在多数元素。

#### 输出

输出一个整数代表数组的多数元素。

#### 样例

```
标准输入：
3
1 1 1
标准输出：
1

标准输入：
7
4 1 2 3 3 3 3
标准输出：
3

标准输入：
9
4 2 2 2 2 21 23 23 2
标准输出：
2
```

#### 提示

如果数 a 是数组 n 的众数，如果我们将 n 分成两部分，那么 a 必定是至少一部分的众数。

#### 解答

``` python
temp = input()
num = input().split()
for i in range(len(num)):
    num[i] = int(num[i])

num.sort()
print(num[len(num) // 2])
```

***

### Problem P03. [算法课分治] 找到最大子序和

给定一个整数数组 nums，找到一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

#### 输入

第一行输入一个整数 nums.length 代表数组的长度

第二行输入一行数字代表数组 nums，数字与数字之间用空格间开

- 1 ≤ nums.length ≤ 3 × 10^4
- -100000 ≤ nums[i] ≤ 100000

#### 输出

输出一个整数代表子序列最大和

#### 样例

```
标准输入：
9
-2 1 -3 4 -1 2 1 -5 4
标准输出：
6

标准输入：
1
1
标准输出：
1

标准输入：
1
0
标准输出：
0
```

#### 提示

第一个样例解释：连续子数组 [4, -1, 2, 1] 的和最大，为 6。

#### 解答

``` python
temp = input()
arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

pre = 0
maxAns = arr[0]

for i in arr:
    pre = max(pre + i, i)
    maxAns = max(maxAns, pre)

print(maxAns)
```

***

### Problem P04. [算法课分治] 找到 k 个最小数

输入整数数组 arr，找出其中最小的 k 个数。

#### 输入

第一行输入两个整数，第一个代表数组的长度，第二个代表 k，数字与数字之间用空格间开

第二行输入一行数字代表数组 arr。数字与数字之间用空格间开

- 0 ≤ k ≤ arr.length ≤ 10000
- 0 ≤ arr[i] ≤ 10000

#### 输出

输出一行整数，表示最小的 k 个数。数字与数字之间用空格间开

#### 样例

```
标准输入：
3 2
3 2 1
标准输出：
1 2

标准输入：
4 1
0 0 1 1
标准输出：
0

标准输入：
4 2
1 1 3 4
标准输出：
1 1
```

#### 解答

``` python
temp = input().split()
k = int(temp[1])

arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

arr.sort()

for i in range(len(arr)):
    if i >= k:
        break
    print(arr[i], end=" ")
```

***

### Problem P05. [算法课分治] 寻找第 k 个最大元素

给定整数数组 nums 和整数 k，请找到数组中第 k 个最大的元素。

#### 输入

第一行输入两个整数，第一个代表数组的长度，第二个代表 k，数字与数字之间用空格间开

第二行输入一行数字代表数组 nums。数字与数字之间用空格间开

- 1 ≤ k ≤ nums.length ≤ 1000
- -1000 ≤ nums[i] ≤ 1000

#### 输出

输出一个整数代表第 k 个最大元素

#### 样例

```
标准输入：
6 2
3 2 1 5 6 4
标准输出：
5

标准输入：
9 4
3 2 3 1 2 4 5 5 6
标准输出：
4

```

#### 解答

``` python
temp = input().split()
k = int(temp[1])

arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

arr.sort()

print(arr[-k])
```

***

### Problem P06. [算法课分治] 找到 k 个最长重复字符串

在一个字符串 s 中找出 s 中的最长子串，且该字符串的每一个字符出现次数都不少于 k。输出该子串的长度。

#### 输入

第一行有两个输入，第一个输入一串字符串 s，第二个输入整数代表 k，两个输入之间用空格隔开

- 1 ≤ s.length ≤ 10000
- s 仅由小写英文字母组成
- 0 ≤ k ≤ 1000

#### 输出

输出一个整数，表示该子串的长度

#### 样例

```
标准输入：
aaabb 3
标准输出：
3

标准输入：
ababbc 2
标准输出：
5

标准输入：
abcde 2
标准输出：
0

```

#### 提示

第一个样例解释：最长子串为 aaa，其中 a 重复了 3 次。

#### 解答

``` python
temp = input().split()
arr = temp[0]
k = int(temp[1])


def longestSubstring(arr, k):
    if not arr:
        return 0
    for c in set(arr):
        if arr.count(c) < k:
            return max(longestSubstring(t, k) for t in arr.split(c))
    return len(arr)


print(longestSubstring(arr, k))
```

***

### Problem P07. [算法课分治] 链表排序

请将链表按**升序**排列并返回排序后的链表。测试用例的链表不为空。 其中 ListNode 的数据结构
``` C++
struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};
```

#### 输入

输入一行数字表示链表数据，数字与数字之间空格隔开。

以 EOF 作为结束输入（请参考 SCNUOJ 1001 题题解了解如何处理输入）。

- 链表中节点的数目在范围 [0, 5×10^4] 内
- −10000 ≤ Node.val ≤ 10000

#### 输出

输出一行数字代表排序后的链表，数字与数字之间空格隔开

#### 样例

```
标准输入：
4 2 1 3
标准输出：
1 2 3 4

标准输入：
-1 5 3 4 0
标准输出：
-1 0 3 4 5
```

#### 解答

``` python
arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

arr.sort()

for i in range(len(arr)):
    arr[i] = str(arr[i])

print(" ".join(arr))
```

***

### Problem P08. [算法课蛮力法] 柠檬水找零

在柠檬水摊上，每一杯柠檬水的售价为 5 美元。顾客排队购买你的产品，（按账单 bills 支付的顺序）一次购买一杯。

每位顾客只买一杯柠檬水，然后向你付 5 美元、10 美元或 20 美元。你必须给每个顾客正确找零，也就是说净交易是每位顾客向你支付 5 美元。

注意，一开始你手头没有任何零钱。

给你一个整数数组 bills，其中 bills[i] 是第 i 位顾客付的账。如果你能给每位顾客正确找零，输出 true，否则输出 false。

#### 输入

输入一行数字表示链表数据，数字与数字之间空格隔开。

以 EOF 作为结束输入（请参考 SCNUOJ 1001 题题解了解如何处理输入）。

- 1 ≤ bills.length ≤ 10^5
- bills[i] 不是 5 就是 10 或是 20

#### 输出

如果你能给每位顾客正确找零，输出 true，否则输出 false

#### 样例

```
标准输入：
5 5 5 10 20
标准输出：
true

标准输入：
5 5 10 10 20
标准输出：
false
```

#### 解答

``` python
arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

earn = 0
boolean = True

for i in arr:
    earn -= i - 5
    if earn < 0:
        boolean = False
        break
    earn += 5

if boolean:
    print("true")
else:
    print("false")
```

***

### Problem P09. [算法课动态规划] 换硬币

给定面值分别为2，5，7的硬币，每种硬币有无限个，给定一个N，求组成N最少需要的硬币的数量，若无法组成则返回-1.

#### 输入

输入N (1 <= N <= 100)

#### 输出

输出需要的最少硬币个数

#### 样例

```
标准输入：
5
标准输出：
1

标准输入：
11
标准输出：
3

标准输入：
27
标准输出：
5

```

#### 提示

由后往前推理判断更加容易

#### 解答

``` python
coins = [2, 5, 7]
num = int(input())

dp = [float("inf")] * (num + 1)
dp[0] = 0

for coin in coins:
    for i in range(coin, num + 1):
        dp[i] = min(dp[i], dp[i-coin] + 1)

print(dp[num] if dp[num] != float("inf") else -1)
```

***

### Problem P10. [算法课动态规划]走网格

m行n列的网格，从左上角（1，1）出发，每一步只能向下或者向右，问共有多少种方法可以走到右下角（m,n);

#### 输入

输入参数 m n (1<=m<=10 1<=n<=10)

#### 输出

输出多少种走法

#### 样例

```
标准输入：
2 3
标准输出：
3

标准输入：
5 5
标准输出：
70

```

#### 解答

``` python
arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

m = arr[0]
n = arr[1]

dp = []
for i in range(m):
    dp.append([1] * n)

for i in range(1, m):
    for j in range(1, n):
        dp[i][j] = dp[i - 1][j] + dp[i][j - 1]

print(dp[m - 1][n - 1])
```

***

### Problem P11. [算法课动态规划]爬楼梯

假设你正在爬楼梯。需要 n 阶你才能到达楼顶。(n是正整数)每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶呢？

#### 输入

第一行输入阶数n (1 <= n <= 20)

#### 输出

输出总共多少种走法

#### 样例

```
标准输入：
3
标准输出：
3

标准输入：
5
标准输出：
8

标准输入：
15
标准输出：
987

```

#### 提示

斐波那契数列

#### 解答

``` python
num = int(input())

if num == 1:
    print(1)
elif num == 2:
    print(2)
elif num == 3:
    print(3)
else:
    a = 1
    b = 2
    c = 3
    for i in range(num - 1):
        a = b
        b = c
        c = a + b
    print(a)
```

***

### Problem P12. [算法课动态规划]背包问题

一个背包有一定的承重 W，有 N 件物品，每件物品都有自己的价值，记录在数组 V 中，也都有自己的重量，记录在数组 W 中，每件物品只能选择要装入还是不装入背包，要求在不超过背包承重的前提下，选出的物品总价值最大。 假设物品数量为 4 背包承重为 10 每个商品重量为 7, 3, 4, 5 价值为 42, 12, 40, 25

#### 输入

输入物品数量 n = 4 承重 cap = 10

#### 输出

输出最大总价值为多少

#### 样例

```
标准输入：
4 10
标准输出：
65
```

#### 提示

可以动态规划方法求解。 分析两种情况：
1. 第i个物品放不进去背包：W[i] > j;
2. 可以放进去，但是可以选择放进去或者不放：W[i] =< j;

#### 解答

``` python
heavy = [7, 3, 4, 5]
value = [42, 12, 40, 25]

arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

n = arr[0]
cap = arr[1]

dp = []

for i in range(n+1):
    dp.append([0] * (cap + 1))

for i in range(1, 1 + n):
    for j in range(1, 1 + cap):
        if j < heavy[i - 1]:
            dp[i][j] = dp[i-1][j]
        else:
            dp[i][j] = max(dp[i-1][j], value[i-1] + dp[i-1][j-heavy[i-1]])

print(dp[n][cap])
```

***

### Problem P13. [算法课动态规划]最长回文子串

求一个字符串中的最长的回文子串

#### 输入

输入字符串 s (1 <= s.length <= 1000) s 仅由数字和英文字母（大写和/或小写）组成

#### 输出

输出最长的回文子串

#### 样例

```
标准输入：
babad
标准输出：
bab

标准输入：
a
标准输出：
a

标准输入：
ac
标准输出：
a
```

#### 解答

``` python
s = input()
n = len(s)
if n < 2:
    print(s)

maxLen = 1
begin = 0
dp = [[False] * n for _ in range(n)]
for i in range(n):
    dp[i][i] = True
for L in range(2, n + 1):
    for i in range(n):
        j = L + i - 1
        if j >= n:
            break
        if s[i] != s[j]:
            dp[i][j] = False
        else:
            if j - i < 3:
                dp[i][j] = True
            else:
                dp[i][j] = dp[i + 1][j - 1]
        if dp[i][j] and j - i + 1 > maxLen:
            maxLen = j - i + 1
            begin = i
print(s[begin:begin + maxLen])
```

***

### Problem P14. [算法课动态规划]连续数组最大和

输入一个整型数组，数组中的一个或连续多个整数组成一个子数组。求所有子数组的和的最大值。

#### 输入

输入数组长度n (1 <= n <= 50) 依次给数组的元素赋值

#### 输出

输出所有子数组的和的最大值

#### 样例

```
标准输入：
9
-2 1 -3 4 -1 2 1 -5 4
标准输出：
6
```

#### 解答

``` python
num = input()
arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

dp = [0] * (len(arr) + 1)
maxAns = arr[0]
pre = 0

for i in arr:
    pre = max(pre + i, i)
    maxAns = max(maxAns, pre)

print(maxAns)
```

***

### Problem P15. [算法课动态规划]最长公共子序列

给定两个字符串 text1 和 text2，返回这两个字符串的最长 公共子序列 的长度。如果不存在 公共子序列 ，返回 0

#### 输入

输入字符串s1和s2

#### 输出

输出最长公共子序列的长度

#### 样例

```
标准输入：
abcde ace
标准输出：
3

标准输入：
asdfg azxcd
标准输出：
2
```

#### 提示

区分两个概念：子序列可以是不连续的；子数组（子字符串）需要是连续的

#### 解答

``` python
arr = input().split()

m = len(arr[0])
n = len(arr[1])
dp = [[0] * (n + 1) for _ in range(m + 1)]

for i in range(1, m + 1):
    c1 = arr[0][i - 1]
    for j in range(1, n + 1):
        c2 = arr[1][j - 1]
        if c1 == c2:
            dp[i][j] = dp[i - 1][j - 1] + 1
        else:
            dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

print(dp[m][n])
```

***

### Problem P16. [算法课贪婪]最长回文串

给定一个包含大写字母和小写字母的字符串，找到通过这些字母构造成的最长的回文串。在构造过程中，请注意区分大小写。比如 "Aa" 不能当做一个回文字符串。解释：第一个例子可以构成"dccaccd", 它的长度是 7。字符串的长度不会超过 1010

#### 输入

第一行输入一串字符

#### 输出

第一行输出数字代表能构成的最大回文串的长度。

#### 样例

```
标准输入：
abccccdd
标准输出：
7
```

#### 解答

``` python
import collections

arr = input()

ans = 0
count = collections.Counter(arr)

for v in count.values():
    ans += v // 2 * 2
    if ans % 2 == 0 and v % 2 == 1:
        ans += 1

print(ans)
```

***

### Problem P17. [算法课贪婪]分发饼干

假设你是一位很棒的家长，想要给你的孩子们一些小饼干。但是，每个孩子最多只能给一块饼干。

对每个孩子 i，都有一个胃口值 g[i]，这是能让孩子们满足胃口的饼干的最小尺寸；并且每块饼干 j，都有一个尺寸 s[j] 。如果 s[j] >= g[i]，我们可以将这个饼干 j 分配给孩子 i ，这个孩子会得到满足。你的目标是尽可能满足越多数量的孩子，并输出这个最大数值。

1 <= g.length <= 3 * 10^5

0 <= s.length <= 3 * 10^5

1 <= g[i], s[j] <= 5*10^4

#### 输入

输入孩子的胃口值与饼干尺寸

#### 输出

输出能够满足孩子的最大数

#### 样例

```
标准输入：
1 2 3
1 1
标准输出：
1

标准输入：
1 2 
1 2 3
标准输出：
2
```

#### 解答

``` python
g = input().split()
s = input().split()

for i in range(len(g)):
    g[i] = int(g[i])

for i in range(len(s)):
    s[i] = int(s[i])

g.sort()
s.sort()
m = len(g)
n = len(s)
count = 0
i = 0
j = 0
flag = True
while i < m and j < n:
    while j < n and g[i] > s[j]:
        j += 1
    if j < n:
        count += 1
    i += 1
    j += 1

print(count)
```

***

### Problem P18. [算法课贪婪]6和9组成的最大数字

给你一个仅由数字6和9组成的正整数 num。

你最多只能翻转一位数字，将 6 变成 9，或者把 9 变成 6 。

请返回你可以得到的最大数字。

- 1 <= num <= 10000，即最多4位数
- num 每一位上的数字都是 6 或者 9 。

#### 输入

第一行输入一个整数。

#### 输出

第一行输出一个整数代表最大值

#### 样例

```
标准输入：
9669
标准输出：
9969

标准输入：
9996
标准输出：
9999

标准输入：
69
标准输出：
99
```

#### 解答

``` python
num = input()
ans = []

for i in num:
    ans.append(i)
for i in range(len(ans)):
    if ans[i] == "6":
        ans[i] = "9"
        break

print("".join(ans))
```

***

### Problem P19. [算法课贪婪]三角形的最大周长

给定由一些正数（代表长度）组成的数组 A，返回由其中三个长度组成的、面积不为零的三角形的最大周长。如果不能形成任何面积不为零的三角形，返回 0。

- 3 <= A.length <= 1000
- 1 <= A[i] <= 1000

#### 输入

第一行输入一行数字代表长度，数字与数字之间空格隔开。

#### 输出

输出一个整数代表最大周长

#### 样例

```
标准输入：
2 1 2
标准输出：
5

标准输入：
1 2 1
标准输出：
0

标准输入：
3 2 3 4
标准输出：
10
```

#### 解答

``` python
num = input().split()
for i in range(len(num)):
    num[i] = int(num[i])
num.sort(reverse=True)

boolean = False
for i in range(len(num) - 2):
    if num[i + 2] + num[i + 1] > num[i]:
        print(num[i + 2] + num[i + 1] + num[i])
        boolean = True
        break

if not boolean:
    print(0)
```

***

### Problem P20. [算法课蛮力法]种花问题

假设有一个很长的花坛，一部分地块种植了花，另一部分却没有。可是，花不能种植在相邻的地块上，它们会争夺水源，两者都会死去。

给你一个整数数组  flowerbed 表示花坛，由若干 0 和 1 组成，其中 0 表示没种植花，1 表示种植了花。另有一个数 n ，能否在不打破种植规则的情况下种入 n 朵花？能则返回 true ，不能则返回 false。

- 1 <= flowerbed.length <= 2 * 10^4
- flowerbed[i] 为 0 或 1
- flowerbed 中不存在相邻的两朵花
- 0 <= n <= flowerbed.length

#### 输入

输入一行数组flower与需要插入的花数目

#### 输出

输出是否插入成功

#### 样例

```
标准输入：
1 0 0 0 1
2
标准输出：
false
```

#### 解答

``` python
num = input().split()
for i in range(len(num)):
    num[i] = int(num[i])
n = int(input())

flowerbed = [0]
for i in num:
    flowerbed.append(i)
flowerbed.append(0)

count = 0
for i in range(1, len(flowerbed) - 1):
    if flowerbed[i] == 0 and flowerbed[i - 1] == 0 and flowerbed[i + 1] == 0:
        count += 1
        flowerbed[i] = 1

if count >= n:
    print("true")
else:
    print("false")
```

***

### Problem P21. [算法课贪婪]移掉 K 位数字

给你一个以字符串表示的非负整数 num 和一个整数 k ，移除这个数中的 k 位数字，使得剩下的数字最小。请你以字符串形式返回这个最小的数字。

- 1 <= k <= num.length <= 1000
- num 仅由若干位数字（0 - 9）组成
- 除了 0 本身之外，num 不含任何前导零

#### 输入

输入一串字符串表示非负整数和一个整数k。字符串和k之间空格隔开。

#### 输出

输出一串字符串表示结果。

#### 样例

```
标准输入：
1432219 3
标准输出：
1219

标准输入：
10200 1
标准输出：
200

标准输入：
10 2
标准输出：
0
```

#### 解答

``` python
arr = input().split()
temp = arr[0]
num = []
for i in temp:
    num.append(int(i))
k = int(arr[1])

ans = []

for i in range(len(num)):
    while k > 0 and len(ans) > 0 and ans[-1] > num[i]:
        k -= 1
        ans.pop(-1)
    ans.append(num[i])

if k > 0:
    for _ in range(k):
        ans.pop(-1)

while ans and ans[0] == 0:
    ans.pop(0)

if not ans:
    print(0)
else:
    for i in ans:
        print(i, end="")
```

***

### Problem P22. [算法课贪婪]盛最多的水

给你 n 个非负整数 a1，a2，...，an，每个数代表坐标中的一个点 (i, ai) 。在坐标内画 n 条垂直线，垂直线 i 的两个端点分别为 (i, ai) 和 (i, 0) 。找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。

说明：你不能倾斜容器。

{% asset_img 1.webp %}

输入：1 8 6 2 5 4 8 3 7 输出：49 解释：图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。

n == height.length

2 <= n <= 10^4

0 <= height[i] <= 10^4

#### 输入

输入一行整数

#### 输出

输出最大的面积数

#### 样例

```
标准输入：
4 3 2 1 4
标准输出：
16

标准输入：
1 2 1 
标准输出：
2
```

#### 解答

``` python
arr = input().split()
for i in range(len(arr)):
    arr[i] = int(arr[i])

i = 0
j = len(arr) - 1
ans = 0

while i < j:
    minH = min(arr[i], arr[j])
    area = (j - i) * minH
    ans = max(ans, area)
    while arr[i] <= minH and i < j:
        i += 1
    while arr[j] <= minH and i < j:
        j -= 1

print(ans)
```

***

### Problem P23. [算法课回溯]括号生成

数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合。

有效括号组合需满足：左括号必须以正确的顺序闭合。

1 <= n <= 8
请按照括号生成的层数有大到小排序，如输入3时，先生成((()))，最后再生成 ()()()

#### 输入

输入数字n

#### 输出

生成所有可能的并且 有效的 括号组合

#### 样例

```
标准输入：
3
标准输出：
[((())), (()()), (())(), ()(()), ()()()]

标准输入：
1
标准输出：
[()]
```

#### 解答

``` python
num = int(input())
ans = []


def gen(left, right, temp):
    if left == 0 and right == 0:
        ans.append(temp.copy())
        return
    if left > 0:
        temp.append("(")
        gen(left - 1, right, temp)
        temp.pop(-1)
    if left < right:
        temp.append(")")
        gen(left, right - 1, temp)
        temp.pop(-1)


print("[", end="")
gen(num, num, [])
print("".join(ans[0]), end="")
for i in range(1, len(ans)):
    print(", ", end="")
    print("".join(ans[i]), end="")
print("]", end="")
```

***

### Problem P24. [算法课回溯]组合问题

给定两个整数 n 和 k，返回范围 [1, n] 中所有可能的 k 个数的组合。

你需要按顺序返回答案。

- 1 <= n <= 20
- 1 <= k <= n

#### 输入

两个整数 n 和 k

#### 输出

范围 [1, n] 中所有可能的 k 个数的组合

#### 样例

```
标准输入：
4 2
标准输出：
[[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]

标准输入：
5 3
标准输出：
[[1, 2, 3], [1, 2, 4], [1, 2, 5], [1, 3, 4], [1, 3, 5], [1, 4, 5], [2, 3, 4], [2, 3, 5], [2, 4, 5], [3, 4, 5]]
```

#### 提示

可以用回溯法求解。

#### 解答

``` python
num = input().split()
n = int(num[0])
k = int(num[1])

ans = []


def gen(cur, n, k, temp):
    if cur > n + 1:
        return
    if len(temp) == k:
        for i in range(len(temp)):
            temp[i] = str(temp[i])
        ans.append(temp.copy())
        return
    temp.append(cur)
    gen(cur + 1, n, k, temp)
    temp.pop(-1)
    gen(cur + 1, n, k, temp)


gen(1, n, k, [])
print("[", end="")
print("[", end="")
print(", ".join(ans[0]), end="")
print("]", end="")
for i in range(1, len(ans)):
    print(", ", end="")
    print("[", end="")
    print(", ".join(ans[i]), end="")
    print("]", end="")
print("]", end="")
```

***

### Problem P25. [算法课回溯]找出所有子集的异或总和再求和

一个数组的 异或总和 定义为数组中所有元素按位 XOR 的结果；如果数组为 空 ，则异或总和为 0 。

例如，数组 [2,5,6] 的 异或总和 为 2 XOR 5 XOR 6 = 1 。 给你一个数组 nums ，请你求出 nums 中每个 子集 的 异或总和 ，计算并返回这些值相加之 和 。

注意：在本题中，元素 相同 的不同子集应 多次 计数。

数组 a 是数组 b 的一个 子集 的前提条件是：从 b 删除几个（也可能不删除）元素能够得到 a 。

- 1 <= nums.length <= 12
- 1 <= nums[i] <= 20

#### 输入

输入：nums = [1,3]

解释：[1,3] 共有 4 个子集：
- 空子集的异或总和是 0 。
- [1] 的异或总和为 1 。
- [3] 的异或总和为 3 。
- [1,3] 的异或总和为 1 XOR 3 = 2 。 0 + 1 + 3 + 2 = 6

#### 输出

输出：6

#### 样例

```
标准输入：
1 3
标准输出：
6

标准输入：
5 10 11 12 13 14
标准输出：
480

标准输入：
3 13 8 18 8 14 8 15 14
标准输出：
7936
```

#### 解答

``` python
num = input().split()
for i in range(len(num)):
    num[i] = int(num[i])


def CountXOR(l):
    if len(l) == 0:
        return 0
    if len(l) == 1:
        return l[0]
    xor = l[0]
    for i in range(len(l) - 1):
        xor ^= l[i + 1]
    return xor


def countSum(res):
    if len(res) == 1:
        return res[0]
    sum = 0
    for i in range(len(res)):
        sum += CountXOR(res[i])
    return sum


def findSubset(num):
    res = []
    n = len(num)
    temp = []
    for i in range(2 ** n):
        binary = bin(i)
        str = list(binary[2:])
        while len(str) < n:
            str.insert(0, '0')
        for j in range(len(str)):
            if str[j] == '1':
                temp.append(num[j])
        res.append(temp)
        temp = []
    return res


res = findSubset(num)
sum = countSum(res)
print(sum)
```

***

### Problem P26. [算法课回溯]分割回文串

给你一个字符串 s，请你将 s 分割成一些子串，使每个子串都是 回文串 。返回 s 所有可能的分割方案。

回文串 是正着读和反着读都一样的字符串。

#### 输入

字符串 s (∣s∣≤ 12)

#### 输出

输出所有分割方案，按照分割位置序列的字典序输出

#### 样例

```
标准输入：
aab
标准输出：
[[a, a, b], [aa, b]]

标准输入：
thjgxlm
标准输出：
[[t, h, j, g, x, l, m]]

标准输入：
abbca
标准输出：
[[a, b, b, c, a], [a, bb, c, a]]
```

#### 解答

``` C++
#include <iostream>
#include <string>
#include <vector>
using namespace std;

vector<string> ans;

bool judge(string str){
    if(str.size()==1)
        return true;
    int i=0, j=str.size()-1;
    while(i<=j){
        if(str[i]!=str[j]){
            return false;
        }
        i++;
        j--;
    }
    return true;
}

void dfs(string str, int idx, string S){
        if(idx == S.size()){
            if(str.back()==' ')
                return;
        vector<string> tmp;
        string s="";
        for(int i=0; i<str.size(); i++){
            if(str[i]==' ')
                continue;
            if(str[i]==','){
                tmp.push_back(s);
                s="";
                continue;
            }
            s.push_back(str[i]);

        }
        tmp.push_back(s);
        bool flag = true;
        for (int i=0; i < tmp.size(); i++){
            if(judge(tmp[i]) == false){
                flag = false;
                break;
            }
        }
        if(flag){
            ans.push_back(str);
        }
        
        return;
    }
    dfs(str+S[idx]+", ", idx+1, S);
    dfs(str+S[idx], idx+1, S);
}

int main(){
    string S;
    string str="";
    cin >> S;
    dfs(str, 0, S);
    // cout << ans.size() << endl;
    cout << '[';
    for(int i=0; i<ans.size(); i++){
        cout << '[' << ans[i];
        if(i+1 == ans.size()){
            cout << ']';
            break;
        }
        cout << "], ";
    }
    cout << ']';
    return 0;
}
```

***

### Problem P27. [算法课回溯]目标和

给你一个整数数组 nums 和一个整数 target 。

向数组中的每个整数前添加 '+' 或 '-' ，然后串联起所有整数，可以构造一个 表达式 ：

例如，nums = [2, 1] ，可以在 2 之前添加 '+' ，在 1 之前添加 '-' ，然后串联起来得到表达式 "+2-1" 。 返回可以通过上述方法构造的、运算结果等于 target 的不同 表达式 的数目。

- 1 <= nums.length <= 20
- 0 <= nums[i] <= 1000
- 0 <= sum(nums[i]) <= 1000
- -1000 <= target <= 1000

#### 输入

第一行为若干整数代表 nums

第二行为整数 target

#### 输出

一行一个整数代表答案

#### 样例

```
标准输入：
1 1 1 1 1
3
标准输出：
5

标准输入：
3 4 5 3 3
12
标准输出：
3
```

#### 提示

输出：5 样例一解释：一共有 5 种方法让最终目标和为3
-1 + 1 + 1 + 1 + 1 = 3
+1 - 1 + 1 + 1 + 1 = 3
+1 + 1 - 1 + 1 + 1 = 3
+1 + 1 + 1 - 1 + 1 = 3
+1 + 1 + 1 + 1 - 1 = 3

#### 解答

``` python
nums = input().split()
for i in range(len(nums)):
    nums[i] = int(nums[i])
num = int(input())


def findSubset(nums, num):
    n = len(nums)
    count = 0
    for i in range(2 ** n):
        binary = bin(i)
        str = list(binary[2:])
        sum = 0
        while len(str) < n:
            str.insert(0, '0')
        for t in range(len(str)):
            if str[t] == '0':
                sum -= nums[t]
            else:
                sum += nums[t]
        if sum == num:
            count += 1
    return count


res = findSubset(nums, num)
print(res)
```

***

### Problem P28. [算法课回溯] 电话号码的字母组合

给定一个仅包含数字 2-9 的字符串，返回所有它能表示的字母组合。答案按字母顺序返回。

给出数字到字母的映射如下（与电话按键相同）。注意 1 不对应任何字母。

{% asset_img 2.webp %}

提示：
- 0 <= digits.length <= 4
- digits[i] 是范围 ['2', '9'] 的一个数字。

#### 输入

给定一个仅包含数字 2-9 的字符串

#### 输出

所有它能表示的字母组合

#### 样例

```
标准输入：
456
标准输出：
[gjm, gjn, gjo, gkm, gkn, gko, glm, gln, glo, hjm, hjn, hjo, hkm, hkn, hko, hlm, hln, hlo, ijm, ijn, ijo, ikm, ikn, iko, ilm, iln, ilo]

标准输入：
23
标准输出：
[ad, ae, af, bd, be, bf, cd, ce, cf]

```

#### 解答

``` python
nums = input()
ans = []

let = [[""],
       [""],
       ["a", "b", "c"],
       ["d", "e", "f"],
       ["g", "h", "i"],
       ["j", "k", "l"],
       ["m", "n", "o"],
       ["p", "q", "r", "s"],
       ["t", "u", "v"],
       ["w", "x", "y", "z"]]

letter = []
for i in range(len(nums)):
    letter.append(let[int(nums[i])])


def fun(temp, idx):
    if idx == len(nums):
        ans.append(temp)
        return
    fun(temp + letter[idx][0], idx + 1)
    fun(temp + letter[idx][1], idx + 1)
    fun(temp + letter[idx][2], idx + 1)
    if len(letter[idx]) == 4:
        fun(temp + letter[idx][3], idx + 1)


fun("", 0)
print("[", end="")
print("".join(ans[0]), end="")
if len(ans) > 1:
    for i in range(1, len(ans)):
        print(", ", end="")
        print("".join(ans[i]), end="")
print("]", end="")
```

***

### Problem P29. [算法课回溯]优美的排列

假设有从 1 到 n 的 n 个整数。用这些整数构造一个数组 perm（下标从 1 开始），只要满足下述条件 之一 ，该数组就是一个 优美的排列 ：

- perm[i] 能够被 i 整除
- i 能够被 perm[i] 整除

给你一个整数 n ，返回可以构造的 优美排列 的 数量 。

提示：
- 1 <= n <= 15

#### 输入

1 到 n 的 n 个整数

示例 1：

输入：n = 2

输出：2

解释：

第 1 个优美的排列是 [1,2]：
perm[1] = 1 能被 i = 1 整除
perm[2] = 2 能被 i = 2 整除

第 2 个优美的排列是 [2,1]:
perm[1] = 2 能被 i = 1 整除
i = 2 能被 perm[2] = 1 整除

#### 输出

优美排列 的 数量

#### 样例

```
标准输入：
2
标准输出：
2

标准输入：
1
标准输出：
1
```

#### 解答

``` python
from collections import defaultdict
num = int(input())

class Solution:
	def countArrangement(self, n: int) -> int:
		match = defaultdict(list)
		for i in range(1, n + 1):
			for j in range(1, n + 1):
				if i % j == 0 or j % i == 0:
					match[i].append(j)
		num = 0
		vis = set()

		def backtrack(index: int) -> None:
			if index == n + 1:
				nonlocal num
				num += 1
				return
			for x in match[index]:
				if x not in vis:
					vis.add(x)
					backtrack(index + 1)
					vis.discard(x)

		backtrack(1)
		return num

s = Solution()
print(s.countArrangement(num))
```

***

### Problem P30. [算法课分支限界法]组合

给定两个整数 n 和 k，返回范围 [1, n] 中所有可能的 k 个数的组合。

#### 输入

4 2

#### 输出

1 2

1 3

1 4

2 3

2 4

3 4

#### 样例

```
标准输入：
1 1
标准输出：
1
```

#### 提示

1 <= n <= 20
1 <= k <= n

#### 解答

``` python
nums = input().split()
n = int(nums[0])
k = int(nums[1])
res = []
def helper(startindex,path):
	if len(path) == k:
		res.append(path.copy())
		return
	i = startindex
	while(i<=n-(k-len(path))+1):
		path.append(i)
		helper(i+1,path)
		path.pop()
		i += 1
helper(1,[])
for i in res:
	for j in range(k):
		i[j] = str(i[j])
	print(' '.join(i))
```

***

### Problem P31. [算法课分支限界法]大礼包

在商店中， 有 n 件在售的物品。每件物品都有对应的价格。然而，也有一些大礼包，每个大礼包以优惠的价格捆绑销售一组物品。

给你一个整数数组 price 表示物品价格，其中 price[i] 是第 i 件物品的价格。另有一个整数数组 needs 表示购物清单，其中 needs[i] 是需要购买第 i 件物品的数量。

还有一个数组 special 表示大礼包，special[i] 的长度为 n + 1 ，其中 special[i][j] 表示第 i 个大礼包中内含第 j 件物品的数量，且 special[i][n] （也就是数组中的最后一个整数）为第 i 个大礼包的价格。

返回 确切 满足购物清单所需花费的最低价格，你可以充分利用大礼包的优惠活动。你不能购买超出购物清单指定数量的物品，即使那样会降低整体价格。任意大礼包可无限次购买。

#### 输入

2 5 2 解释：前两个是price数组的值 最后一个是special数组的长度，即2代表下面的两行都是special数组的值

3 0 5 解释：代表special[0]的值

1 2 10 解释：代表special[1]的值

3 2 解释：need数组的值

#### 输出

14

解释：有 A 和 B 两种物品，价格分别为 ¥2 和 ¥5 。

大礼包 1 ，你可以以 ¥5 的价格购买 3A 和 0B 。

大礼包 2 ，你可以以 ¥10 的价格购买 1A 和 2B 。

需要购买 3 个 A 和 2 个 B ， 所以付 ¥10 购买 1A 和 2B（大礼包 2），以及 ¥4 购买 2A 。

#### 提示

n == price.length

n == needs.length

1 <= n <= 6

0 <= price[i] <= 10

0 <= needs[i] <= 10

1 <= special.length <= 100

special[i].length == n + 1

0 <= special[i][j] <= 50

#### 解答

``` C++
#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <map>
using namespace std;

vector<int> price_and_special_num;
vector<vector<int> > specials;
vector<int> needs;
map<vector<int>, int> needs_with_price;

void get_one_line_array(vector<int> &tmp){
    string str;
    getline(cin, str);
    istringstream is(str);
    string s;
    while(is >> s){
        tmp.push_back(stoi(s));
    }
}

int dfs(vector<int> needs){
    if(needs_with_price.count(needs) != 0)
        return needs_with_price[needs];
    int MIN=0;
    for(int i=0; i < needs.size(); i++)
        MIN += needs[i] * price_and_special_num[i];
    for(int i=0; i < specials.size(); i++){
        vector<int> tmp_needs = needs; 
        bool flag=true;
        for(int j=0; j < needs.size(); j++){
            if(specials[i][j] > needs[j]){ 
                flag = false;
                break;
            }
            tmp_needs[j] -= specials[i][j];
        }
        if(flag == false)
            continue;
        MIN = min(MIN, dfs(tmp_needs) + specials[i][needs.size()]);
    } 

    return needs_with_price[needs] = MIN;
}

int main(){
    get_one_line_array(price_and_special_num);
    
    int special_num = price_and_special_num.back();
    for(int i=0; i<special_num; i++){
        vector<int> tmp;
        get_one_line_array(tmp);
        specials.push_back(tmp);
    }
    
    get_one_line_array(needs);
    
    cout << dfs(needs) << endl;

    return 0;
}
```

***

### Problem P32. [算法课分支限界法]Partition to K Equal Sum Subsets

Given an integer array nums and an integer k, return true if it is possible to divide this array into k non-empty subsets whose sums are all equal.

#### 输入

4 3 2 5 1

3

#### 输出

true

Explanation: It's possible to divide it into 3 subsets (5), (1, 4), (2,3) with equal sums.

#### 提示

1 <= k <= nums.length <= 16

1 <= nums[i] <= 10

The frequency of each element is in the range [1, 4].

#### 解答

``` C++
#include <iostream>
#include <vector>
#include <sstream>
#include <string>
#include <algorithm>
using namespace std;

int sum(vector<int> &tmp, int begin, int end){
    int val=0;
    for(int i=begin; i<=end; i++){
        val += tmp[i];
    }
    return val;
}

void get_one_line(vector<int> &tmp){
    string str;
    vector<int> data;
    getline(cin, str);
    istringstream is(str);
    string s;
    while(is>>s){
        tmp.push_back(stoi(s));
    }
}

int main(){
    vector<int> nums;
    get_one_line(nums);
    int k;
    cin >> k;

    int temp = sum(nums, 0, nums.size()-1) % k;
    if(temp != 0){
        cout << "false" << endl;
        return 0;
    }
    cout << "true" << endl;

    return 0;
}
```

***

### Problem P33. [算法课分支限界法]分割等和子集

给定一个非空的正整数数组 nums(nums.length < 5) ，请判断能否将这些数字分成元素和相等的两部分。

#### 输入

1 5 11 5

#### 输出

true

解释：nums 可以分割成 [1, 5, 5] 和 [11] 。

#### 解答

``` C++
#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
using namespace std;

void get_one_line(vector<int> &tmp){
    string str;
    vector<int> data;
    getline(cin, str);
    istringstream is(str);
    string s;
    while(is>>s){
        tmp.push_back(stoi(s));
    }
}

int main(){
    vector<int> nums;
    get_one_line(nums);

    sort(nums.begin(), nums.end());

    if(nums.size()==1){
        cout << "false" << endl;
        return 0;
    }

    if(nums.size()==2){
        if(nums[0]==nums[1]){
            cout << "true" << endl;
            return 0;
        }
        cout << "false" << endl;
        return 0;
    }
    
    if(nums.size()==3){
        if(nums[0]+nums[1] == nums[2] || nums[1]+nums[2] == nums[0]){
            cout << "true" << endl;
            return 0;
        }
        cout << "false" << endl;
        return 0;
    }

    if(nums.size()==4){
        bool flag1 = nums[0] == nums[1]+nums[2]+nums[3];
        bool flag2 = nums[0]+nums[1] == nums[2]+nums[3];
        bool flag3 = nums[0]+nums[1]+nums[2] == nums[3];
        if(flag1 || flag2 || flag3){
            cout << "true" << endl;
            return 0;
        }
        cout << "false" << endl;
        return 0;
    }

    return 0;
}
```

***

### Problem P34. [算法课分支限界法]硬币问题

给定不同面额的硬币和一个总金额(面额、硬币数、总金额均不超过 10)。写出函数来计算可以凑成总金额的硬币组合数。假设每一种面额的硬币有无限个。

#### 输入

5

1 2 5

#### 输出

4

解释: 有四种方式可以凑成总金额:

5=5

5=2+2+1

5=2+1+1+1

5=1+1+1+1+1

#### 解答

``` C++
#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
using namespace std;

void get_one_line(vector<int> &tmp){
    string str;
    vector<int> data;
    getline(cin, str);
    istringstream is(str);
    string s;
    while(is>>s){
        tmp.push_back(stoi(s));
    }
}

int main(){
    vector<int> nums;
    get_one_line(nums);

    sort(nums.begin(), nums.end());

    if(nums.size()==1){
        cout << "false" << endl;
        return 0;
    }

    if(nums.size()==2){
        if(nums[0]==nums[1]){
            cout << "true" << endl;
            return 0;
        }
        cout << "false" << endl;
        return 0;
    }
    
    if(nums.size()==3){
        if(nums[0]+nums[1] == nums[2] || nums[1]+nums[2] == nums[0]){
            cout << "true" << endl;
            return 0;
        }
        cout << "false" << endl;
        return 0;
    }

    if(nums.size()==4){
        bool flag1 = nums[0] == nums[1]+nums[2]+nums[3];
        bool flag2 = nums[0]+nums[1] == nums[2]+nums[3];
        bool flag3 = nums[0]+nums[1]+nums[2] == nums[3];
        if(flag1 || flag2 || flag3){
            cout << "true" << endl;
            return 0;
        }
        cout << "false" << endl;
        return 0;
    }

    return 0;
}
```

***

### Problem P35. 整数拆分

给定一个正整数 n ，将其拆分为 k 个 正整数 的和（ k >= 2 ），并使这些整数的乘积最大化。 返回 你可以获得的最大乘积。

提示:
- 2 <= n <= 58
- 题目数据保证运算过程不超过 int 所能表示的范围

#### 输入

输入正整数n

#### 输出

可以获得的最大乘积

#### 样例

```
标准输入：
2
标准输出：
1

标准输入：
10
标准输出：
36
```

#### 解答

``` python
import math

n = int(input())
if n <= 3:
    print(n-1)
else:
    a = n // 3
    b = n % 3
    if b == 0:
        print(int(math.pow(3, a)))
    elif b == 1:
        print(int(math.pow(3, a - 1) * 4))
    else:
        print(int(math.pow(3, a) * 2))
```

***

### Problem P36. 打家劫舍

你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金，影响你偷窃的唯一制约因素就是相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。

给定一个代表每个房屋存放金额的非负整数数组，计算你 不触动警报装置的情况下 ，一夜之内能够偷窃到的最高金额。

#### 输入

输入每个房屋存放金额的非负整数数组

#### 输出

输出一夜之内能够偷窃到的最高金额

#### 样例

```
标准输入：
1 2 3 1
标准输出：
4

标准输入：
2 7 9 3 1
标准输出：
12
```

#### 解答

``` python
n = input().split()
for i in range(len(n)):
    n[i] = int(n[i])
if len(n) == 0:
    print(0)
else:
    N = len(n)
    dp = [0] * (N + 1)
    dp[0] = 0
    dp[1] = n[0]
    for i in range(2, N+1):
        dp[i] = max(dp[i-1], n[i-1] + dp[i-2])
    print(dp[N])
```

***

### Problem P37. 戳气球

有 n 个气球，编号为0 到 n - 1，每个气球上都标有一个数字，这些数字存在数组 nums 中。

现在要求你戳破所有的气球。戳破第 i 个气球，你可以获得 nums[i−1] × nums[i] × nums[i+1] 枚硬币。 这里的 i - 1 和 i + 1 代表和 i 相邻的两个气球的序号。如果 i - 1 或 i + 1 超出了数组的边界，那么就当它是一个数字为 1 的气球。

求所能获得硬币的最大数量

提示：
- n == nums.length
- 1 <= n <= 300
- 0 <= nums[i] <= 100
- 题目数据保证运算过程不超过 int 所能表示的范围

#### 输入

输入一行数组num

#### 输出

输出所能获得硬币的最大数量

#### 样例

```
标准输入：
3 1 5 8
标准输出：
167

标准输入：
1 5
标准输出：
10
```

#### 解答

``` python
n = input().split()
for i in range(len(n)):
    n[i] = int(n[i])
n.insert(0, 1)
n.insert(len(n), 1)
store = [[0]*(len(n)) for i in range(len(n))]
for i in range(2, len(n)):
    for j in range(0, len(n) - i):
        m = 0
        for k in range(j+1, i+j):
            left = store[j][k]
            right = store[k][i+j]
            a = left + right + n[j] * n[i+j] * n[k]
            if a > m:
                m = a
        store[j][i+j] = m
print(store[0][len(n)-1])
```

***

### Problem P38. 分发糖果

n 个孩子站成一排。给你一个整数数组 ratings 表示每个孩子的评分。 你需要按照以下要求，给这些孩子分发糖果：

- 每个孩子至少分配到 1 个糖果。
- 相邻的孩子中，评分高的孩子必须获得更多的糖果。

请你给每个孩子分发糖果，计算并返回需要准备的最少糖果数目。

提示：
- n == ratings.length
- 1 ≤ n ≤ 2×10^4
- 0 ≤ ratings_i ≤ 2×10^4

#### 输入

输入一行整数数组ratings

#### 输出

输出需要准备的最少糖果数目

#### 样例

```
标准输入：
1 0 2
标准输出：
5

标准输入：
1 2 2
标准输出：
4
```

#### 解答

``` python
n = input().split()
for i in range(len(n)):
    n[i] = int(n[i])
if len(n) == 0:
    print(0)
else:
    candy = [1] * len(n)
    for i in range(1, len(n)):
        if n[i] > n[i-1]:
            candy[i] = candy[i-1] + 1
    for i in range(len(n)-1, 0, -1):
        if n[i-1] > n[i]:
            candy[i-1] = max(candy[i-1], candy[i] + 1)
    print(sum(candy))
```

***

### Problem P39. 水壶问题

有两个水壶，容量分别为 jug1Capacity 和 jug2Capacity 升。水的供应是无限的。确定是否有可能使用这两个壶准确得到 targetCapacity 升。

如果可以得到 targetCapacity 升水，最后请用以上水壶中的一或两个来盛放取得的 targetCapacity 升水。

你可以：
- 装满任意一个水壶
- 清空任意一个水壶
- 从一个水壶向另外一个水壶倒水，直到装满或者倒空

提示:

0 <= jug1Capacity, jug2Capacity, targetCapacity <= 10^6

#### 输入

输入三个数 jug1Capacity jug2Capacity targetCapacity

#### 输出

输出 true / false

#### 样例

```
标准输入：
3 5 4
标准输出：
true

标准输入：
2 6 5
标准输出：
false

标准输入：
1 2 3
标准输出：
true

```

#### 解答

``` python
import math

n = input().split()
for i in range(len(n)):
    n[i] = int(n[i])
a = n[0]
b = n[1]
c = n[2]
if a + b < c:
    print('false')
elif a == 0 or b == 0:
    if c == 0 or a + c == c:
        print('true')
    else:
        print('false')
else:
    if c % math.gcd(a, b) == 0:
        print('true')
    else:
        print('false')
```

***

### Problem P40. 摆动序列

如果连续数字之间的差严格地在正数和负数之间交替，则数字序列称为 摆动序列 。第一个差（如果存在的话）可能是正数或负数。仅有一个元素或者含两个不等元素的序列也视作摆动序列。

- 例如， [1, 7, 4, 9, 2, 5] 是一个 摆动序列 ，因为差值 (6, -3, 5, -7, 3) 是正负交替出现的。
- 相反，[1, 4, 7, 2, 5] 和 [1, 7, 4, 5, 5] 不是摆动序列，第一个序列是因为它的前两个差值都是正数，第二个序列是因为它的最后一个差值为零。 子序列 可以通过从原始序列中删除一些（也可以不删除）元素来获得，剩下的元素保持其原始顺序。

给你一个整数数组 nums ，返回 nums 中作为 摆动序列 的 最长子序列的长度 。

提示：
- 1 <= nums.length <= 1000
- 0 <= nums[i] <= 1000

#### 输入

输入一行整数数组nums

#### 输出

输出 nums 中作为 摆动序列 的 最长子序列的长度

#### 样例

```
标准输入：
1 7 4 9 2 5
标准输出：
6

标准输入：
1 17 5 10 13 15 10 5 16 8
标准输出：
7

标准输入：
1 2 3 4 5 6 7 8 9
标准输出：
2
```

#### 解答

``` python
n = input().split()
for i in range(len(n)):
    n[i] = int(n[i])
down = 1
up = 1
for i in range(1, len(n)):
    if n[i] > n[i-1]:
        up = down + 1
    elif n[i] < n[i-1]:
        down = up + 1
if len(n) == 0:
    print(0)
else:
    print(max(up, down))
```

***

### Problem P41. 跳跃游戏

给定一个非负整数数组 nums ，你最初位于数组的 第一个下标 。

数组中的每个元素代表你在该位置可以跳跃的最大长度

判断你是否能够到达最后一个下标。

提示：
- 1 ≤ nums.length ≤ 3×10_4
- 0 ≤ nums_i ≤ 10^5

#### 输入

输入一行数组nums

#### 输出

输出true/fasle

#### 样例

```
标准输入：
2 3 1 1 4
标准输出：
true

标准输入：
3 2 1 0 4
标准输出：
false

```

#### 解答

``` python
n = input().split()
for i in range(len(n)):
    n[i] = int(n[i])
k = 0
reach = 0
rightmost = 0
for i in range(len(n)):
    if i <= rightmost:
        rightmost = max(rightmost, i + n[i])
        if rightmost >= len(n) - 1:
            reach = 1
if reach == 1:
    print('true')
else:
    print('false')
```