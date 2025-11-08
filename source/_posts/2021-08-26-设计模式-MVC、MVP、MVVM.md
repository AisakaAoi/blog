---
title: 设计模式-MVC、MVP、MVVM
categories:
  - 🌙大学课程
abbrlink: c28ee0e2
date: 2021-08-26 17:49:18
tags:
---

### MVC

MVC（模型(model)--视图(view)--控制器(controller)）

Model层处理数据，业务逻辑等；View层处理界面的显示结果；Controller层起到桥梁的作用，来控制View层和Model层通信以此来达到分离视图显示和业务逻辑层。

#### 关键点

View是把控制权交移给Controller，自己不执行业务逻辑。

Controller执行业务逻辑并且操作Model，但不会直接操作View，可以说它是对View无感知的。

View和Model的同步消息是通过观察者模式进行，而同步操作是由View自己请求Model的数据然后对视图进行更新。

我们往往把Android中界面部分的实现也理解为采用了MVC框架，常常把Activity理解为MVC模式中的Controller。

<!--more-->

{% asset_img 1.webp %}

{% asset_img 2.webp %}

#### 优点

1. 把业务逻辑全部分离到Controller中，模块化程度高。当业务逻辑变更的时候，不需要变更View和Model，只需要Controller 换成另外一个Controller就行了（Swappable Controller）。

2. 观察者模式可以做到多视图同时更新。

#### 缺点

1. Controller测试困难。因为视图同步操作是由View自己执行，而View只能在有UI的环境下运行。在没有UI环境下对Controller进行单元测试的时候， Controller业务逻辑的正确性是无法验证的：Controller更新Model的时候，无法对View的更新操作进行断言。

2. View无法组件化。View强依赖特定的Model，不同程序的Domain Model是不一样的，如果需要把这个View抽出来作为一个另外一个应用程序可复用的组件就困难了。

### MVP

MVP其实是MVC的一种演进版本，它更简单，将MVC中的Controller改为了Presenter，View通过接口与Presenter进行交互，降低耦合，方便进行单元测试。

View：负责绘制UI元素、与用户进行交互(Activity、View、Fragment都可以做为View层)

Model：对数据的操作、对网络等的操作，和业务相关的逻辑处理

Presenter：作为View与Model交互的中间纽带，处理与用户交互的逻辑。可以把Presenter理解为一个中间层的角色，它接受Model层的数据，并且处理之后传递给View层，还需要处理View层的用户交互等操作。

#### 关键点

View不再负责同步的逻辑，而是由Presenter负责。Presenter中既有业务逻辑也有同步逻辑。

View需要提供操作界面的接口给Presenter进行调用。

对比在MVC中，Controller是不能操作View的，View也没有提供相应的接口；而在MVP当中，Presenter可以操作View，View需要提供一组对界面操作的接口给Presenter进行调用；Model仍然通过事件广播自己的变更，但由Presenter监听而不是View。

{% asset_img 3.webp %}

{% asset_img 4.webp %}

#### 优点

1. 便于测试。Presenter对View是通过接口进行，在对Presenter进行不依赖UI环境的单元测试的时候。可以通过Mock一个View对象，这个对象只需要实现了View的接口即可。然后依赖注入到Presenter中，单元测试的时候就可以完整的测试Presenter业务逻辑的正确性。

2. View可以进行组件化。在MVP当中，View不依赖Model。这样就可以让View从特定的业务场景中脱离出来，可以说View可以做到对业务逻辑完全无感知。它只需要提供一系列接口提供给上层操作。这样就可以做高度可复用的View组件。

#### 缺点

1. UI更新麻烦。Presenter中除了业务逻辑以外，还有大量的View->Model，Model->View的手动同步逻辑，造成Presenter比较笨重，维护起来会比较困难。

### MVVM

MVVM（Model--View--ViewModel）

和MVP模式相比，MVVM 模式用ViewModel替换了Presenter ，其他层基本上与 MVP 模式一致，ViewModel可以理解成是View的数据模型和Presenter的合体。

MVVM采用双向绑定（data-binding）：View的变动，自动反映在ViewModel，反之亦然，这种模式实际上是框架替应用开发者做了一些工作（相当于ViewModel类是由库帮我们生成的），开发者只需要较少的代码就能实现比较复杂的交互。

#### 关键点

MVVM把View和Model的同步逻辑自动化了。以前Presenter负责的View和Model同步不再手动地进行操作，而是交由框架所提供的Binder进行负责，只需要告诉Binder，View显示的数据对应的是Model哪一部分即可。

{% asset_img 5.webp %}

#### 优点

1. 提高可维护性。解决了MVP大量的手动View和Model同步的问题，提供双向绑定机制。提高了代码的可维护性。

2. 简化测试。因为同步逻辑是交由Binder做的，View跟着Model同时变更，所以只需要保证Model的正确性，View就正确。大大减少了对View同步更新的测试。

#### 缺点

1. 对于过于简单的图形界面不适用。

2. 对于大型的图形应用程序，视图状态较多，ViewModel的构建和维护的成本都会比较高。

3. 数据绑定的声明是指令式地写在View的模版当中的，这些内容是没办法去打断点debug的。
