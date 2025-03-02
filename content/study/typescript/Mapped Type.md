

기존에 정의되어 있는 타입을 새로운 타입으로 변환해주는 문법

예시) 인터페이스에 있는 모든 속성을 순회하여 다른 타입으로 변경할 수 있음
```ts
interface Obj {
   prop1: string;
   prop2: string;
}
type ChangeType<T> = { 
   [K in keyof T]: number;
};
type Result = ChangeType<Obj>;
/*
{ 
   prop1: number; 
   prop2: number; 
}
*/
```


## Mapped Type 문법

```ts
{ [P in K]: T}
{ [P in K]?: T}
{ readonly [P in K]: T}
{ readonly [P in K]?: T}
```


위 문법을 사용하여 객체 타입의 모든 속성을 readonly나 optional로 변경하는 작업을 쉽게할 수 있다

```ts
interface Person {
   name: string;
   age: number;
}

type ReadOnly<T> = {
   readonly [P in keyof T]: T[P];
};

type ParTial<T> = {
   [P in keyof T]?: T[P];
};

type PersonPartial = Partial<Person>;
type ReadonlyPerson = Readonly<Person>;
```
- `in` : 자바스크립트의 `for in` 처럼 루프를 돌려주는 키워드
- `keyof`  : 인터페이스 Obj 객체 타입 속성들을 뽑아 유니온으로 만들어주는 역할을 함


## Mapped Type 활용

- 단순 객체 생성 예제
```ts
type T1 = { 
	[K in "prop1" | "prop2"]: boolean 
};
```

```ts
type Prop = 'prop1' | 'prop2';

type Make<T> = { 
	[K in Prop]: T 
};

type T1 = Make<boolean>;
```

- 객체 속성 변경
```ts
interface UserProfile {
   username: string;
   email: string;
   profilePhotoUrl: string;
}

type UserProfileUpdate = {
   [p in keyof UserProfile]?: UserProfile[p];
};
```

- readonly, optional 제거
```ts
interface Person1 {
   name?: string;
   age?: number;
}

interface Person2 {
   readonly name: string;
   readonly age: number;
}

type Exclude_ReadOnly<T> = {
   // -readonly 라는 뜻은 readonly를 떼라 라는 의미이다.
   // 반대로 +readonly 는 readonly를 추가하라는 의미인데 정수를 +1로 안쓰듯이 그냥 생략 가능함
   -readonly [P in keyof T]: T[P];
};

type Exclude_ParTial<T> = {
   // -? 라는 뜻은 ?를 떼라 라는 의미이다.
   // 반대로 +? 는 ?를 추가하라는 의미인데 정수를 +1로 안쓰듯이 그냥 생략 가능함
   [P in keyof T]-?: T[P];
};

type PersonPartial = Exclude_ParTial<Person1>;
/*
type PersonPartial = {
    name: string;
    age: number;
}
*/

type ReadonlyPerson = Exclude_ReadOnly<Person2>;
/*
type ReadonlyPerson = {
    name: string;
    age: number;
}
*/
```


- 중첩 객체 타입 생성
```ts
interface Person {
   name: string;
   age: number;
   language: string;
}

type Recorded<K extends string, T> = { [P in K]: T };

type T1 = Recorded<'p1' | 'p2', Person>;

const t: T1 = {
   p1: {
      name: '홍길동',
      age: 88,
      language: 'kor',
   },
   p2: {
      name: '링컨',
      age: 34,
      language: 'eng',
   },
};
```


## 참고
- https://inpa.tistory.com/entry/TS-%F0%9F%93%98-%ED%83%80%EC%9E%85%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8-Mapped-types-%EC%99%84%EB%B2%BD-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0