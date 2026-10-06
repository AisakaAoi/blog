---
title: 如何精准搜索文献：以知网、Google Scholar、Pubmed为例
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐学术杂谈
abbrlink: 8463a5ef
date: 2026-07-01 10:50:07
tags:
---

很多同学第一次查文献，最常见的动作就是：把论文题目复制下来，直接丢进知网、Google Scholar 或者 PubMed。

比如你的选题是：

```
生成式人工智能对大学生英语写作能力的影响
```

你可能会直接搜：

```
生成式人工智能 大学生 英语写作
```

或者翻译成英文搜：

```
generative AI college students English writing
```

结果往往有三种：

- 搜出来太少，感觉这个方向没人做；
- 搜出来太多，几千篇根本看不完；
- 搜出来很杂，看起来都沾边，但又不太像自己要的文献。

很多人这时候会怀疑：是不是我的选题太偏？是不是这个方向没有研究？是不是数据库不好用？

但很多时候，问题不在这里。

<!--more-->

**真正的问题不是你不会查文献，而是你还没有把“论文选题”翻译成“数据库能听懂的检索语言”。**

今天这篇文章，我就不只讲 AND、OR、NOT 这些检索符是什么意思了。

我们直接用三个数据库实测一遍：

- Google Scholar：适合先找英文文献入口；
- 知网：适合找中文教育、社科、教学改革类文献；
- PubMed：适合医学、生命科学、医学教育类主题。

检索时间为 **2026年7月1日**。需要提醒一句：数据库结果会随着时间、账号、排序规则、学校机构权限变化，尤其知网的可见结果会受登录和校园网影响。所以本文更重要的不是固定某一个数量，而是教大家看懂一套可以复现的检索思路。

<!--more-->

### 01｜别急着搜，先把题目拆成数据库能听懂的话

我们还是用这个选题：

```
生成式人工智能对大学生英语写作能力的影响
```

新手最容易犯的错误，是把这句话当成一个完整关键词。

但数据库不理解“你的论文题目”。数据库理解的是一个个可以匹配的词。

所以第一步不是搜索，而是拆题。

| 研究要素| 中文关键词| 英文关键词|
| ---| ---| ---|
| 核心技术| 生成式人工智能、ChatGPT、大语言模型| generative AI, ChatGPT, large language models|
| 研究对象| 大学生、本科生、高校学生| college students, undergraduates, university students|
| 研究场景| 英语写作、学术英语写作、二语写作| English writing, academic writing, EFL writing, L2 writing|
| 研究结果| 写作能力、写作质量、写作表现| writing ability, writing quality, writing performance|

你会发现，一个选题拆开以后，不再只有一个入口，而是变成了一张关键词地图。

**精准检索的第一步，不是找到一个“最准关键词”，而是先列出一组可能被论文作者使用过的表达。**

这一步非常重要。

因为同一件事，不同作者可能用完全不同的词：

- 有人写 ChatGPT；
- 有人写 generative AI；
- 有人写 large language models；
- 有人写 GenAI；
- 有人写 AI-assisted writing。

如果你只搜其中一个词，就一定会漏文献。

***

### 02｜Google Scholar：先用短检索式找到英文入口

Google Scholar 很适合做第一轮英文检索。

它的优点是覆盖面广，能帮你快速看到一个主题在英文世界里大概有哪些论文、哪些期刊、哪些作者。

但它也有一个特点：**不太适合一上来就写特别复杂的长检索式。**

对小白来说，我更建议先用几条短检索式反复试。

第一轮可以这样搜：

```
"generative AI" "academic writing" "college students"
```

这里的英文双引号表示精确匹配。

更准确地说，它会尽量按完整短语去匹配 `"generative AI"`、`"academic writing"`、`"college students"` 这些表达，而不是只把它们当成几个彼此独立的普通单词。Google Scholar 仍然会按自己的相关度算法排序，所以我们不要把它理解成 Web of Science 那种完全可控的字段检索。

