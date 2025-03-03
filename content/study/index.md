---
title: study
---


## javascript
- [[content/study/javascript/js this|js this]]
    - 함수호출 시 기본적으로 전역객체와 연결됨 (내부, 콜백 함수 모두 포함) (strict 에서는 undefined)
        - call, apply, bind로 this에 연결하고자하는 객체를 설정할 수 있음
    - 객체의 메서드에서는 해당 객체로 연결됨
    - 프로토타입은 해당 메서드를 호출한 객체와 연결됨
    - 이벤트 리스너에서는 해당 이벤트가 부착된 dom 이 this로 설정됨
    - 화살표함수에는 this가 존재하지 않음. 따라서 객체의 메서드, 이벤트리스너로 화살표함수는 지양
- **Javascript event loop** : [https://seongil-shin.github.io/posts/eventloop/](https://seongil-shin.github.io/posts/eventloop/)
    - call stack에 함수를 하나하나 쌓아가며 실행하다가 비동기로 실행해야할 코드를 만나면 백그라운드에서 실행한 후 콜백을 태스크큐에 등록
    - micro task → animationFrame task → macro task 순으로 실행됨
    - 앞의 queue가 전부 비워져야 뒤에 queue가 실행이 가능하여, 만약 micro task에서 다시 micro task를 계속 추가한다면 프로그램이 멈춘것처럼 보이게 된다.
- 실행 컨텍스트 : [](https://seongil-shin.github.io/posts/%EC%8B%A4%ED%96%89%EC%BB%A8%ED%85%8D%EC%8A%A4%ED%8A%B8/)[https://seongil-shin.github.io/posts/실행컨텍스트/](https://seongil-shin.github.io/posts/%EC%8B%A4%ED%96%89%EC%BB%A8%ED%85%8D%EC%8A%A4%ED%8A%B8/)
    - 실행컨텍스트 : 실행되는 함수의 지역메모리와 실행문을 포함한 것
    - 클로저 : **어떠한** **함수가 정의된 스코프가 아닌 다른 스코프에서 함수가 실행되더라도, 그 함수가 실행된 위치에서는 접근할 수 없고, 실행된 함수에서는 접근 가능한 변수를 클로저를 통해 접근할 수 있게 해줌**
        - 활용 : 여러 함수 호출에 거쳐 상태 기억, 변수 캡슐화
        - 함수를 일급객체로 다루는 렉시컬 스코프를 가진 언어의 특징.
- var vs let, const
    - var : 재선언, 호이스팅 가능, 함수스코프
    - let, const : 재선언 불가능, 호이스팅 되지만 초기화되지 않아 사용 불가능, 블록스코프
        - 호이스팅이 안되면 블록 전반부는 섀도우 안되는 이슈 발생
        - 초기화되면 const 동작이 이상해짐
- 호이스팅이란?
    - 해당 스코프에 식별자를 등록하는 것
    - 함수의 경우 호이스팅과 함수 참조로의 초기화가 동시에 발생한다
- AMD, UMD
    - AMD : CJS는 동기적으로 로딩하는데, 브라우저에서 동기적으로 파일 로딩하면 성능 이슈가 생기기, 모듈을 비동기적으로 로딩하기위해 탄생
    - UMD : CJS, AMD 호환을 위해 사용
    - ESM : 공식 모듈
- requestAnimationFrame: [https://developer.mozilla.org/ko/docs/Web/API/Window/requestAnimationFrame](https://developer.mozilla.org/ko/docs/Web/API/Window/requestAnimationFrame)
    - 브라우저가 화면에 애니메이션을 업데이트할 준비가 될때마다 이 API에 등록된 콜백을 실행시킴
    - 일반적으로 분당 60회 정도 실행시키나 대부분 디스플레이 주사율과 맞춘다
    - 최적화를 위해 백그라운드로 숨겨진 탭의 경우 requestAnimationFrame 콜백은 실행되지 않는다.
- event.target과 event.currentTarget의 차이점
    - target : 이벤트가 발생한 위치, currentTarget : 이벤트가 부착된 위치
- 함수형 프로그래밍
    - 순수함수의 조합으로 어플리케이션을 만드는 방식
        - 순수함수는 외부의 값을 변경하지 않고 사이드이펙트를 일으키지 않는 함수이다
        - 따라서 동일한 인자에 항상 동일한 결과를 반환함.
    - 함수를 일급객체로 간주하여 함수를 변수처럼 취급할 수 있는 언어에서 사용
        - 다른 함수에 인수로 넣거나 반환값이 넣을 수 있음
    - 선언형 프로그래밍의 일종으로 가독성을 높이고 유지보수를 용이하게 해준다.
    - 사이드 이펙트가 전혀 없이 애플리케이션을 만들기는 어렵기에 적절히 함수형의 개념을 차용하면 좋다. (순수함수의 조합)

## react
- [[content/study/react/공식문서/공식문서/재조정|재조정]]
    - virtual dom : 실제 DOM의 가상화. **상태가 변경되어 리렌더링이 필요할때 먼저 virtual dom 에 변경사항을 적용하고 이전 virtual dom과 비교하여 변경된 부분만 실제 DOM에 반영하기 위해 사용.** 실제 DOM 조작을 최소화하기 위해 사용한다.
        - virtual dom이 없다면 변경사항을 추적하기 어렵기에 실제 DOM 조작의 횟수가 많아진다
        - 예를들어 **리스트에서 하나가 추가되었을때 virtual dom이 없으면 이전에 어떤 요소가 있었는지, 얼마나 바뀌었는지 확인하기 어려움.**
    - diffing 알고리즘 : 아래의 2가지 가정을 기반으로 이전/현재 virtual dom을 비교할시 O(n) 시간 복잡도를 가지는 휴리스틱 알고리즘
        - 서로 다른 타입을 가진 두 엘리먼트는 다른 트리를 만들어낸다.
        - 개발자가 key prop을 통해 자식 엘리먼트의 변경 여부를 표시할 수 있다.
- react key : [https://ko.react.dev/learn/rendering-lists#why-does-react-need-keys](https://ko.react.dev/learn/rendering-lists#why-does-react-need-keys)
    - 리액트는 list 에 변경 발생 시 위에서부터 비교 후 변경된 것들을 반영함.
    - 중간에 요소가 추가되었을 시 그 아래 것들은 모두 새로 만들게 되는데, key를 사용하면 key 가 같은 것들은 상태를 유지됨. (요소 내부의 상태 변화는 인식하여 리렌더링 한다)
    - key는 하나의 리스트 안에서 유일하면 됨.
    - index를 key로 사용하면 서로 다른 요소인데 key 가 같아서 업데이트가 발생하지 않는 경우가 있음. 리스트에 key를 안넣으면 index가 기본으로 사용됨
    - 리스트가 아니더라도 상태를 초기화하고 싶을때 사용할 수 있다
- 클라이언트 컴포넌트도 서버 렌더링이 먼저 된다
- React compiler : [https://ko.react.dev/learn/react-compiler](https://ko.react.dev/learn/react-compiler)
    - 리액크 메모이제이션을 자동으로 추가해줌
    - 실제 실험 결과
        - 초기 로딩 속도 크게 차이 안남.
        - 리렌더링 속도는 컴파일러 적용한게 훨씬 빠름
        - 개발자가 아예 신경쓰지 않아도 될 정도는 아님. 어느정도 개발자의 기술이 필요함
## web

- [[content/study/web/CSRF 공격과 예방방법|CSRF 공격과 예방방법]]
    - 사용자가 공격할 사이트에 대한 인증을 얻은 상태에서, 공격자가 의도치 않은 동작을 유도하는 공격
    - 링크를 클릭하게 하거나 img 태그에 링크를 넣는 방식이 있음
    - CSRF 토큰, CHAPTHA, Referer 체크, API 메서드 설정 등으로 예방 가능
- [[content/study/web/브라우저 렌더링 과정과 CSS 최적화|브라우저 렌더링 과정과 CSS 최적화]]
	- 브라우저 렌더링 과정 : 
	- CSS 최적화 : 
		- Reflow 와 Repaint 최소화
- CORS : [https://seongil-shin.github.io/posts/web-CORS/](https://seongil-shin.github.io/posts/web-CORS/)
    - SOP 정책 : 다른 출처의 리소스를 사용할 수 없는 것
    - SOP 예외 : CORS 정책을 지킨 요청
- Keep-alive : [https://seongil-shin.github.io/posts/web-keep-alive/](https://seongil-shin.github.io/posts/web-keep-alive/)
    - 한번 맺은 연결을 계속 사용할 수 있게 함
    - http/1.0에서는 별도로 지정해줘야함. http/1.1 에서는 디폴트임
    - http/2 부터는 multiplexing이 지원되기에 기본적으로 한 TCP 연결에서 여러 개의 요청과 응답을 동시에 전송할 수 있다. 따라서 keep-alive가 필요없다
- BF-Cache : [https://seongil-shin.github.io/posts/bfcache/](https://seongil-shin.github.io/posts/bfcache/)
    - 브라우저에서 이전/다음 이동 시 저장되는 cache. JS heap 까지 저장한다.
    - unload 이벤트, window.opener, `Cache-Control: no-store` 가 있으면 bfcache 비활성화됨
    - pageshow, pagehide 로 bfcache 관련 이벤트 감지 가능
- script async, defer
    - async : 다운로드 비동기, 다운 즉시 실행함. 스크립트간 실행 순서 보장 x
    - defer : 다운로드 비동기. HTML 파싱 종료 후 실행함. 스크립트간 실행순서 보장
- cookie, localstorage, sessionstorage 차이점
    - 공통점
    - 차이점
- cookie samesite : [https://velog.io/@rookieand/HTTP-Cookie-와-SameSite-정책에-대해서](https://velog.io/@rookieand/HTTP-Cookie-%EC%99%80-SameSite-%EC%A0%95%EC%B1%85%EC%97%90-%EB%8C%80%ED%95%B4%EC%84%9C)
    - 브라우저가 서드파티쿠키를 전송할 것이냐 아니냐에 대한 설정 (다른 출처에서의 요청에 쿠키 전송 여부)
        - 요청을 보낸 주소와 쿠키 domain 속성 비교
    - strict : 오직 동일 출처의 요청에서 생성된 퍼스트 파티 쿠키만을 전송한다.
    - lax : strict 과 같으나 유저가 링크를 직접 클릭하는 등은 제외
    - none : 다른 출처에서의 요청에도 전달함. 단 `secure` 설정이 되어있어야함
        - none으로 하면 어디서든 쿠키를 요청할 수 있어 네트워크 단에서 노출범위가 많아지기에 https 암호화가 필요한 것
- noopener, noreferer : [https://yozm.wishket.com/magazine/detail/1586/](https://yozm.wishket.com/magazine/detail/1586/)
    - noopener
        - `target="_blank"`로 연 페이지에서는 `window.opener`로 부모 페이지에 접근 가능하다. 따라서 만약 피싱 페이지로 이동하게 되면 부모 페이지를 피싱 페이지로 유도하는 식의 공격이 가능해진다
        - 이때 `rel="noopener"`로 설정해주면 `window.opener`를 사용할 수 없도록 할 수 있다
        - 최신 브라우저에서는 자동으로 noopener로 동작하기도 한다
    - noreferrer
        - 대상 페이지로 이동할 때 보내는 http 요청에 referer를 포함하지 않도록 하기 위한 설정
    - nofollow
        - 검색엔진에게 연결된 사이트를 신뢰할 수 없으므로 현재 웹사이트와 연결하지 말라고 알리는 용도

## next.js

- next.js 빌드 시스템
    - swc : next.js에서 사용중인 컴파일러. Rust를 사용하여 매우 빠르다
    - turbopack : rust 로 쓰여진 번들러. 버그가 있어서 사용하진 않고 있다


## K8s

- k8s readiness, liveness
    - readiness : 컨테이너가 실행 후 요청을 처리할 준비가 되어있는지 확인. 문제가 감지되면 해당 pod을 서비스에서 제외시킴
    - liveness : 컨테이너가 정상적으로 동작하는지 확인하여 문제가 감지되면 pod을 죽이고 재시작한다.
