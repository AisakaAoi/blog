---
title: Python-JC1001 Assessment 2
categories:
  - 🌙基础学习
  - ⭐Python
abbrlink: 3e62d3a3
date: 2022-12-13 00:56:42
tags:
---

### Part 1

#### Question 1

Write a function named **stringToNum** that receives a string parameter of numbers separated with commas and returns a list of integers based on the string parameter e.g. **stringToNum("5, 6, 7, 8")** would return [5, 6, 7, 8].
(0.5 mark)

<!--more-->

**题目翻译：**

编写一个名为**stringToNum**的函数，该函数接收一个由逗号分隔的数字组成的字符串参数，并根据字符串参数返回一个整数列表，例如 **stringToNum("5, 6, 7, 8")** 将返回[5, 6, 7, 8]。

**本题考点：**
- 字符串的split()函数，split()默认用空格作为分隔符，即split(' ')。str1.split(',')的意思是将str1这个string字符串按照逗号分隔开，并将分割后的结果返回一个列表
- 使用for循环将列表里的string元素挨个取出并转为int类型

**题目分析：**
1. 函数名：stringToNum，输入1个参数，类型为string
2. 接受字符串转化为列表
3. 将列表里的string元素转化为int
4. 返回整数列表list

``` python
def stringToNum(str1):                  # 1. stringToNum，输入1个参数，类型为string
    temp = str1.split(',')              # 2. 接受字符串转化为列表
    temp = [int(num) for num in temp]   # 3. 将列表里的string元素转化为int
    return temp                         # 4. 返回类型list


if __name__ == '__main__':
    print(stringToNum("5,6,7,8"))
```

***

#### Question 2

Write a function named **n_w_h_input** that receives a string followed by two floats. The function should return a tuple containing the string argument in upper case and the two floats rounded to 1 decimal place.
(0.5 mark)

**题目翻译：**

编写一个名为**n_w_h_input**的函数，接收一个字符串和两个浮点数。该函数应返回一个元组，其中包含大写的字符串参数，并且两个浮点数四舍五入到小数点后一位。

**本题考点：**
- 字符串的upper()函数，str1.upper()即可将str1这个字符串里的英文字母都变成大写
- round()函数，接受两个参数，第一个参数是要四舍五入的数字，第二个参数是要保留的小数位数。round(num1, 1)即把num1这个浮点数四舍五入保留1位小数
- tuple()函数输入一个数字、字符串、列表或者元组（只需要一个参数，不可以是多个数据用逗号隔开），将这个数据变成元组类型返回

**题目分析：**
1. 函数名：n_w_h_input，输入3个参数，类型为string、float、float
2. 把字符串里的字母都变成大写
3. 把浮点数四舍五入到小数点后一位
4. 把3个参数整合为一个元组

``` python
def n_w_h_input(str1, num1, num2):      # 1. n_w_h_input，输入3个参数，类型为string、float、float
    str1 = str1.upper()                 # 2. 把字符串里的字母都变成大写
    num1 = round(num1, 1)               # 3. 把浮点数四舍五入到小数点后一位
    num2 = round(num2, 1)
    return tuple([str1, num1, num2])    # 4. 把3个参数整合为一个元组


if __name__ == '__main__':
    print(n_w_h_input('yy', 1.11, 2.22))
```

***

#### Question 3

Write a function named **n_w_h_output** that receives a string followed by two floats. The function should print out these parameters using the format below e.g. if the function is called with the values, **Sam, 69.7, 1.9** the function should print:
**“Sam’s weight is 69.7 and his/her height is 1.9”**
(0.5 mark)

**题目翻译：**

编写一个名为**n_w_h_output**的函数，该函数接收一个字符串和两个浮点数。函数应该使用下面的格式打印出这些参数，例如，如果函数输入**Sam, 69.7, 1.9**，函数应该打印:
**“Sam’s weight is 69.7 and his/her height is 1.9”**

