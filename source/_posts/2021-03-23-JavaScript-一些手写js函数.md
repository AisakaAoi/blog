---
title: JavaScript-一些手写js函数
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: 67f3b903
date: 2021-03-23 05:07:56
tags:
---

## 手写instanceof

### instanceof作用

判断一个实例是否是其父类或者祖先类型的实例。

instanceof 在查找的过程中会遍历左边变量的原型链，直到找到右边变量的 prototype 查找失败，返回 false

``` javascript
let myInstanceof = (target,origin) => {
   while (target) {
      if (target.__proto__ === origin.prototype) {
         return true
      }
      target = target.__proto__
   }
   return false
}
let a = [1,2,3]
console.log(myInstanceof(a, Array));  // true
console.log(myInstanceof(a, Object));  // true
```

<!--more-->

***

## 实现数组的map方法

``` javascript
Array.prototype.myMap = (fn, thisValue) => {
   let res = []
   thisValue = thisValue || []
   let arr = this
   for (let i in arr) {
      res.push(fn(arr[i]))
   }
   return res
}
```

***

## reduce实现数组的map方法

``` javascript
Array.prototype.myMap = (fn,thisValue) => {
   var res = [];
   thisValue = thisValue||[];
   this.reduce(function(pre, cur, index, arr){
      return res.push(fn.call(thisValue, cur, index, arr));
   },[]);
   return res;
}

var arr = [2,3,1,5];
arr.myMap((item, index, arr) => {
   console.log(item, index, arr);
})
```

***

## 手写数组的reduce方法

reduce() 方法接收一个函数作为累加器，数组中的每个值（从左到右）开始缩减，最终为一个值，是ES5中新增的又一个数组逐项处理方法

### 参数

- callback（一个在数组中每一项上调用的函数，接受四个函数：）
- previousValue（上一次调用回调函数时的返回值，或者初始值）
- currentValue（当前正在处理的数组元素）
- currentIndex（当前正在处理的数组元素下标）
- array（调用reduce()方法的数组）
- initialValue（可选的初始值。作为第一次调用回调函数时传给previousValue的值）

``` javascript
function reduce(arr, cb, initialValue) {
   var num = initValue == undefined ? num = arr[0] : initValue;
   var i = initValue == undefined ? 1 : 0
   for (i; i < arr.length; i++) {
      num = cb(num, arr[i], i)
   }
   return num
}
 
function fn(result, currentValue, index) {
   return result + currentValue
}
 
var arr = [2,3,4,5]
var b = reduce(arr, fn, 10) 
var c = reduce(arr, fn)
console.log(b)   // 24
```

***

## 数组扁平化

数组扁平化就是把多维数组转化成一维数组

1. es6提供的新方法 flat(depth)

   ``` javascript
   let a = [1, [2, 3]]; 
   a.flat();   // [1,2,3] 
   a.flat(1);  // [1,2,3]
   ```

   其实还有一种更简单的办法，无需知道数组的维度，直接将目标数组变成1维数组。depth的值设置为Infinity

   ``` javascript
   let a = [1, [2, 3, [4, [5]]]]; 
   a.flat(Infinity); // [1,2,3,4,5]  a是4维数组
   ```

2. 利用cancat

   ``` javascript
   var arr1 = [1, 2, 3, [1, 2, 3, 4, [2, 3, 4]]];
   function flatten(arr) {
      var res = [];
      for (let i = 0, length = arr.length; i < length; i++) {
         if (Array.isArray(arr[i])) {
            res = res.concat(flatten(arr[i])); // concat 并不会改变原数组
            // res.push(...flatten(arr[i])); //扩展运算符 
         } else {
            res.push(arr[i]);
         }
      }
      return res;
   }
   flatten(arr1); // [1, 2, 3, 1, 2, 3, 4, 2, 3, 4]
   ```

***

## 函数柯里化

柯里化的定义：接收一部分参数，返回一个函数接收剩余参数，接收足够参数后，执行原函数。

当柯里化函数接收到足够参数后，就会执行原函数，如何去确定何时达到足够的参数呢？

有两种思路：

1.通过函数的 length 属性，获取函数的形参个数，形参的个数就是所需的参数个数

2.在调用柯里化工具函数时，手动指定所需的参数个数

