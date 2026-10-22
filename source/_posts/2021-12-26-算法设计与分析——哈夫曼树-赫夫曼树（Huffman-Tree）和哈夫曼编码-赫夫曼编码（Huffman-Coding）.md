---
title: 算法设计与分析——哈夫曼树/赫夫曼树（Huffman Tree）和哈夫曼编码/赫夫曼编码（Huffman Coding）
categories:
  - 🌙进阶学习
  - ⭐人工智能 Artificial Intelligence
  - 💫《算法设计与分析》
  - ✨⑥高级数据结构
abbrlink: 4ab53775
date: 2021-12-26 15:06:56
---

赫夫曼编码可以很有效地压缩数据：通常可以节省20%~90%的空间，具体压缩率依赖于数据的特性。我们将待压缩数据看做字符序列。根据每个字符的出现频率，赫夫曼贪心算法构造出字符的最优二进制表示。

<!--more-->

假定我们希望压缩一个10万个字符的数据文件。下图给出了文件中所出现的字符和它们的出现频率。也就是说，文件中只出现了6个不同字符，其中字符a出现了45000次。

{% asset_img 1.webp %}

我们有很多方法可以表示这个文件的信息。在本文中，我们考虑一种二进制字符编码（或简称编码）的方法，每个字符用一个唯一的二进制串表示，称为码字。如果使用定长编码，需要用3位来表示6个字符：$a=000, b=001, \cdots, f=101$。这种方法需要300000个二进制位来编码文件。

变长编码（variable-length code）可以达到比定长编码好得多的压缩率，其思想是**赋予高频字符短码字，赋予低频字符长码字**。上图显示了本例的一种变长编码：1位的串0表示a，4位的串1100表示f。因此，这种编码表示此文件共需

$(45\times1+13\times3+12\times3+16\times3+9\times4+5\times4)\times1000=224000$位。与定长编码相比节约了25%的空间。实际上，我们将看到，这是此文件的最优字符编码。

我们这里只考虑所谓前缀码（prefix code），即没有任何码字是其他码字的前缀。虽然我们这里不会证明，但与任何字符编码相比，前缀码确实可以保证达到最优数据压缩率，因此我们只关注前缀码，不会丧失一般性。

任何二进制字符码的编码过程都很简单，只要将表示每个字符的码字连接起来即可完成文件压缩。例如，使用上图所示的变长前缀码，我们可以将3个字符的文件`abc`编码为0·101·100（0101100），“·”表示连结操作。

前缀码的作用是简化解码过程。由于没有码字是其他码字的前缀，编码文件的开始码字是无歧义的。我们可以简单地识别出开始码字，将其转换回原字符，然后对编码文件剩余部分重复。这种解码过程。在我们的例子中，二进制串001011101可以唯一地解析为0·0·101·1101，解码为`aabe`。

解码过程需要前缀码的一种方便的表示形式，以便我们可以容易地截取开始码字。一种二叉树表示可以满足这种需求，其叶结点为给定的字符。字符的二进制码字用从根结点到该字符叶结点的简单路径表示，其中0意味着“转向左孩子”，1意味着“转向右孩子”。下图给出了两个编码示例的二叉树表示。注意，编码树并不是二叉搜索树，因为叶结点并未有序排列，而内部结点并不包含字符关键字。

{% asset_img 2.webp %}

文件的最优编码方案总是对应一棵满二叉树，即每个非叶结点都有两个孩子结点。前文给出的定长编码实例不是最优的，因为它的二叉树表示并非满二叉树，如上图(a)所示：它包含以10开头的码字，但不包含以11开头的码字。现在我们可以只关注满二叉树了，因此可以说，若$C$为字母表且所有字符的出现频率均为正数，则最优前缀码对应的树恰有$|C|$个叶结点，每个叶结点对应字母表中一个字符，且恰有$|C|-1$个内部结点。

给定一棵对应前缀码的树$T$，我们可以容易地计算出编码一个文件需要多少个二进制位。对于字母表$C$中的每个字符$c$，令属性`c.freq`表示$c$在文件中出现的频率，令`dr(c)`表示$c$的叶结点在树中的深度。注意，`dr(c)`也是字符$c$的码字的长度。则编码文件需要：

$$B(t)=\sum_{c\in C}c.freq\times dr(c)$$

个二进制位，我们将$B(t)$定义为$T$的代价。

### 构造赫夫曼编码

赫夫曼设计了一个贪心算法来构造最优前缀码，被称为赫夫曼编码（Huffman code）。它的正确性证明也依赖于贪心选择性质和最优子结构。接下来，我们并不是先证明这些性质成立然后再设计算法，而是先设计算法。这样做可以帮助我们明确算法是如何做出贪心选择的。