**本题考点：**
- 字符串间的拼接可以使用加号
- 非字符串数据要用加号和字符串拼接的时候，需要用str()函数先转为字符串。str(num1)表示将num1这个数字（可以是int，也可以是float，其他类型也可以）转化为string类型

**题目分析：**
1. 函数名：n_w_h_output，输入3个参数，类型为string、float、float
2. 把字符串拼接起来

``` python
def n_w_h_output(str1, num1, num2):         # 1. n_w_h_output，输入3个参数，类型为string、float、float
    print(str1 + "'s weight is " + str(num1) + " and his/her height is " + str(num2))       # 2. 把字符串拼接起来


if __name__ == '__main__':
    n_w_h_output('Sam', 69.7, 1.9)
```

***

#### Question 4

Write a function named **calcBMI** which receives two floats representing weight and height and then calculates body mass index (BMI). Your function should use the following formula:
BMI is calculated as: weight / height / height * 10,000
The number should be rounded to 1 decimal place.
(0.5 mark)

**题目翻译：**
编写一个名为**calcBMI**的函数，该函数接收代表体重和身高的两个浮点数，然后计算身体质量指数(BMI)。你的函数应该使用以下公式:
BMI的计算公式为: 体重 / 身高 / 身高 * 10000
这个数字应该四舍五入到小数点后一位。

**本题考点：**
- 还是round()函数
- 乘法与除法这种同级运算直接连着写、连着计算就可以

**题目分析：**
1. 函数名：calcBMI，输入2个参数，类型为float、float
2. round()保留一位小数，按公式计算BMI

``` python
def calcBMI(num1, num2):                            # 1. calcBMI，输入2个参数，类型为float、float
    return round(num1 / num2 / num2 * 10000, 1)     # 2. round()保留一位小数，按公式计算BMI


if __name__ == '__main__':
    print(calcBMI(64.5, 179.5))
```

***

#### Question 5

Write a function named **bmiCat** which receives a float representing BMI and then returns a weight category based on the following criteria:
-  BMI categories are as follows:
    - Lower than 18.5, Underweight
    - Between 18.5 and 24.9, Healthy
    - Between 25 and 29.9, Overweight
    - Between 30 and 39.9, Obese
    - More than 40, Severely obese
(2.5 marks)

**题目翻译：**
写一个名为**bmiCat**的函数，它接收一个表示BMI的浮点数，然后根据以下标准返回一个权重类别:
- BMI分类如下:
    - 低于 18.5，体重过轻
    - 18.5 到 24.9之间，健康
    - 25 到 29.9之间，超重
    - 30 至 39.9，肥胖
    - 40 以上，严重肥胖

**本题考点：**
- 使用if、elif、else等判断来进行类别分类

**题目分析：**
1. 函数名：bmiCat，输入1个参数，类型为float
2. 使用if、elif、else等判断来进行类别分类

``` python
def bmiCat(num1):                   # 1. bmiCat，输入1个参数，类型为float
    if num1 < 18.5:                 # 2. 使用if、elif、else等判断来进行类别分类
        return "Underweight"
    elif 18.5 <= num1 <= 24.9:
        return "Healthy"
    elif 25 <= num1 <= 29.9:
        return "Overweight"
    elif 30 <= num1 <= 39.9:
        return "Obese"
    elif 40 <= num1:
        return "Severely obese"


if __name__ == '__main__':
    print(bmiCat(20))
```

***

#### Question 6

Write a function named **bmiReport** which receives a name, weight, height, bmi and weight category. The function should return a nested dictionary. The outer dictionary should contain a single key, that is the name passed as a parameter. The inner dictionary should contain keys for each of the remaining parameters, weight, height, BMI, weight category and each key should be assigned the value passed when the function is called.
(0.5 mark)

**题目翻译：**
编写一个名为**bmiReport**的函数，该函数接收一个名称、体重、身高、bmi和体重类别。函数应该返回一个嵌套的字典。外部字典应该包含一个键，即作为参数传递的名称。内部字典应该包含每个剩余参数的键，体重，身高，BMI，体重类别，每个键都应该被赋值为函数调用时传递的值。