将这两点结合一下，实现一个简单 curry 函数：

``` javascript
/**
 * 将函数柯里化
 * @param fn    待柯里化的原函数
 * @param len   所需的参数个数，默认为原函数的形参个数
 */
function curry(fn, len = fn.length) {
   return _curry.call(this, fn, len)
}

/**
 * 中转函数
 * @param fn    待柯里化的原函数
 * @param len   所需的参数个数
 * @param args  已接收的参数列表
 */
function _curry(fn, len, ...args) {
   return function (...params) {
      let _args = [...args, ...params];
      if (_args.length >= len) {
         return fn.apply(this, _args);
      } else {
         return _curry.call(this, fn, len, ..._args)
      }
   }
}
```

我们来验证一下：

``` javascript
let _fn = curry(function(a, b, c, d, e){
   console.log(a, b, c, d, e)
});

_fn(1, 2, 3, 4, 5);     // print: 1,2,3,4,5
_fn(1)(2)(3, 4, 5);     // print: 1,2,3,4,5
_fn(1, 2)(3, 4)(5);     // print: 1,2,3,4,5
_fn(1)(2)(3)(4)(5);     // print: 1,2,3,4,5
```

我们常用的工具库 lodash 也提供了 curry 方法，并且增加了非常好玩的 placeholder 功能，通过占位符的方式来改变传入参数的顺序。

比如说，我们传入一个占位符，本次调用传递的参数略过占位符， 占位符所在的位置由下次调用的参数来填充，比如这样：

直接看一下官网的例子：

``` javascript
var abc = function(a, b, c) {
   return [a, b, c];
};

var curried = _.curry(abc);

curried(1)(2)(3);
// => [1, 2, 3]

curried(1, 2)(3);
// => [1, 2, 3]

curried(1, 2, 3);
// => [1, 2, 3]

// Curried with placeholders.
curried(1)(_, 3)(2);
// => [1, 2, 3]
```

接下来我们来思考，如何实现占位符的功能。

对于 lodash 的 curry 函数来说，curry 函数挂载在 lodash 对象上，所以将 lodash 对象当做默认占位符来使用。

而我们的自己实现的 curry 函数，本身并没有挂载在任何对象上，所以将 curry 函数当做默认占位符

使用占位符，目的是改变参数传递的顺序，所以在 curry 函数实现中，每次需要记录是否使用了占位符，并且记录占位符所代表的参数位置。

直接上代码：

``` javascript
/**
 * @param  fn           待柯里化的函数
 * @param  length       需要的参数个数，默认为函数的形参个数
 * @param  holder       占位符，默认当前柯里化函数
 * @return {Function}   柯里化后的函数
 */
function curry(fn, length = fn.length, holder = curry) {
   return _curry.call(this, fn, length, holder, [], [])
}
/**
 * 中转函数
 * @param fn            柯里化的原函数
 * @param length        原函数需要的参数个数
 * @param holder        接收的占位符
 * @param args          已接收的参数列表
 * @param holders       已接收的占位符位置列表
 * @return {Function}   继续柯里化的函数 或 最终结果
 */
function _curry(fn, length, holder, args, holders) {
   return function(..._args) {
      // 将参数复制一份，避免多次操作同一函数导致参数混乱
      let params = args.slice();
      // 将占位符位置列表复制一份，新增加的占位符增加至此
      let _holders = holders.slice();
      // 循环入参，追加参数 或 替换占位符
      _args.forEach((arg,i) => {
      // 真实参数 之前存在占位符 将占位符替换为真实参数
         if (arg !== holder && holders.length) {
            let index = holders.shift();
            _holders.splice(_holders.indexOf(index), 1);
            params[index] = arg;
         }
         // 真实参数 之前不存在占位符 将参数追加到参数列表中
         else if(arg !== holder && !holders.length) {
            params.push(arg);
         }
         // 传入的是占位符,之前不存在占位符 记录占位符的位置
         else if(arg === holder && !holders.length) {
            params.push(arg);
            _holders.push(params.length - 1);
         }
         // 传入的是占位符,之前存在占位符 删除原占位符位置
         else if(arg === holder && holders.length) {
            holders.shift();
         }
      });
      // params 中前 length 条记录中不包含占位符，执行函数
      if (params.length >= length && params.slice(0, length).every(i => i !== holder)) {
         return fn.apply(this, params);
      } else {
         return _curry.call(this, fn, length, holder, params, _holders)
      }
   }
}
```