在下面给出的Python代码中，我们假定$C$是一个$n$个字符的集合，而其中每个字符$c\in C$都是一个对象，其属性`freq`给出了字符的出现频率。算法自底向上地构造出对应最优编码的二叉树$T$。它从$|C|$个叶结点开始，执行$|C|-1$个“合并”操作创建出最终的二叉树。算法使用一个以属性`freq`为关键字最小优先队列$Q$，以识别两个最低频率的对象将其合并。当合并两个对象时，得到的新对象的频率设置为原来两个对象的频率之和。

```python
class HuffNode(object):
    """
    定义一个HuffNode虚类，里面包含两个虚方法：
    1. 获取节点的权重函数
    2. 获取此节点是否是叶节点的函数
    """
    def get_wieght(self):
        raise NotImplementedError(
            "The Abstract Node Class doesn't define 'get_wieght'")

    def isleaf(self):
        raise NotImplementedError(
            "The Abstract Node Class doesn't define 'isleaf'")


class LeafNode(HuffNode):
    """
    树叶节点类
    """
    def __init__(self, value=0, freq=0,):
        """
        初始化 树节点 需要初始化的对象参数有 ：value及其出现的频率freq
        """
        super(LeafNode, self).__init__()
        # 节点的值
        self.value = value
        self.wieght = freq

    def isleaf(self):
        """
        基类的方法，返回True，代表是叶节点
        """
        return True

    def get_wieght(self):
        """
        基类的方法，返回对象属性 weight，表示对象的权重
        """
        return self.wieght

    def get_value(self):
        """
        获取叶子节点的 字符 的值
        """
        return self.value


class IntlNode(HuffNode):
    """
    中间节点类
    """
    def __init__(self, left_child=None, right_child=None):
        """
        初始化 中间节点 需要初始化的对象参数有 ：left_child, right_chiled, weight
        """
        super(IntlNode, self).__init__()
        # 节点的值
        self.wieght = left_child.get_wieght() + right_child.get_wieght()
        # 节点的左右子节点
        self.left_child = left_child
        self.right_child = right_child

    def isleaf(self):
        """
        基类的方法，返回False，代表是中间节点
        """
        return False

    def get_wieght(self):
        """
        基类的方法，返回对象属性 weight，表示对象的权重
        """
        return self.wieght

    def get_left(self):
        """
        获取左孩子
        """
        return self.left_child

    def get_right(self):
        """
        获取右孩子
        """
        return self.right_child


class HuffTree(object):
    """
    huffTree
    """
    def __init__(self, flag, value=0, freq=0, left_tree=None, right_tree=None):
        super(HuffTree, self).__init__()
        if flag == 0:
            self.root = LeafNode(value, freq)
        else:
            self.root = IntlNode(left_tree.get_root(), right_tree.get_root())

    def get_root(self):
        """
        获取huffman tree 的根节点
        """
        return self.root

    def get_wieght(self):
        """
        获取这个huffman树的根节点的权重
        """
        return self.root.get_wieght()

    def traverse_huffman_tree(self, root, code, char_freq):
        """
        利用递归的方法遍历huffman_tree，并且以此方式得到每个 字符 对应的huffman编码
        保存在字典 char_freq中
        """
        if root.isleaf():
            char_freq[root.get_value()] = code
            print("it = %c and freq = %d code = %s") % (chr(root.get_value()), root.get_wieght(), code)
            return None
        else:
            self.traverse_huffman_tree(root.get_left(), code + '0', char_freq)
            self.traverse_huffman_tree(root.get_right(), code + '1', char_freq)


def buildHuffmanTree(list_hufftrees):
    """
    构造huffman树
    """
    while len(list_hufftrees) > 1:
        # 1. 按照weight 对huffman树进行从小到大的排序
        list_hufftrees.sort(key=lambda x: x.get_wieght())
        # 2. 跳出weight 最小的两个huffman编码树
        temp1 = list_hufftrees[0]
        temp2 = list_hufftrees[1]
        list_hufftrees = list_hufftrees[2:]
        # 3. 构造一个新的huffman树
        newed_hufftree = HuffTree(1, 0, 0, temp1, temp2)
        # 4. 放入到数组当中
        list_hufftrees.append(newed_hufftree)
    # last. 数组中最后剩下来的那棵树，就是构造的Huffman编码树
    return list_hufftrees[0]
```

对前文给出的例子，赫夫曼算法的执行过程如下图所示。由于字母表包含6个字母，初始队列大小为$n=6$，需要5个合并步骤构造二叉树。最终的二叉树表示最优前缀码。一个字母的码字为根结点到该字母叶结点的简单路径上边标签的序列。

{% asset_img 3.webp %}

***

### 原文链接

> <https://blog.csdn.net/hy592070616/article/details/122075346>
