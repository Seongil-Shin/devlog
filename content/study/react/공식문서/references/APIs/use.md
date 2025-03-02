https://ko.react.dev/reference/react/use

`Promise`나 `Context`와 같은 데이터를 참조하는 React Hook

## Reference 

**`use(resousece)`**

```js
import { use } from "react";

function MessageComponent({ messagePromise }) {
	const message = use(messagePromise)
	const theme = use(ThemeContext);
	// ...
}
```

- 다른 React Hook과 달리 `if`와 같은 조건문과 반복문 안에서 호출할 수 있지만 컴포넌트나 Hook 내부에서만 사용가능
- **Promise와 함께 호출할 때 `Suspense` 및 error boundary와 통합된다.** Promise가 pending 되는 동안 `use`를 호출하는 컴포넌트는 suspend 된다. 만약 Promise가 reject 되면 가장 가까운 error boundary의 fallback이 표시된다.

- 반환값 : Promise나 context에서 참조한 값을 반환한다
- 주의사항
	- 서버 컴포넌트에서 데이터를 fetch 해야하면 `use`보단 `async - await`가 낫다. `async - await`는 `await`가 호출된 시점부터 렌더링을 시작하는데, `use`는 데이터가 리졸브된 후 컴포넌트를 리렌더링하기때문이다.
	- 클라이언트에서 fetch 해도 되면 Promise를 클라이언트로 내려보내는 것이 좋은데, 서버컴포넌트에서 await를 사용하면  await가 완료될때까지 렌더링이 차단되기 때문이다.
	- 클라이언트 컴포넌트에서 Promise를 생성하는 것보다 서버 컴포넌트에서 Promise를 생성하여 클라이언트 컴포넌트로 전달하는 것이 좋다. 클라이언트 컴포넌트에서 생성된 Promise는 렌더링 때마다 재생성 되기 때문이다. 
	- **서버컴포넌트에서 클라이언트 컴포넌트로 Promise를 전달할때 리졸브된 값이 직렬화 가능해야한다**. 함수는 직렬화할 수 없기에 Promise의 리졸브 값이 될 수 없다.


#review 