验证一下：

``` javascript
let fn = function(a, b, c, d, e) {
   console.log([a, b, c, d, e]);
}

let _ = {}; // 定义占位符
let _fn = curry(fn, 5, _);  // 将函数柯里化，指定所需的参数个数，指定所需的占位符

_fn(1, 2, 3, 4, 5);                 // print: 1,2,3,4,5
_fn(_, 2, 3, 4, 5)(1);              // print: 1,2,3,4,5
_fn(1, _, 3, 4, 5)(2);              // print: 1,2,3,4,5
_fn(1, _, 3)(_, 4,_)(2)(5);         // print: 1,2,3,4,5
_fn(1, _, _, 4)(_, 3)(2)(5);        // print: 1,2,3,4,5
_fn(_, 2)(_, _, 4)(1)(3)(5);        // print: 1,2,3,4,5
```

至此，我们已经完整实现了一个 curry 函数

***

## 实现深拷贝

**浅拷贝和深拷贝的区别：**

浅拷贝：只拷贝一层，更深层的对象级别的只拷贝引用

深拷贝：拷贝多层，每一级别的数据都会拷贝。这样更改拷贝值就不影响另外的对象

ES6浅拷贝方法：Object.assign(target, ...sources)

``` javascript
let obj = {
   id: 1,
   name: 'Tom',
   msg: {
      age: 18
   }
}
let o = {}
// 实现深拷贝 递归 可以用于生命游戏那个题对二维数组的拷贝
// 但比较麻烦，因为已知元素都是值，直接复制就行，无需判断
function deepCopy(newObj, oldObj) {
   for(let k in oldObj) {
      let item = oldObj[k]
      //判断是数组？对象？简单类型？
      if (item instanceof Array) {
         newObj[k] = []
         deepCopy(newObj[k], item)
      } else if (item instanceof Object) {
         newObj[k] = {}
         deepCopy(newObj[k], item)
      } else {
         //简单数据类型，直接赋值
         newObj[k] = item
      }
   }
}
```

***

## 手写call, apply, bind

手写call

``` javascript
Function.prototype.myCall = function(context = window) {    // 函数的方法，所以写在Fuction原型对象上
   // 这里if其实没必要，会自动抛出错误
   if (typeof this !== "function") {
      throw new Error("不是函数")
   }
   // 这里可用ES6方法，为参数添加默认值，js严格模式全局作用域this为undefined
   const obj = context || window
   // this为调用的上下文,this此处为函数，将这个函数作为obj的方法
   obj.fn = this
   // 第一个为obj所以删除,伪数组转为数组
   const arg = [...arguments].slice(1)
   res = obj.fn(...arg)
   // 不删除会导致context属性越来越多
   delete obj.fn
   return res
}
```

``` javascript
// 用法：f.call(obj,arg1)
function f(a, b) {
   console.log(a + b)
   console.log(this.name)
}
let obj = {
   name: 1
}
f.myCall(obj, 1, 2)     // 否则this指向window

obj.greet.call({name: 'Spike'}) // 打出来的是 Spike
```

手写apply(arguments[this, [参数1，参数2.....] ])

``` javascript
// 箭头函数从不具有参数对象！！！！！这里不能写成箭头函数
Function.prototype.myApply = function(context) {
   let obj = context || window
   obj.fn = this
   const arg = arguments[1] || []    // 若有参数，得到的是数组
   let res = obj.fn(...arg)
   delete obj.fn
   return res
} 
function f(a, b) {
   console.log(a, b)
   console.log(this.name)
}
let obj = {
   name: '张三'
}
f.myApply(obj, [1, 2])     // arguments[1]
```

手写bind

``` javascript
this.value = 2
var foo = {
   value: 1
};
var bar = function(name, age, school) {
   console.log(name)                // 'An'
   console.log(age)                 // 22
   console.log(school)              // '家里蹲大学'
}
var result = bar.bind(foo, 'An')    // 预置了部分参数'An'
result(22, '家里蹲大学')            // 这个参数会和预置的参数合并到一起放入bar中
```

简单版本