**本题考点：**
- 字典和嵌套字典的使用。（具体初始化和使用方法百度一下）

**题目分析：**
1. 函数名：bmiReport，输入5个参数，类型为string、float、float、float、string
2. 先构造内部字典，表示weight, height, bmi, category
3. 用另一个字典进行嵌套，用名字来找到内部字典

``` python
def bmiReport(name1, weight1, height1, bmi1, category1):                                        # 1. bmiReport，输入5个参数，类型为string、float、float、float、string
    dic1 = {'weight': weight1, 'height': height1, 'BMI': bmi1, 'weight category': category1}    # 2. 先构造内部字典，表示weight, height, bmi, category
    return {name1: dic1}                                                                        # 3. 用另一个字典进行嵌套，用名字来找到内部字典

if __name__ == '__main__':
    bmiReport('Sam', 65, 180, 20, 'Healthy')
```

***

### Part 2

#### Question 7

Write a function named **oddList**, which receives two integers and returns a list of all odd numbers between the first and second integer parameters. The returned list should include the second integer, if it is an odd number.
(1 mark)

**题目翻译：**
编写一个名为**oddList**的函数，该函数接收两个整数，并返回第一个和第二个整数参数之间的所有奇数的列表。返回的列表应该包括第二个整数，如果它是一个奇数。

**本题考点：**
- 使用for in range进行区间内遍历
- range(a, b)表示从a到b（包括a但不包括b，即左闭右开区间，[a, b)）
- 奇数的判断方法之一：i % 2 == 1
- 使用列表的append()函数将元素添加到列表中

**题目分析：**
1. 函数名：oddList，输入2个参数，类型为int、int
2. 创建一个空列表
3. 在区间内循环，因为最后如果是奇数也需要包含，所以要加一
4. 是否为奇数的判断
5. 是奇数，则添加进要返回的列表中
6. 返回列表

``` python
def oddList(num1, num2):            # 1. oddList，输入2个参数，类型为int、int
    temp = []                       # 2. 创建一个空列表
    for i in range(num1, num2+1):   # 3. 在区间内循环，因为最后如果是奇数也需要包含，所以要加一
        if i % 2 == 1:              # 4. 是否为奇数的判断
            temp.append(i)          # 5. 是奇数，则添加进要返回的列表中
    return temp                     # 6. 返回列表


if __name__ == '__main__':
    print(oddList(1, 7))
```

***

#### Question 8

Write a function named **reverseString**, which receives a string and returns the string with all characters reversed e.g. if the function is called with the parameter **PJ** it will return **JP**.
(0.5 mark)

**题目翻译：**
编写一个名为**reverseString**的函数，该函数接收一个字符串并返回所有反转字符的字符串，例如，如果使用参数**PJ**调用该函数，它将返回**JP**。

**本题考点：**
- 字符串快速反转。[::-1]即[参数1：参数2：-1]，前两个为空表示访问范围等为默认，第三个参数-1表示倒着数

**题目分析：**
1. 函数名：reverseString，输入1个参数，类型为string
2. 将字符串反转

``` python
def reverseString(str1):    # 1. reverseString，输入1个参数，类型为string
    return str1[::-1]       # 2. 将字符串反转


if __name__ == '__main__':
    print(reverseString('abc'))
```

***

#### Question 9

Write a function named **startAndEnd**, which receives a list and returns True if the start and end of the list are the same e.g. if the function is called with the parameter **[1, 2, 1]** it will return true but if the function is called with the parameter **[1, 2, 3]** it will return False.
(1 Mark)

**题目翻译：**
编写一个名为**startAndEnd**的函数，它接收一个列表，如果列表的开头和结尾相同，则返回True，例如，如果函数使用参数 **[1, 2, 1]** 调用，则返回True，但如果函数使用参数 **[1, 2, 3]** 调用，则返回False。

