

조건문에서 객체의 타입을 좁혀가면서 사용하는 것

## `typeof

```ts
function doSomething(x: number | string) {
	if(typeof x === "string") {
		console.log(x.slice(0,1)); // x 는 string이라는 보장이 있음
	}
}
```

## `instanceof`

```ts
function doSomething(x: Foo | Bar) {
	if(x instanceof Foo) {
		console.log(x.foo); // x 는 Foo이라는 보장이 있음
	}
}

```

## `in`

```ts
interface A {
  x: number;
}
interface B {
  y: string;
}

function doStuff(q: A | B) {
  if ('x' in q) {
  // q: A
  }
  else {
  // q: B
  }
}
```

## 리터럴 Type Guard

```ts
type Foo = {
  kind: 'foo', // 리터럴 타입
  foo: number
}
type Bar = {
  kind: 'bar', // 리터럴 타입
  bar: number
}

function doStuff(arg: Foo | Bar) {
  if (arg.kind === 'foo') {
	  console.log(arg.foo); // ㅇㅋ
	  console.log(arg.bar); // Error!
  }
  else {  // 백퍼 Bar겠군.
	  console.log(arg.foo); // Error!
	  console.log(arg.bar); // ㅇㅋ
  }
}
```

## `null`, `undefined`

`==`, `!=` 으로 `null`, `undefined`를 한번에 걸러낼 수 있다

```ts
function foo(a?: number | null) {
  if (a == null) return;
  // 이제부터 a는 무조건 number입니다.
}
```

## 사용자 정의 type guard 함수

type guard 함수를 통해 특정 인자의 타입을 결정 지어줄 수 있다

```ts
function isFoo(arg: any): arg is Foo {
  return arg.foo !== undefined;
}
```


## Type guard 와 Callback

콜백 함수 내에서 type guard가 풀리는 경우가 있다. 
```ts
// Example Setup
declare var foo:{bar?: {baz: string}};
function immediate(callback: () => void) {
  callback();
}

// Type Guard
if (foo.bar) {
  console.log(foo.bar.baz); // ㅇㅋ
  functionDoingSomeStuff(() => {
    console.log(foo.bar.baz); // TS error: 해당 객체는 'undefined'일 가능성이 있습니다.
  });
}
```

이러한 경우 다음과 같이 로컬 변수에다가 값을 담아 해결 할 수 있다

```ts
// Type Guard
if (foo.bar) {
  console.log(foo.bar.baz); // ㅇㅋ
  const bar = foo.bar;
  functionDoingSomeStuff(() => {
  console.log(bar.baz); // ㅇㅋ
  });
}
```


## 참고
- https://radlohead.gitbook.io/typescript-deep-dive/type-system/typeguard