https://github.com/yeonjuan/dev-blog/blob/master/JavaScript/reduce-html-payload-with-nextjs.md


## 문제
next.js 로 생성된 HTML에는 `__NEXT_DATA__` 스크립트 태그 안에 `getServerSideProps`에서 반환한 JSON 데이터가 들어가있다. 이는 리액트 Hydration을 위해 존재한다.

## 해결
1. 불필요한 필드 제거
2. 데이터를 UI에서 사용하는 방식으로 미리 정제하여 사이즈를 줄임