``` javascript
Function.prototype.bind = function(context, ...outerArgs) {
   var fn = this;
   return function(...innerArgs) {   // 返回了一个函数，...rest为实际调用时传入的参数
      return fn.apply(context, [...outerArgs, ...innerArgs]);  // 返回改变了this的函数，
   // 参数合并
   }
}
```

new失败的原因：

例：

``` javascript
// 声明一个上下文
let thovino = {
   name: 'thovino'
}

// 声明一个构造函数
let eat = function (food) {
   this.food = food
   console.log(`${this.name} eat ${this.food}`)
}
eat.prototype.sayFuncName = function () {
   console.log('func name : eat')
}

// bind一下
let thovinoEat = eat.bind(thovino)
let instance = new thovinoEat('orange')   // 实际上orange放到了thovino里面
console.log('instance:', instance)        // {}
```

生成的实例是个空对象

在new操作符执行时，我们的thovinoEat函数可以看作是这样：

``` javascript
function thovinoEat (...innerArgs) {
   eat.call(thovino, ...outerArgs, ...innerArgs)
}
```

在new操作符进行到第三步的操作thovinoEat.call(obj, ...args)时，这里的obj是new操作符自己创建的那个简单空对象{}，但它其实并没有替换掉thovinoEat函数内部的那个上下文对象thovino。这已经超出了call的能力范围，因为这个时候要替换的已经不是thovinoEat函数内部的this指向，而应该是thovino对象。

**换句话说，我们希望的是new操作符将eat内的this指向操作符自己创建的那个空对象。但是实际上指向了thovino，new操作符的第三步动作并没有成功！**

可new可继承版本

``` javascript
Function.prototype.bind = function (context, ...outerArgs) {
   let that = this;

   function res (...innerArgs) {
      if (this instanceof res) {
         // new操作符执行时
         // 这里的this在new操作符第三步操作时，会指向new自身创建的那个简单空对象{}
         that.call(this, ...outerArgs, ...innerArgs)
      } else {
         // 普通bind
         that.call(context, ...outerArgs, ...innerArgs)
      }
   }
   res.prototype = this.prototype   // ！！！
   return res
}
```

***

## 手动实现new

**new的过程文字描述：**

1. 创建一个空对象 obj;
2. 将空对象的隐式原型（proto）指向构造函数的prototype。
3. 使用 call 改变 this 的指向
4. 如果无返回值或者返回一个非对象值，则将 obj 返回作为新对象；如果返回值是一个新对象的话那么直接直接返回该对象。

``` javascript
function Person(name, age) {
   this.name = name
   this.age = age
}
Person.prototype.sayHi = function() {
   console.log('Hi！我是' + this.name)
}
let p1 = new Person('张三', 18)

// 手动实现new
function create() {
   let obj = {}
   // 获取构造函数
   let fn = [].shift.call(arguments)  // 将arguments对象提出来转化为数组，arguments并不是数组而是对象    ！！！这种方法删除了arguments数组的第一个元素，！！这里的空数组里面填不填元素都没关系，不影响arguments的结果      或者let arg = [].slice.call(arguments,1)
   obj.__proto__ = fn.prototype
   let res = fn.apply(obj, arguments)    // 改变this指向，为实例添加方法和属性
   // 确保返回的是一个对象(万一fn不是构造函数)
   return typeof res === 'object' ? res : obj
}

let p2 = create(Person, '李四', 19)
p2.sayHi()
```

细节：

``` javascript
[].shift.call(arguments)   // 也可写成：
let arg = [...arguments]
let fn = arg.shift()  // 使得arguments能调用数组方法,第一个参数为构造函数
obj.__proto__ = fn.prototype
// 改变this指向，为实例添加方法和属性
let res = fn.apply(obj, arg)
```

***

## 手写promise(常见promise.all, promise.race)