**本题考点：**
- 列表的访问。从0开始访问直到列表长度-1，即0到len(list1)-1
- 访问第一个则为list1[0]。
- 最后一个为list1[len(list1)-1]，因为len(list1)表示list的长度，可以省去简写成-1，即list1[-1]

**题目分析：**
1. 函数名：startAndEnd，输入1个参数，类型为list
2. 判断列表第一个和列表最后一个是否一致

``` python
def startAndEnd(list1):         # 1. startAndEnd，输入1个参数，类型为list
    if list1[0] == list1[-1]:   # 2. 判断列表第一个和列表最后一个是否一致
        return True
    else:
        return False


if __name__ == '__main__':
    print(startAndEnd([1, 2, 1]))
    print(startAndEnd([1, 2, 3]))
```

***

### Part 3

#### Question 10

Write a function called **createBoard**. The function receives no parameters but will return a list containing 3 separate individual lists that represent the noughts and crosses board. Within each list, there should be 3 items containing the string " ".
E.g. a single list will contain **[" ", " ", " "]** and there should be 3 to represent all 9 squares of the noughts and crosses board.
(0.5 mark)
(本博客中文字部分无法显示下划线，用空格代替)

**题目翻译：**
编写一个名为**createBoard**的函数。该函数不接收任何参数，但将返回一个包含3个单独列表的列表，这些列表表示零和叉。在每个列表中，应该有3个包含字符串“ ”的项。
例如，一个列表将包含 **[" ", " ", " "]** ，并且应该有3个来代表棋盘上的所有9个零和叉。

**本题考点：**
- 二维列表的创建
- 一维列表就是[]，然后用逗号分割放进去的元素，例如放进3个" "就是[" ", " ", " "]
- 二维列表就是再用一个[]把多个一维列表框起来，不同的一维列表也是用逗号隔开

**题目分析：**
1. 函数名：createBoard，没有输入的参数
2. 创建二维列表并返回

``` python
def createBoard():          # 1. createBoard，没有输入的参数
    return [                # 2. 创建二维列表并返回
        ['_', '_', '_'],
        ['_', '_', '_'],
        ['_', '_', '_'],
    ]


if __name__ == '__main__':
    print(createBoard())
```

***

#### Question 11

Write a function named **displayBoard**. The function should receive a single parameter, that is a list containing 3 lists, as described in (10). Your function should display the each of the 3 lists on a single line.
E.g.
[“ ”, “ ”, “ ”]
[“ ”, “ ”, “ ”]
[“ ”, “ ”, “ ”]
(0.5 mark)
(本博客中文字部分无法显示下划线，用空格代替)

**题目翻译：**
写一个名为**displayBoard**的函数。函数应该接收一个参数，即包含3个列表的列表，如(10)所述。你的函数应该在一行中显示这三个列表。
如：
[“ ”, “ ”, “ ”]
[“ ”, “ ”, “ ”]
[“ ”, “ ”, “ ”]

**本题考点：**
- for循环的使用
- print()默认调用一次就输出为同一行，并且下次调用print()会在下一行

**题目分析：**
1. 函数名：displayBoard，输入1个参数，类型为list，是一个二维列表
2. 用for循环遍历**二维列表**里面的**一维列表**
3. 输出一维列表

``` python
def displayBoard(list1):    # 1. displayBoard，输入1个参数，类型为list，是一个二维列表
    for i in list1:         # 2. 用for循环遍历二维列表里面的一维列表
        print(i)            # 3. 输出一维列表


if __name__ == '__main__':
    displayBoard([
        ['_', '_', '_'],
        ['_', '_', '_'],
        ['_', '_', '_'],
    ])
```

***

#### Question 12

Write a function named **getMove**. This function receives no parameters but prompts the user to enter a number between 1 to 9. The function should return the number entered by the user or if the user does not enter a number between 1 to 9, the function should return False.
(1 mark)

**题目翻译：**
编写一个名为**getMove**的函数。此函数不接收参数，但提示用户输入1到9之间的数字。函数应该返回用户输入的数字，或者如果用户没有输入1到9之间的数字，函数应该返回False。

