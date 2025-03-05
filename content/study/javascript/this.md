---
title: this
author: 신성일
date: 2025-01-24 19:00:00 +0900
categories: study, js
tags:
  - "#study"
  - review
---


Javscript 에서의 this는 함수를 호출할 때 바인딩할 객체가 결정된다.

## 함수 호출 방식과 this 바인딩

### 함수 호출

일반 함수에서 this는 기본적으로 전역 객체로 바인딩된다. 따라서 브라우저에서 실행 시 다음 함수 안의 this는 window와 연결된다. (strict 모드에서는 undefined). 이는 물론 내부 함수도 마찬가지다

```js
function foo() {
	console.log(this);  // window
	function bar() {
		console.log(this) // window
	}
	bar()
}
foo()
```

이는 객체의 메서드 안의 내부 함수, 콜백일 경우도 마찬가지이다.

```js
var obj = {
  value: 100,
  foo: function() {
    console.log("foo's this: ",  this);  // obj
    function bar() { /* 내부함수 */
      console.log("bar's this: ",  this); // window
    }
    bar();

    setTimeout(function() {  /* 콜백함수 */
      console.log("callback's this: ",  this);  // window
    }, 100);
  }
};

obj.foo();
```

이러한 현상은 일반함수, 내부함수, 콜백의 this을 지정해주지 않았기에 전역객체가 바인딩되는 것이다. 이는 JS 개발자조차 설계상의 오류라고 했을 정도로 이상한 동작이다

이를 회피하기 위해선 다음과 같은 방법을 사용할 수 있다
- `var innerThis = this;` 와 같이 현재 객체의 this를 따로 저장하여 사용
- `call`, `bind`, `apply`로 this 설정
- 화살표 함수 사용

### 메소드 호출

객체의 메소드에서 this를 사용할 경우 기본적으로 그 객체와 연결이 된다.

```js
var obj = {
	a : function {console.log(this)}
}
obj.a(); // obj
```

하지만 아래와 같이 메서드를 꺼내온다면 바인딩 되는 this는 달라진다

```js
var a2 = obj.a;
a2() // Window {}
```

this는 호출하는 함수에 따라 바인딩 되기에, `a2`를 호출할 경우 `a2`는 전역 객체에 포함이 되기에 전역 객체와 연동이 되는 것이다.

### 프로토타입

프로토타입 객체 메소드 내부에서 사용된 this도 일반 메소드처럼 해당 메소드를 호출한 프로토타입 오브젝트 객체에 바인딩 된다. 

```js
function Person(name) {
  this.name = name;
}
Person.prototype.getName = function() {
  return this.name;
}
var me = new Person('Lee');
console.log(me.getName());   // "Lee"

Person.prototype.name = 'Kim';
console.log(Person.prototype.getName());  // "Kim"
```


### 콜백함수 호출

콜백 함수는 전역 객체로 연동 된다는 것을 위에서 살펴봤다. 따라서 다음 예시도 콜백함수가 전역 객체로 연결되어 첫번째 콘솔 결과가 Not Set으로 나오게 된다.

```js
let userData = {
    signUp: '2020-10-06 15:00:00',
    id: 'minidoo',
    name: 'Not Set',
    setName: function(firstName, lastName) {
        this.name = firstName + ' ' + lastName;
    }
}

function getUserName(firstName, lastName, callback) {
    callback(firstName, lastName);
}

getUserName('PARK', 'MINIDDO', userData.setName);

console.log('1: ', userData.name); // Not Set
console.log('2: ', window.name); // PARK MINIDDO
```

이때는 `call`, `apply`, `bind`로 해결할 수 있다

```js
function getUserName(firstName, lastName, callback) {
    callback.call(userData, firstName, lastName);
}

getUserName('PARK', 'MINIDDO', userData.setName);

console.log('1: ', userData.name); // PARK MINIDDO
console.log('2: ', window.name); // undefined
```

### apply/call/bind 호출

```js
func.apply(thisArg, [argsArray])
func.call(thisArg, argsArray)
func.bind(thisArg)(argsArray)

// thisArg: 함수 내부의 this에 바인딩할 객체
// argsArray: 함수에 전달할 argument의 배열
```

호출하는 함수에 바인딩할 this를 명시적으로 지정할 수 있음

### 이벤트 리스너에서의 this

이벤트 리스너에서는  그 리스너가 부착된 dom이 this로 바인딩된다.

```js
document.body.onclick = function() {
  console.log(this); // <body>
}
```

하지만 마찬가지로 내부 함수는 전역 객체로 바인딩된다.

```js
document.body.onclick = function() {
  console.log(this); // body
  function inner() {
    console.log('inner', this); // inner Window
  }
  inner();
}
```

이 문제는 위에서 살펴보았듯 다음과 같이 해결할 수 있다
- `var innerThis = this;` 와 같이 현재 객체의 this를 따로 저장하여 사용
- `call`, `bind`, `apply`로 this 설정
- 화살표 함수 사용


## 체이닝

객체의 메서드에서 this를 반환하면 해당 this는 자기 객체를 가리키기에 연속적으로 메소드를 호출하는 체이닝을 할 수 있다

```js
let ladder = {
  step: 0,
  up() {
    this.step++;
    return this;
  },
  down() {
    this.step--;
    return this;
  },
}

ladder.up().down().up().down(); 
```


## 화살표함수의 this

화살표함수에는 this가 존재하지 않는다. 따라서 화살표함수에서 this를 사용하면 렉시컬스코프에 따라 상위스코프에 존재하는 this를 참조하게 된다. 그렇기에 callback이나 내부함수에서 this가 전역객체로 연결되는 현상을 방지할 수 있다

```js
var obj = {
  value: 100,
  foo: function() {
    console.log("foo's this: ",  this);  // obj
    var bar = () => {
      console.log("bar's this: ",  this); // obj
    }
    bar();

    setTimeout(() => {
      console.log("callback's this: ",  this);  // obj
    }, 100);
  }
};

obj.foo();
```

하지만 이러한 특성 때문에 화살표함수를 사용하면 문제가 있는 곳들이 있다
- 메소드 : 상위 스코프의 this를 사용하게 되어 현재 객체를 참조하지 못하게 됨. 
```js
const obj = {
	name : "name",
	foo: () => console.log(this.name)  // undefined. 
}
```
- 생성자 함수 : 화살표함수는 생성자 함수로 쓸 수 없음 
```js
const Foo = () => {}
const foo = new Foo() // TypeError: Foo is not a constructor
```
- 이벤트리스너 : 이벤트리스너의 this는 이벤트가 부착된 곳을 의도한 경우가 많은데 화살표함수 사용시 전역객체가 붙어버린다. 
```js
button.addEventListener('click', () => {
  console.log(this);	// Window
  this.innerHTML = 'clicked';
});
document.body.onclick = () => {
  console.log(this); // Window
}
```

## 참고
- https://inpa.tistory.com/entry/JS-%F0%9F%93%9A-this-%EC%B4%9D%EC%A0%95%EB%A6%AC
- https://velog.io/@padoling/JavaScript-%ED%99%94%EC%82%B4%ED%91%9C-%ED%95%A8%EC%88%98%EC%99%80-this-%EB%B0%94%EC%9D%B8%EB%94%A9