我用这条检索式在 Google Scholar 里实际检索，前面可以看到一些很贴题的结果。

| 代表性结果| 年份| 为什么值得看|
| ---| ---| ---|
| Exploring students' perspectives on Generative AI-assisted academic writing| 2025| 直接讨论学生如何看待生成式 AI 辅助学术写作|
| Students' Perceptions of Generative Artificial Intelligence Use in Academic Writing in English as a Foreign Language| 2025| 关注 EFL 大学生在英语学术写作中使用 GenAI 的看法|
| Writing with AI: What College Students Learned from Utilizing ChatGPT for a Writing Assignment| 2024| 讨论大学生使用 ChatGPT 完成写作任务后的学习收获|

这说明第一条检索式已经能命中比较相关的英文文献。

但是，它还不够全面。

为什么？

因为有些文章可能不用 `"generative AI"`，而是写 `ChatGPT`；有些文章不用 `"college students"`，而是写 `undergraduates`；有些文章不用 `"academic writing"`，而是写 `"EFL writing"`。

所以第二轮，我们要扩展同义词。

这里要注意，Google Scholar 官方帮助中给出的题名检索示例就是把论文题名放进英文双引号；它也提供高级检索窗口，可以按作者、题名、出版物和日期限制结果。但它不像 Web of Science 或 PubMed 那样适合一上来输入很长、很复杂的布尔检索式。

所以对新手来说，我更建议把同义词拆成多条短检索式，而不是把所有 OR 和括号都塞进同一条里。

比如：

```
"generative AI" "academic writing" "college students"
```

```
ChatGPT "EFL writing" undergraduates
```

```
"large language models" "academic writing" "university students"
```

如果你想用 Google Scholar 的高级检索，也可以把 `"academic writing"` 放到“精确短语”，把 `ChatGPT`、`GenAI`、`AI-assisted writing` 这类替代表达放到“至少包含其中一个词”，再按年份筛选。像 `"large language models"` 这种固定短语，建议另外单独做一条带引号的短检索式。这样比手写一条很长的公式更稳。

这样做看起来麻烦一点，但很适合新手。

因为你不是在盲目翻页，而是在观察：这个领域的作者到底喜欢用哪些词。

**Google Scholar 的第一轮任务，不是马上找到全部文献，而是帮你找到英文关键词的入口。**

***

### 03｜知网：中文选题先用主题，再用题名收窄

如果你的选题是教育、外语、新闻传播、管理、文学、社会科学，知网仍然非常重要。

尤其是中文语境很强的主题，比如“大学英语写作教学”“课程思政”“高校教师数字素养”“新文科背景下的教学改革”，只搜 Google Scholar 很容易漏掉中文研究。

还是这个主题：

```
生成式人工智能对大学生英语写作能力的影响
```

小白第一轮可以先搜：

```
生成式人工智能 英语写作
```

这一步是为了看这个中文主题有没有研究热度。

但如果结果太杂，就要开始加限制。

比如你只关心大学场景，在知网“高级检索”里可以这样填：

```
主题：生成式人工智能
并且
主题：大学英语写作
```

如果你更关心 ChatGPT，可以这样填：

```
篇名：ChatGPT
并且
主题：英语写作
并且
主题：大学生
```

如果你切换到知网“专业检索”，更规范的字段码写法是：

```
SU %= 生成式人工智能 AND SU %= 大学英语写作
```

或者：

```
TI = ChatGPT AND SU %= 英语写作 AND SU %= 大学生
```

这里的 `SU` 是主题，`TI` 是题名。知网 KNS8 使用手册里建议主题检索使用相关匹配运算符 `%=`，所以不要简单照搬成 `主题 = xxx`。

这里有两个小技巧。

第一，**主题检索适合找得全**。知网的主题字段不是简单等同于标题或关键词，而是平台标引出的主题字段，会结合专业词典、主题词表、中英对照词典等机制。