**本题考点：**
- input()函数来接受用户的输入，可以在参数添加要提示的字符串
- input()输入的值都会被存为string，不能因为输入了数字就当作int或者float，需要进行类型转换
- 使用if else对变量进行判断

**题目分析：**
1. 函数名：getMove，没有输入的参数
2. 使用input()接收输入
3. 将遍历的类型强制转换为int
4. 对输入进行判断

``` python
def getMove():              # 1. getMove，没有输入的参数
    num = input('please input a number between 1 to 9: ')   # 2. 使用input()接收输入
    num = int(num)          # 3. 将遍历的类型强制转换为int
    if 1 <= num <= 9:       # 4. 对输入进行判断
        return num
    else:
        return False


if __name__ == '__main__':
    print(getMove())
```

***

#### Question 13

Write a function named **intToBoard**. The function should receive a single integer and then return a tuple that contains two integers that represent the coordinates of a single square from the noughts and crosses board.

E.g. Each square on the board may be numbered as follows:
1, 2, 3
4, 5, 6
7, 8, 9

Square 1 may be accessed using (0,0). Therefore, if **intToBoard** receives 1 as a parameter, it should return the tuple (0,0). Note, consider the number of squares (9) and use of the floor and modulo operators.
(4.5 marks)

**题目翻译：**
编写一个名为**intToBoard**的函数。该函数应该接收一个整数，然后返回一个元组，该元组包含两个整数，表示一个正方形的坐标。

例:棋盘上的每个方格可以编号如下:
1 2 3
4 5 6
7 8 9

可以使用(0,0)访问方格1。因此，如果**intToBoard**接收到1作为参数，它应该返回元组(0,0)。注意，考虑平方的数量(9)以及地板运算符和模运算符的使用。

**本题考点：**
- 使用地板除法 // 计算行数，即除法后忽略小数部分，因为有3行，将默认的编号地板除以3后会得到
    1 2 3 -> 0 0 1
    4 5 6 -> 1 1 2
    7 8 9 -> 2 2 3
    因为第一行是0， 第二行是1， 第三行是2，干脆就把坐标减去1，再地板除法以3
    0 1 2 -> 0 0 0
    3 4 5 -> 1 1 1
    6 7 8 -> 2 2 2
    这样就能正确表示行数
- 使用取余 % 计算列数，即不做小数的除法后保留最后的整数余数，因为有3列，将默认的编号对3取余后会得到
    1 2 3 -> 1 2 0
    4 5 6 -> 1 2 0
    7 8 9 -> 1 2 0
    因为第一列是0， 第二列是1， 第三列是2，干脆就把坐标加上2，再对3取余
    3  4  5 -> 0 1 2
    6  7  8 -> 0 1 2
    9 10 11 -> 0 1 2
- 同Q2，tuple()函数的使用

**题目分析：**
1. 函数名：intToBoard，输入1个参数，类型为int
2. 计算这个数字表示处在第几行
3. 计算这个数字表示处在第几列
4. 返回坐标元组

``` python
def intToBoard(num1):               # 1. intToBoard，输入1个参数，类型为int
    temp1 = (num1 - 1) // 3         # 2. 计算这个数字表示处在第几行
    temp2 = (num1 + 2) % 3          # 3. 计算这个数字表示处在第几列
    return tuple([temp1, temp2])    # 4. 返回坐标元组


if __name__ == '__main__':
    print(intToBoard(6))
```

***

#### Question 14

Write a function named **insertToBoard**. This function should receive 3 parameters; the first parameter should be a Tuple, similar to that returned from intToBoard. The second parameter should be a list of 3 lists i.e. the board and the final parameter should be a Boolean value (either True or False). The **insertToBoard** function should as name implies, insert a players move on the board. If the Boolean parameter is True, then the function
should insert an **“X”** into the position of the board, provided by the Tuple of the first parameter. The function should also return a tuple with the value True and the board (list of 3 lists). If the Boolean parameter is False, then the function should insert an **“O”** in the board and return a tuple with the value True and the board. The board should only be updated with valid moves, that is areas on the board which do not contain a **“X”** or **“O”**. If the position specified by the first parameter contains a previous move i.e. an **“X”** or **“O”** then the function should return False and the board.

