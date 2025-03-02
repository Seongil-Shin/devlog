
- Enum을 TS 트랜스파일링 후 IIFE로 변환된다
- IIFE는 Rollup과 같은 번들러에서는 사용하지 않는 코드라 판단할 수 없어 tree shaking 되지 않는다
- Enum 대신 `as const`를 사용하는 것이 추천된다
- 하지만 개발 편의성과 단점을 비교해봐야한다
	- 실제로 사용되지 않을지, 사용중인 번들러에서 tree-shaking을 아예 안하는지


## 참고
- https://velog.io/@hhhminme/%EB%84%A4-Enum-%EB%88%84%EA%B0%80-Typescript%EC%97%90%EC%84%9C-Enum%EC%9D%84-%EC%93%B0%EB%83%90#tree-shaking%EC%9D%B4%EB%9E%80