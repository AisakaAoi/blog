---
title: JavaScript-异步编程：一次性搞懂Callback、Promise、async、await
categories:
  - 🌙基础学习
  - ⭐JavaScript
abbrlink: 8ad76204
date: 2021-10-09 10:59:15
tags:
---

### 引言

异步编程允许我们在执行一个长时间任务时，程序不需要进行等待，而是继续执行之后的代码，直到这些任务完成之后再回来通知你，通常是以回调函数（callback）的形式。

{% asset_img 1.png %}

``` javascript
getUserPost(function(userPost) {
    console.log(userPost);
});
```

<!--more-->

这种编程模式避免了程序的阻塞，大大提高了CPU的执行效率，尤其适用于IO密集的操作，例如需要经常进行网络操作、数据库访问的应用。

{% asset_img 2.png %}

本文将以JavaScript为例介绍异步编程的概念，Promise以及新标准中更优雅的async、await语法糖。

本文中讲到的所有概念也同样适用于其它的编程语言，比如Python、Golang、Rust、Java、C#等等，它们也全都提供异步编程的支持。

如果还不是特别清楚并发、并行、异步、同步的概念，请看之后的blog（可能会写）。

{% asset_img 3.png %}

***

### Callback 与 Promise

#### Callback

我们知道在JavaScript中有两种实现异步的方式，首先第一种是传统的回调函数（Callback Function），比如我们可以使用setTimeout()让一个函数在指定的时间后执行。

这个函数本身会立刻返回，程序会紧接着执行之后的代码，而我们传入的回调函数则会等到预定的时间才会执行。

``` javascript
// () => {} 是箭头表达式，相当于函数定义的简化写法
setTimeout(() => {
    console.log('三秒后才看见这句话！');
}, 3000);

console.log('你会马上看见这句话！');
```

需要注意的是JavaScript从设计之初就是一个单线程的编程语言，即便看上去这里的回调函数和主程序在并发执行，但它们都运行在同一个主线程中。实际上主线程中还运行了我们写的其它代码，包括界面逻辑、网络请求、数据处理等等。

{% asset_img 4.png %}

虽然只有单个线程在执行，但这种单线程的异步编程方式其实有诸多优点，由于所有操作都运行在同一个线程中，因此我们无需考虑线程同步或者资源竞争的问题。

{% asset_img 5.png %}

并且从源头上避免了线程之间的频繁切换，从而降低了线程自身的开销。

{% asset_img 6.png %}

回调函数虽然简单好理解，但它有一个明显的缺点，如果我们需要依次执行多个异步操作，我们的程序可能会写成这样：

``` javascript
setTimeout(() => {
    console.log('先等三秒');

    setTimeout(() => {
        console.log('再等三秒');

        setTimeout(() => {
            console.log('最后等三秒');

            // ...
        }, 3000);
    }, 3000);
}, 3000);
```

一层一层的嵌套，可读性会变得非常差，这种情况也被叫做函数的“回调地狱”（Callback Hell）。

#### Promise

为了解决这个问题，Promise应运而生。而JavaScript中使用Promise的API：fetch()就是一个很好的例子。

``` javascript
fetch('http://...')
```

它用来发起一个请求来获取服务器数据，我们可以用它动态更新页面的内容，也就是我们平时说的Ajax技术（Asynchronous JavaScript and XML）

{% asset_img 7.png %}

例如我们调用fetch()去获取一个测试地址的数据，可以看到fetch()立刻返回了一个Promise对象，这里的promise几乎就是它的字面意思，promise->承诺，“承诺”这个请求会在未来某个时刻返回数据。

{% asset_img 8.png %}

{% asset_img 9.png %}

我们随后可以调用它的then方法并传递一个回调函数，如果这个请求在未来成功完成，那么回调函数会被调起，请求的结果也会以参数的形式传递进来。

``` javascript
fetch('https://jsonplaceholder.typicode.com/posts/1')
    .then((response) => {
        // ...
    });
```

当然如果光是这样，Promise和回调函数就没有什么区别了。其实Promise的优点在于它可以用一种链式结构将多个异步操作串联起来（Chaining，链式调用）。

比如下文的response.json()方法也会返回一个Promise，它代表在未来的某个时刻，将返回的数据转换成JSON格式。

如果我们想要等到它完成之后再执行其它的操作，我们可以在后面追加一个then，然后执行接下来的代码，比如将结果打印出来：

``` javascript
fetch('https://jsonplaceholder.typicode.com/posts/1')
    .then((response) => response.json())
    .then((json) => console.log(json));
```

{% asset_img 10.png %}