第二，**题名检索适合找得准**。如果一篇文章题名里就出现了 ChatGPT 和英语写作，通常说明它和你的主题关系更直接。

我实际检索时，能看到这些比较相关的中文结果。

| 代表性结果| 来源| 为什么值得看|
| ---| ---| ---|
| 生成式人工智能在大学英语教学改革中的应用探究——以“通用学术英语写作”课程教学改革实践为例| 外语教育研究前沿，2024| 直接对应“生成式人工智能 + 大学英语 + 学术英语写作”|
| ChatGPT 辅助大学生英语写作中心流体验、自我效能感与学业浮力的作用机制研究| 西安外国语大学学报，2025年第3期| 直接对应“ChatGPT + 大学生 + 英语写作”|
| 生成式人工智能英语写作反馈的模型差异与提示词调节作用研究| 外语研究，2026年第1期| 适合继续追“AI 写作反馈”和“提示词”方向|
| 生成式人工智能何以赋能教学——中学生英语写作教学实证研究| 中国电化教育，2025| 结果相关，但对象是中学生，可作为“排除词”示例|

最后一条很有意思。

它和“生成式人工智能”“英语写作”都相关，但研究对象是中学生。如果你的论文明确写的是大学生，这类文献就不一定是核心文献。

所以我们可以继续收窄：

```
高级检索：
主题：生成式人工智能
并且 主题：英语写作
并且 主题：大学生
```

如果用专业检索，可以写成：

```
SU %= 生成式人工智能 AND SU %= 英语写作 AND SU %= 大学生
```

或者把不想要的对象排除掉：

```
SU %= 生成式人工智能 AND SU %= 英语写作 AND SU %= 大学生 NOT SU %= 中学
```

在高级检索界面里，对应操作就是把不想要的对象放进“不含”条件，例如“不含：中学 / 高中 / 小学”。

不过我建议大家不要一开始就疯狂排除。

因为有时候一篇大学英语写作论文的摘要里，可能会顺手提到“中小学英语教学”，如果你排除得太狠，也可能误伤有用文献。

**知网检索的重点，是先用主题找全，再用题名、研究对象、来源类别和年份慢慢收窄。**

***

### 04｜PubMed：医学主题建议使用字段标签

PubMed 和 Google Scholar、知网又不太一样。

它主要面向医学、生命科学、公共卫生、护理、药学等领域。直接输入关键词也能检索，但如果你想让检索过程更可复现，就很适合使用字段限定。

我们换一个医学教育主题：

```
ChatGPT / 大语言模型在医学教育中的应用
```

如果直接搜：

```
ChatGPT medical education
```

当然也能搜到结果。

但更可复现的写法是：

```
("large language models"[Title/Abstract] OR ChatGPT[Title/Abstract])
AND
("medical education"[Title/Abstract] OR "health professions education"[Title/Abstract])
```

这里的 `[Title/Abstract]` 是 PubMed 里的字段标签。严格说，它检索的是题名、摘要、其他摘要和作者关键词等信息，比全库乱搜更集中。

为什么要这样写？

因为如果一个词只出现在参考文献、机构信息或者其他边缘位置，它不一定真的和文章主题有关。把范围限定在题名、摘要和作者关键词这一类核心信息里，结果通常会更精准。

我用 PubMed 官方接口在 2026年7月1日检索，这条检索式返回 **1332 条结果**。前面能看到这些代表性文献：

| 代表性结果| PMID| 为什么值得看|
| ---| ---| ---|
| Medical Student Experiences and Perceptions of ChatGPT and Artificial Intelligence| 38133911| 直接调查医学生对 ChatGPT 和 AI 的体验与看法|
| Performance of ChatGPT on USMLE: Potential for AI-assisted medical education using large language models| 36812645| 讨论 ChatGPT 在医学考试任务中的表现|
| Opportunities, challenges, and future directions of large language models, including ChatGPT in medical education| 38486402| 医学教育中 LLM 应用的范围综述|
| Large Language Models in Medical Education: Opportunities, Challenges, and Future Directions| 37261894| 适合作为主题背景文献|