``` javascript
// Promise/A+ 规范规定的三种状态
const STATUS = {
   PENDING: 'pending',
   FULFILLED: 'fulfilled',
   REJECTED: 'rejected'
}

class MyPromise {
   // 构造函数接收一个执行回调
   constructor(executor) {
      this._status = STATUS.PENDING    // Promise初始状态
      this._value = undefined          // then回调的值
      this._resolveQueue = []          // resolve时触发的成功队列
      this._rejectQueue = []           // reject时触发的失败队列
    
   // 使用箭头函数固定this（resolve函数在executor中触发，不然找不到this）
   const resolve = value => {
      const run = () => {
         // Promise/A+ 规范规定的Promise状态只能从pending触发，变成fulfilled
         if (this._status === STATUS.PENDING) {
            this._status = STATUS.FULFILLED // 更改状态
            this._value = value // 储存当前值，用于then回调
            
            // 执行resolve回调
            while (this._resolveQueue.length) {
               const callback = this._resolveQueue.shift()
               callback(value)
            }
         }
      }
      // 把resolve执行回调的操作封装成一个函数,放进setTimeout里,以实现promise异步调用的特性（规范上是微任务，这里是宏任务）
      setTimeout(run)
   }

   // 同 resolve
   const reject = value => {
      const run = () => {
         if (this._status === STATUS.PENDING) {
            this._status = STATUS.REJECTED
            this._value = value
        
            while (this._rejectQueue.length) {
               const callback = this._rejectQueue.shift()
               callback(value)
            }
         }
      }
      setTimeout(run)
   }

   // new Promise()时立即执行executor,并传入resolve和reject
   executor(resolve, reject)
}

// then方法,接收一个成功的回调和一个失败的回调
function then(onFulfilled, onRejected) {
   // 根据规范，如果then的参数不是function，则忽略它, 让值继续往下传递，链式调用继续往下执行
   typeof onFulfilled !== 'function' ? onFulfilled = value => value : null
   typeof onRejected !== 'function' ? onRejected = error => error : null

   // then 返回一个新的promise
   return new MyPromise((resolve, reject) => {
      const resolveFn = value => {
         try {
            const x = onFulfilled(value)
            // 分类讨论返回值,如果是Promise,那么等待Promise状态变更,否则直接resolve
            x instanceof MyPromise ? x.then(resolve, reject) : resolve(x)
         } catch (error) {
         reject(error)
         }
      }
   }
}

const rejectFn = error => {
   try {
      const x = onRejected(error)
      x instanceof MyPromise ? x.then(resolve, reject) : resolve(x)
   } catch (error) {
      reject(error)
   }
}

switch (this._status) {
   case STATUS.PENDING:
      this._resolveQueue.push(resolveFn)
      this._rejectQueue.push(rejectFn)
      break;
   case STATUS.FULFILLED:
      resolveFn(this._value)
      break;
   case STATUS.REJECTED:
      rejectFn(this._value)
      break;
}

})
}

catch(rejectFn) {
   return this.then(undefined, rejectFn)
}
// promise.finally方法
finally(callback) {
   return this.then(value => MyPromise.resolve(callback()).then(() => value), error => {
      MyPromise.resolve(callback()).then(() => error)
   })
}

// 静态resolve方法
static resolve(value) {
   return value instanceof MyPromise ? value : new MyPromise(resolve => resolve(value))
}

// 静态reject方法
static reject(error) {
   return new MyPromise((resolve, reject) => reject(error))
}

// 静态all方法
static all(promiseArr) {
   let count = 0
   let result = []
   return new MyPromise((resolve, reject) => {
      if (!promiseArr.length) {
         return resolve(result)
      }
      promiseArr.forEach((p, i) => {
         MyPromise.resolve(p).then(value => {
            count++
            result[i] = value
            if (count === promiseArr.length) {
               resolve(result)
            }
         }, error => {
            reject(error)
         })
      })
   })
}

// 静态race方法
static race(promiseArr) {
   return new MyPromise((resolve, reject) => {
      promiseArr.forEach(p => {
         MyPromise.resolve(p).then(value => {
            resolve(value)
         }, error => {
            reject(error)
         })
      })
   })
}
```

***

## 手写原生AJAX

步骤

1. 创建 XMLHttpRequest 实例
2. 发出 HTTP 请求
3. 服务器返回 XML 格式的字符串
4. JS 解析 XML，并更新局部页面

不过随着历史进程的推进，XML 已经被淘汰，取而代之的是 JSON。

了解了属性和方法之后，根据 AJAX 的步骤，手写最简单的 GET 请求。
version 1.0：