Remember, a tuple’s items may be accessed similarly to a list:
i.e. consider the Tuple named t, which contains 3 elements: **t = (1,2,3)**. To access the first element, we would use **t[0]**
(1.5 marks)

**题目翻译：**
编写一个名为**insertToBoard**的函数。这个函数应该接收3个参数；第一个参数应该是一个元组，类似于从intToBoard返回的元组。第二个参数应该是3个列表的列表即棋盘，最后一个参数应该是一个布尔值(True或False)。**insertToBoard**函数顾名思义，应该在棋盘上插入一个玩家移动。如果布尔参数为True，则函数
应插入一个 **"X"** 到板的位置，由第一个参数的元组提供。该函数还应该返回一个值为True的元组和board(由3个列表组成的列表)。如果布尔参数为False，则函数应该在板子中插入一个 **"O"** ，并返回一个值为True和板子的元组。棋盘应该只更新有效的移动，即棋盘上不包含 **“X”** 或 **“O”** 的区域。如果第一个参数指定的位置包含之前的移动，即 **"X"** 或 **"O"** ，则该函数应返回False和board。

记住，元组的项可以类似于列表的访问方式:
例如，考虑名为t的元组，它包含3个元素: **t = (1,2,3)**。要访问第一个元素，可以使用 **t[0]**

**本题考点：**
- 元组的访问，跟列表是一样的，题目有说明
- 根据题目要求使用if elif else进行组合，对下棋的逻辑进行整理，像一棵树一样展开决策的枝桠

**题目分析：**
1. 函数名：insertToBoard，输入3个参数，类型为tuple、list、bool
2. 类似于数组的访问得到行row和列col的值
3. 如果没下过，则可以下棋
4. 按照要求下'X'或者'O'
5. 返回成功下棋的True和下过之后的棋盘list
6. 已经下过了，就返回这次没下棋的False和原本的棋盘list

``` python
def insertToBoard(tuple1, list1, bool1):    # 1. insertToBoard，输入3个参数，类型为tuple、list、bool
    row = tuple1[0]                         # 2. 类似于数组的访问得到行row和列col的值
    col = tuple1[1]
    if list1[row][col] == '_':              # 3. 如果没下过，则可以下棋    
        if bool1:
            list1[row][col] = 'X'           # 4. 按照要求下'X'或者'O'
            return tuple([True, list1])     # 5. 返回成功下棋的True和下过之后的棋盘list
        elif not bool1:
            list1[row][col] = 'O'
            return tuple([True, list1])
    else:                                   # 6. 已经下过了，就返回这次没下棋的False和原本的棋盘list
        return tuple([False, list1])


if __name__ == '__main__':
    print(insertToBoard(
        (1, 2),
        [
            ['_', '_', '_'],
            ['_', '_', '_'],
            ['_', '_', '_'],
        ],
        True
    ))
```

***

#### Question 15

Write a function named **checkDraw**. The function receives a single parameter, the board (list of 3 lists). The function should check whether there are any free squares left on the board i.e. a square containing “ ”. If there are squares on the board containing free spaces, then the function should return False, otherwise it should return True.
(2.5 marks)
(本博客中文字部分无法显示下划线，用空格代替)

**题目翻译：**
编写一个名为**checkDraw**的函数。该函数接收一个参数，即board(由3个列表组成的列表)。该函数检查棋盘上是否有剩余的方格，即包含" "的方格。如果棋盘上有包含空闲空间的正方形，则函数应返回False，否则应返回True。