这组结果说明，PubMed 非常适合用“字段 + 同义词 + 主题限定”的方式检索。

比如：

- OR 用来放同义词：ChatGPT / large language models；
- AND 用来叠加主题：LLM + medical education；
- [Title/Abstract] 用来提高相关性。

如果结果还是太多，可以继续加限定词。

比如你只关心医学生，可以加：

```
AND
("medical students"[Title/Abstract] OR "undergraduate medical education"[Title/Abstract])
```

如果你只关心综述，可以加：

```
AND
(review[pt] OR "systematic review"[pt] OR "systematic review"[Title/Abstract])
```

这里的 `[pt]` 是 PubMed 的 Publication Type 字段标签。用这条限定加到上面的主检索式里，我在 2026年7月1日通过 PubMed 官方接口检索到 **180 条结果**。

如果你只关心近几年，可以直接在 PubMed 页面左侧筛选年份。

**PubMed 的好处是规范，坏处是不能太随意。字段标签写得越清楚，结果越可控。**

***

### 05｜结果太多或太少时，到底该怎么调？

新手查文献最痛苦的地方，不是不会点搜索按钮，而是不知道搜出来以后该怎么办。

我给大家一个很实用的判断表。

| 遇到的问题| 应该怎么调| 例子|
| ---| ---| ---|
| 结果太少| 用 OR 增加同义词| ChatGPT OR generative AI OR large language models|
| 结果太多| 用 AND 增加限定概念| AND academic writing AND college students|
| 结果太杂| 加排除词或“不含”条件| NOT primary school / 不含：中学|
| 结果太泛| 把关键词放到题名字段| 知网专业检索：TI = ChatGPT|
| 结果太旧| 限定年份| 2020-2026|
| 想找高质量综述| 加 review 或 systematic review| "systematic review"|
| 想找中文核心研究| 限定来源类别| CSSCI、北大核心、核心期刊|

这里要记住一个原则：

**OR 是扩检，AND 是缩检，NOT 是去杂，字段限定是提纯。**

如果你搜不到，不要急着换选题，先问自己：

- 我有没有列同义词？
- 我有没有把中文词翻译成英文表达？
- 我有没有把研究对象写进去？
- 我有没有把题名、摘要、主题字段分清楚？
- 我是不是一开始就排除得太狠？

很多时候，文献不是不存在，而是你还没有用它会出现的方式去找它。

***

### 06｜三个数据库放在一起看，差异就很清楚了

同样是检索文献，不同数据库的“脾气”是不一样的。

| 数据库| 最适合做什么| 推荐检索方式| 新手要注意什么|
| ---| ---| ---| ---|
| Google Scholar| 找英文入口、经典文献、引用线索| 多条短检索式 + 精确短语| 不要迷信一条超长检索式|
| 知网| 找中文社科、教育、教学改革文献| 主题检索找全，题名检索找准| 结果受机构权限和筛选条件影响|
| PubMed| 找医学、生命科学、公共卫生文献| 字段标签 + 题名摘要限定，必要时再加 MeSH| `[Title/Abstract]` 很重要|

如果你是刚开始做选题，我建议顺序是这样：

第一步，用 Google Scholar 找英文关键词和代表性论文；

第二步，用知网找中文语境里的研究现状；

第三步，如果是医学、生命科学、公共卫生方向，再用 PubMed 做更规范的医学检索；

第四步，把检索式和筛选条件记录下来，方便后面写综述方法或开题报告。

这一步很多同学会忽略。

但我强烈建议大家养成一个习惯：**每一次检索都要记录检索式、数据库、日期和筛选条件。**

比如：

