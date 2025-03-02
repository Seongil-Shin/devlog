
## Weak Map

Map 에서는 아래와 같이 객체를 넣고 null로 초기화하였을 경우에도 Map 안에 참조가 살아있어 GC 되지 않는다

```js
let john = { name: "John" }

let map = new Map();
map.set(john, "some value");

john = null;

// map 안에 참조가 살아있어 GC되지 않음
```

WeakMap은 Map과 달리 아래와 같은 차이점을 가진다
- WeakMap의 key는 반드시 object 여야한다
- WeakMap의 key인 object의 참조부분이 없다면 해당 object는 GC 된다.
- WeakMap은 iteration 과 keys(), values(), entries() 메소드를 지원하지 않는다
```js
let john = { name: "John" }

let map = new Map();
map.set(john, "some value");

john = null;

// john 객체가 GC됨
```

WeakMap은 iteration 과 keys(), values(), entries() 메소드를 지원하지 않는데, 이 이유는 GC가 바로 일어나는 것이 아니기 때문이다. 시간을 두고 GC가 발생할 수도 있기에 GC 되기전에 살아있는 상태를 keys() 등의 메소드를 통해 접근할 가능성이 있기 때문에 지원하지 않는다. 


이러한 WeakMap은 캐싱에 사용할 수도 있다

```js
let cache = new WeakMap();

function process(obj) {
	if(!cache.has(obj)) {
		let result = "" // ... some processing
		cache.set(obj, result);
	}
	return cache.get(obj);
}

let obj = {};

let result1 = process(obj);
let result2 = procesS(obj);

obj = null;

```


## WeakSet

WeakMap과 마찬가지로 아래 특성을 가진다.
- 객체만 저장할 수 있다
- 저장된 객체는 참조가 살아있을 때만 메모리에 유지된다
- iteration, size, keys() 를 사용할 수 없다. add(), has(), delete()만 사용가능하다

사용예시) 유저 방문 확인

```js
let visitedSet = new WeakSet();

let john = { name: "John" };
let pete = { name: "Pete" };
let mary = { name: "Mary" };

visitedSet.add(john); // John이 사이트를 방문합니다.
visitedSet.add(pete); // 이어서 Pete가 사이트를 방문합니다.
visitedSet.add(john); // 이어서 John이 다시 사이트를 방문합니다.

// visitedSet엔 두 명의 사용자가 저장될 겁니다.
// John의 방문 여부를 확인해보겠습니다.
alert(visitedSet.has(john)); // true

// Mary의 방문 여부를 확인해보겠습니다.
alert(visitedSet.has(mary)); // false

john = null;

// visitedSet에서 john을 나타내는 객체가 자동으로 삭제됩니다.
```


## WeakRef

위 예시들과 비슷하게 Map의 value에 들어간 객체 또한 GC가 되지 않는다

```js
const map = new Map(); 
const obj = { data : new Array(10000).join('*')}; 

map.set('someData', obj);

obj = null;

// GC 되지 않음
```

이때 WeakRef를 사용하면 GC가 되도록 할 수 있다

```js
const map = new Map(); 
const obj = { data : new Array(10000).join('*')}; 

map.set('someData', new WeakRef(obj));
map.get('someData').deref().data;   // 참조를 꺼내야할때는 .deref() 사용

obj = null;

// GC 되고, deref()는 undefined를 반환함
```



## 참고
- https://kim-born-in-mapo.tistory.com/28
- https://ko.javascript.info/weakmap-weakset
- https://leedhhhhh.tistory.com/20