**本题考点：**
- 二维数组的访问。先通过一次遍历得到二维数组里面的一维数组，再第二次遍历得到一维数组里面的元素值。就是先定好按行访问（按顺序访问一维数组），再定好按列访问（按顺序访问单个元素）

**题目分析：**
1. 函数名：checkDraw，输入1个参数，类型为list，二维列表
2. 遍历二维数组bigList，得到里面的一维数组smallList
3. 遍历一维数组smallList，得到里面的单个元素str1
4. 判断单个元素是不是没下过
5. 有一个没下过就False
6. 两层for循环所有判断完都没有False，说明都下过了，为True

``` python
def checkDraw(bigList):         # 1. checkDraw，输入1个参数，类型为list，二维列表
    for smallList in bigList:   # 2. 遍历二维数组bigList，得到里面的一维数组smallList
        for str1 in smallList:  # 3. 遍历一维数组smallList，得到里面的单个元素str1
            if str1 == '_':     # 4. 判断单个元素是不是没下过
                return False    # 5. 有一个没下过就False
    return True                 # 6. 两层for循环所有判断完都没有False，说明都下过了，为True


if __name__ == '__main__':
    print(checkDraw([
            ['_', '_', '_'],
            ['_', '_', '_'],
            ['_', '_', '_'],
        ]))
```

***

#### Question 16

Write a function named **checkWin**. The function receives a single parameter, the board (list of 3 lists). The function should check whether any one of the 8 possible winning conditions are present. The winning conditions are when a horizontal, vertical or diagonal line of 3 squares on the board contain the same symbol (**“X”** or **“O”**). If either of these conditions are met, the function should return True, otherwise it should return False.
(4 marks)

**题目翻译：**

编写一个名为**checkWin**的函数。该函数接收一个参数，即board(由3个列表组成的列表)。该函数应检查8个可能获胜条件中的任何一个是否存在。获胜条件是棋盘上由3个方格组成的水平、垂直或对角线包含相同符号( **“X”** 或 **“O”** )。如果满足其中任何一个条件，函数应返回True，否则应返回False。

**本题考点：**
- 判断胜利就行，不管是X还是O，所以只要三个一样连在一起就是胜利，返回True，8种胜利条件都不满足就是False
- 按行访问数组可以轻松得到同一行的三个元素，不同行同一列的三个元素要么转置变成行，要么用坐标访问
- 8种胜利条件如下：
    按行有3种
    X X X   /   ~ ~ ~   /   ~ ~ ~
    ~ ~ ~   /   X X X   /   ~ ~ ~
    ~ ~ ~   /   ~ ~ ~   /   X X X
    按列有3种
    X ~ ~   /   ~ X ~   /   ~ ~ X
    X ~ ~   /   ~ X ~   /   ~ ~ X
    X ~ ~   /   ~ X ~   /   ~ ~ X
    按对角线有2种
    X ~ ~   /   ~ ~ X
    ~ X ~   /   ~ X ~
    ~ ~ X   /   X ~ ~

**题目分析：**
1. 函数名：checkWin，输入1个参数，类型为list，二维列表
2. 按行访问，如果同一行三个一样就获胜
3. 对二维列表进行转置，使得同一列列也能在一次循环中访问到
4. 对角线进行判断

``` python
def checkWin(list1):                        # 1. checkWin，输入1个参数，类型为list，二维列表
    for i in list1:                         # 2. 按行访问，如果同一行三个一样就获胜
        if i[0] == i[1] == i[2]:
            return True
    list2 = list(map(list, zip(*list1)))    # 3. 对二维列表进行转置，使得同一列列也能在一次循环中访问到
    for i in list2:
        if i[0] == i[1] == i[2]:
            return True
    if list1[0][0] == list1[1][1] == list1[2][2]:   # 4. 对角线进行判断
        return True
    elif list1[0][2] == list1[1][1] == list1[2][0]:
        return True
    return False


if __name__ == '__main__':
    print(checkWin([
        ['X', '_', '_'],
        ['_', 'X', '_'],
        ['_', '_', 'X'],
    ]))
```

***