Promise的链式调用避免了代码的层层嵌套，即便是我们有一个很长的链，代码也不过是向下方增长而并非向右，因此可读性会提升很多。

{% asset_img 11.png %}

在使用异步操作的时候，我们也可能遇到错误，比如各种网络问题或者返回的数据格式不正确。

{% asset_img 12.png %}

如果我们想要捕获这些错误，最简单的方法是附加一个catch在链式结构的末尾，如果之前任意一个阶段发生了错误，那么catch将会被触发，而之后的then()将不会执行。这和同步编程中用到的try/catch块很类似。

类似的Promise还提供finally方法，它会在Promise链结束之后调用，无论前面失败与否。我们可以在这里做一些清理工作，比如如果我们用到了加载动画，则可以在finally中关闭它。

``` javascript
fetch('https://jsonplaceholder.typicode.com/posts/1')
    .then((response) => response.json())
    .then((json) => {
        console.log(json)
    })
    .catch((error) => {
        console.error(error)
    })
    .finally(() => {
        stopLoadingAnimation();
    });
```

***

### async、await

新标准ECMA17中加入的两个关键字async、await，简单来说它们是基于Promise之上的一个语法糖，可以让异步操作更加的简洁明了。

首先我们需要使用async关键字将函数标记为异步函数，异步函数就是指返回值为Promise对象的函数，比如之前用到的fetch()就是一个异步函数。

在异步函数中我们可以调用其它的异步函数，不过我们不再需要使用then()，而是使用一个更加简洁的await语法。await会等待Promise完成之后直接返回最终的结果，所以这里的response已经是服务器返回的响应数据了。

await虽然看上去会暂停函数的执行，但在等待的过程中JavaScript同样可以处理其它的任务，比如更新界面、运行其它程序代码等等。这是因为await底层是基于Promise和事件循环机制实现的。

``` javascript
async function f() {
    const response = await fetch('http://...');
    const json = await response.json();
    console.log(json);
}

f();    // 这个函数返回值永远都是Promise对象
```

最后我们在使用await的时候，需要留意以下的这几个陷阱：

- 陷阱1

如果我们分别去await这两个异步操作，虽然不存在逻辑错误，但这样写会打破这两个fetch()操作的并行，因为我们会等到第一个任务执行完成之后才开始执行第二个任务。

``` javascript
async function f() {
    const a = await fetch('http://.../post/1');
    const b = await fetch('http://.../post/2');
    
    // ...
}
```

这里更高效的做法是将所有Promise用Promise.all结合起来，然后再去await。

``` javascript
async function f() {
    const promiseA = fetch('http://.../post/1');
    const promiseB = fetch('http://.../post/2');
    
    const [a, b] = await Promise.all([promiseA, promiseB]);
    // ...
}
```

- 陷阱2

如果我们需要在循环中执行异步操作，是不能够直接调用forEach或者map这一类方法的。尽管我们在回调函数中写了await，但这里的forEach会立刻返回，它并不会暂停等到所有异步操作都执行完毕。

``` javascript
async function f() {
    [1, 2, 3].forEach(async (i) => {
        await someAsyncOperation();
    })

    console.log('done');
}
```

如果我们希望等待循环中的异步操作都一一完成之后才继续执行，那我们还是应当使用传统的for循环。

``` javascript
async function f() {
    for (let i of [1, 2, 3]) {
        await someAsyncOperation();
    })

    console.log('done');
}
```

更进一步，如果我们想要循环中的所有操作都并发执行，一种更炫酷的写法是使用for await，这里的for循环依然会等到所有的异步操作都完成之后才继续向后执行。

``` javascript
async function f() {
    const promises = [
        someAsyncOperation(),
        someAsyncOperation(),
        someAsyncOperation(),
    ];

    for await (let result of promises) {
        // ...
    }

    console.log('done');
}
```

- 陷阱3

我们不能在全局或者普通函数中直接使用await关键字，await只能被用在异步函数（async function）中。如果我们想在最外层中使用await，那么需要先定义一个异步函数，然后在函数体中使用它。（听说ES2022可以直接用了）

``` javascript
async function f() {
    await someAsyncOperation();
}

// 更简洁的写法
(async () => {
    await someAsyncOperation();
})();
```

***

### 总结

使用async和await可以让我们写出更清晰、更容易理解的异步代码，有了它们之后，我们几乎不再需要使用底层的Promise对象，包括调用它的then()、catch()函数等等。

即便是对于某些旧版本的浏览器，它们不支持async语法，我们还是可以使用转译器（Transpiler）将它们编译成旧版本也兼容的等效代码。

***

### 参考与鸣谢

> <https://www.bilibili.com/video/BV1WP4y187Tu>