``` javascript
myButton.addEventListener('click', function () {
  ajax()
})

function ajax() {
   let xhr = new XMLHttpRequest() //实例化，以调用方法
   xhr.open('get', 'https://www.google.com')  //参数2，url。参数三：异步
   xhr.onreadystatechange = () => {  //每当 readyState 属性改变时，就会调用该函数。
      if (xhr.readyState === 4) {  //XMLHttpRequest 代理当前所处状态。
         if (xhr.status >= 200 && xhr.status < 300) {  //200-300请求成功
            let string = request.responseText
            //JSON.parse() 方法用来解析JSON字符串，构造由字符串描述的JavaScript值或对象
            let object = JSON.parse(string)
         }
      }
   }
   request.send() //用于实际发出 HTTP 请求。不带参数为GET请求
}
```

promise实现

``` javascript
function ajax(url) {
   const p = new Promise((resolve, reject) => {
      let xhr = new XMLHttpRequest()
      xhr.open('get', url)
      xhr.onreadystatechange = () => {
      if (xhr.readyState == 4) {
         if (xhr.status >= 200 && xhr.status <= 300) {
            resolve(JSON.parse(xhr.responseText))
         } else {
            reject('请求出错')
         }
      }
   }
   xhr.send()  //发送hppt请求
   })
   return p
}
let url = '/data.json'
ajax(url)
.then(res => console.log(res))
.catch(reason => console.log(reason))
```

***

## 手写节流防抖函数

防抖：

``` javascript
function debounce(fn, delay) {
   if (typeof fn!=='function') {
      throw new TypeError('fn不是函数')
   }
   let timer; // 维护一个 timer
   return function () {
      var _this = this; // 取debounce执行作用域的this(原函数挂载到的对象)
      var args = arguments;
      if (timer) {
         clearTimeout(timer);
      }
      timer = setTimeout(function () {
         fn.apply(_this, args); // 用apply指向调用debounce的对象，相当于_this.fn(args);
      }, delay);
   };
}

input1.addEventListener('keyup', debounce(() => {
   console.log(input1.value)
}), 600)
```

节流：

``` javascript
function throttle(fn, delay) {
   let timer;
   return function () {
      var _this = this;
      var args = arguments;
      if (timer) {
         return;
      }
      timer = setTimeout(function () {
         fn.apply(_this, args); // 这里args接收的是外边返回的函数的参数，不能用arguments
         // fn.apply(_this, arguments); 需要注意：Chrome 14 以及 Internet Explorer 9 仍然不接受类数组对象。如果传入类数组对象，它们会抛出异常。
         timer = null; // 在delay后执行完fn之后清空timer，此时timer为假，throttle触发可以进入计时器
      }, delay)
   }
}

div1.addEventListener('drag', throttle((e) => {
   console.log(e.offsetX, e.offsetY)
}, 100))
```

***

## 手写Promise加载图片

``` javascript
function getData(url) {
   return new Promise((resolve, reject) => {
      $.ajax({
         url,
         success(data) {
         resolve(data)
         },
         error(err) {
         reject(err)
         }
      })
   })
}
const url1 = './data1.json'
const url2 = './data2.json'
const url3 = './data3.json'
getData(url1)
.then(data1 => {
  console.log(data1)
  return getData(url2)
})
.then(data2 => {
  console.log(data2)
  return getData(url3)
})
.then(data3 => {
   console.log(data3)
})
.catch(err => {
   console.error(err)
})
```

***

## 函数实现一秒钟输出一个数

``` javascript
for(let i = 0; i <= 10; i++){   //用var打印的都是11
   setTimeout(() => {
      console.log(i);
   }, 1000*i)
}
```

***

## 创建10个标签，点击的时候弹出来对应的序号

``` javascript
var a
for (let i = 0; i < 10; i++) {
   a = document.createElement('a')
   a.innerHTML = i + '<br>'
   a.addEventListener('click', function(e) {
      console.log(this)    //this为当前点击的<a>
      e.preventDefault()   //如果调用这个方法，默认事件行为将不再触发。
      //例如，在执行这个方法后，如果点击一个链接（a标签），浏览器不会跳转到新的 URL 去了。我们可以用 event.isDefaultPrevented() 来确定这个方法是否(在那个事件对象上)被调用过了。
      alert(i)
   })
   const d = document.querySelector('div')
   d.appendChild(a)  //append向一个已存在的元素追加该元素。
}
```
