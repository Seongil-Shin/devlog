
Conditional Type (조건부 타입)이란 입력된 제네릭 타입에 따라 타입을 결정하는 기능을 말한다

예시는 다음과 같다

```ts
// 제네릭이 string이면 문자열배열, 아니면 넘버배열
type IsStringType<T> = T extends string ? string[] : number[];

type T1 = IsStringType<string>; // type T1 = string[]
type T2 = IsStringType<number>; // type T2 = number[]

const a: T1 = ['홍길동', '임꺾정', '박혁거세'];
const b: T2 = [1000, 2000, 3000];
```

```ts
// 제네릭 `T`는 `boolean` 타입으로 제한.
// 제네릭 T에 true가 들어오면 string 타입으로, false가 들어오면 number 타입으로 data 속성을 타입 지정
interface isDataString<T extends boolean> {
   data: T extends true ? string : number;
   isString: T;
}

const str: isDataString<true> = {
   data: '홍길동', // String
   isString: true,
};

const num: isDataString<false> = {
   data: 9999, // Number
   isString: false,
};
```


## 분산 조건부타입

다음과 같이 union 타입을 넣었을 경우에는 각 타입을 분리하여 다룬다

```ts
type IsStringType<T> = T extends string ? 'yes' : 'no';

type T1 = IsStringType<string | number>;   // 'yes' | 'no'
```

`string | number`를 분리하여 각각 `(string extends string ? 'yes' : 'no') | (number extends string ? 'yes' : 'no')` 로 다루게 되는 것이다

하지만 이러한 분산은 조건부 타입에서 `naked type parameter`가 사용되었을 경우에만 동작한다
> (naked) type parameter는 제네릭 T 와 같이 의미가 없는 타입 파라미터를 말하는 것이며,  
만일 직접 리터럴 타입을 명시하거나 혹은 제네릭 T[] 와 같이 변횐된 타입 파라미터이면, naked 가 아니게 된다.

```ts
type T1 = (1 | 3 | 5 | 7) extends number ? 'yes' : 'no'; // naked 타입이 아니라서 분산이 되지 않는다.
type T2<T> = T extends number ? T[] : 'no'; // 제네릭 T는 naked 타입이라 분산이 된다.
type T3<T> = T[] extends number ? 'yes' : T[]; // 제네릭이지만 T[] 와 같이 변형된 타입 파라미터는 naked 타입이 아니라서 분산이 일어나지 않는다.

type T4 = T1; // "yes"
type T5 = T2<(1 | 3 | 5 | 7)>; // 1[] | 3[] | 5[] | 7[]
type T6 = T2<(1 | 3 | 5 | 7)>; // (1 | 3 | 5 | 7)[]
```


## `never` 의 경우

만약 조건부 타입의 결과로 `never`가 나왔을 경우에는 이 타입을 제외시킨다

```ts
type Never<T> = T extends number ? T : never;

type Types = number | string | object;
type T2 = Never<Types>; // type T2 = number
```


이를 이용해 `Exclude`와 `Extract`를 구현할 수 있다

```ts
// 유니온 타입을 받아 T와 U를 비교해 U와 겹치는 타입들은 제외한 T를 반환하는 타입
type My_Exclude<T, U> = T extends U ? never : T;

type T2 = My_Exclude<(1 | 3 | 5 | 7), (1 | 5 | 9)>; // U 제네릭(1 | 5 | 9)에 속해있지 않은 3 | 7 만 반환됨 
type T3 = My_Exclude<string | number | (() => void), Function>; // U 제네릭(Function)에 속해있지 않은 string | number 만 반환 됨
```

```ts
// 유니온 타입을 받아 T와 U를 비교해 U와 겹치는 타입들만 재구성해 T를 반환하는 타입
type My_Extract<T, U> = T extends U ? T : never;

type T4 = My_Extract<(1 | 3 | 5 | 7), (1 | 5 | 9)>; // U 제네릭에(1 | 5 | 9) 속해있는 1 | 5 만 반환됨

export {};
```


## infer 키워드

infer 키워드를 사용하여 좀 더 다양한 경우에 대응 가능한 코드를 생성할 수 있다.
`T extends infer U ? X : Y`로 하게 되면 추론된 값을 `U`에 할당한다

```ts
type Foo<T> = T extends { a: infer U, b: infer U } ? U : never;
type T10 = Foo<{ a: string, b: string }>;  // string
type T11 = Foo<{ a: string, b: number }>;  // string | number
```

```ts
type Bar<T> = T extends { a: (x: infer U) => void, b: (x: infer U) => void } ? U : never;
type T20 = Bar<{ a: (x: string) => void, b: (x: string) => void }>;  // string
type T21 = Bar<{ a: (x: string) => void, b: (x: number) => void }>;  // string & number
```

이를 사용해 함수의 파라미터, 리턴 타입을 추론할 수도 있다

```ts
function fn(num: number, str: string, bool: boolean): string | void {
   return num.toString();
}

type My_ReturnType<T extends (...args: any) => any> = T extends (...args: any) => infer R ? R : any;
type My_Parameters<T extends (...args: any) => any> = T extends (...args: infer R) => any ? R : never;

type Return_Type = My_ReturnType<typeof fn> // 함수의 리턴 타입을 반환
// type Return_Type = string | voi

type Parameters_Type = My_Parameters<typeof fn> // 함수의 파라미터들의 타입을 반환
// type Parameters_Type = [num: number, ste: string, bool: boolean]

const a: My_ReturnType<typeof fn> = 'Hello';
const b: My_Parameters<typeof fn> = [123, 'Hello', true];
```

## 미리 정의된 조건부 타입

TypeScript 2.8 부터 추가된 미리 정의된 조건부 타입을 사용할 수 있다

- Exclude<T, U>
- Extract<T, U>
- `NonNullable<T>`
- `ReturnType<T>`
- `InstanceType<T>`


## 참고

- https://radlohead.gitbook.io/typescript-deep-dive/type-system/lib.d.ts