| 数据库| 检索式| 时间| 筛选条件|
| ---| ---| ---| ---|
| Google Scholar| `"generative AI" "academic writing" "college students"`| 2026-07-01| 按相关性排序|
| 知网| `SU %= 生成式人工智能 AND SU %= 大学英语写作`| 2026-07-01| 专业检索；学术期刊，近五年|
| PubMed| `("large language models"[Title/Abstract] OR ChatGPT[Title/Abstract]) AND ("medical education"[Title/Abstract] OR "health professions education"[Title/Abstract])`| 2026-07-01| Title/Abstract|

这样做有两个好处。

第一，你不会反复从零开始。

第二，当导师问你“这些文献是怎么找来的”，你能说清楚。

***

### 07｜给小白的可复制检索模板

如果你暂时不知道怎么写检索式，可以先套这个模板。

中文数据库模板：

```
(核心概念 OR 同义词)
AND
(研究对象 OR 近义表达)
AND
(研究场景 OR 应用领域)
NOT
(明显无关对象)
```

写到知网里，可以拆成高级检索条件：

```
主题：生成式人工智能
并且 主题：英语写作
并且 主题：大学生
不含：中学 / 高中 / 小学
```

如果用知网专业检索，可以写成：

```
SU %= 生成式人工智能 AND SU %= 英语写作 AND SU %= 大学生 NOT SU %= 中学
```

Google Scholar 模板：

```
"核心短语" "研究场景" "研究对象"
```

比如：

```
"generative AI" "academic writing" "college students"
```

再换一组同义词：

```
ChatGPT "EFL writing" undergraduates
```

PubMed 模板：

```
("concept A"[Title/Abstract] OR "synonym A"[Title/Abstract])
AND
("concept B"[Title/Abstract] OR "synonym B"[Title/Abstract])
AND
("population C"[Title/Abstract] OR "population synonym"[Title/Abstract])
```

比如：

```
("large language models"[Title/Abstract] OR ChatGPT[Title/Abstract])
AND
("medical education"[Title/Abstract] OR "health professions education"[Title/Abstract])
```

这就是一条比较规范的 PubMed 检索式。

***

### 08｜AI 可以帮你写检索式，但不要让它替你编文献

最后再说一个很现实的问题。

现在很多同学会直接问 AI：

```
请给我推荐20篇关于生成式人工智能与大学生英语写作的真实论文。
```

这个问法有风险。

因为通用 AI 可能会给你一些看起来很像真的文献，但里面可能有题名错误、作者错误、年份错误，甚至根本不存在。

更好的问法是：

```
请把“生成式人工智能对大学生英语写作能力的影响”拆成概念矩阵，
分别列出中文关键词、英文关键词、同义词、排除词，
并生成适用于 Google Scholar、知网和 PubMed 的检索式。
不要编造文献，只生成检索策略。
```

这时候 AI 做的不是替你“找结论”，而是帮你完成检索前的准备工作：

- 拆概念；
- 扩同义词；
- 翻译关键词；
- 生成不同数据库的检索式；
- 提醒可能的排除词。

之后，你再把检索式放到真实数据库里验证。

**AI 的价值不是替你编参考文献，而是帮你把一个模糊选题，变成一组可验证、可复现的检索路径。**

这才是比较稳妥的用法。

***

### 写在最后

如果结果太少，就用 OR 增加同义词；

如果结果太多，就用 AND 增加限定条件；

如果结果太杂，就用 NOT 或“不含”排除明显跑偏的内容；

如果结果不够准，就用题名、摘要、主题这些字段把范围收紧。

最后记住一句话：

**不要把论文题目直接丢给数据库。先把你的选题，翻译成数据库能理解的语言。**

这一步做好了，后面的开题、综述、论文写作，都会轻松很多。

### 原文链接

> <https://mp.weixin.qq.com/s/NrZy_MqqsE4NP6ToN7OrQw>
