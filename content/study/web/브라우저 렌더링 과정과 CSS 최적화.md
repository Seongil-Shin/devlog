---
title: 브라우저 렌더링 과정과 CSS 최적화
author: 신성일
date: 2025-01-24 19:00:00 +0900
categories: study, web
tags:
  - "#study"
  - review
---


## 브라우저의 주요 엔진

- 렌더링 엔진 
	- HTML, CSS, 이미지 등 웹 페에지에서 사용자가 볼 화면을 그려내는 역할
	- 업데이트 발생 시 효율적으로 렌더링할 수 있도록 자료구조를 생성함
	- 웹사이트의 어떤 요소가 어디에 어떤 크기, 색으로 배치되어야하는 등을 실시간으로 그려줌 
- 자바스크립트 엔진 
	- 자바스크립트를 읽어 실행하는 역할

## 렌더링

![](assets/images/Pasted%20image%2020250124221849.png)

1. 브라우저가 서버로부터 HTML, CSS 등을 모두 전달 받음
2. 렌더링 엔진은 HTML 문서를 파싱하여 DOM 트리를 구축함
3. CSS 파일 등 스타일요소를 파싱하여 CSSOM 트리를 만든다 (CSS Object Model)
4. DOM 트리와 CSSOM 트리를 합쳐 렌더 트리를 구축한다. 렌더 트리는 화면에 표시되어야할 모든 노드의 콘텐츠 스타일 정보를 포함하고 있는 트리이다. 이때 렌더 트리에는 `meta` 태그나 `display:none;` 등 렌더와 관계없는 요소를 포함하지 않는다. 
5. 렌더 트리의 요소들의 크기와 위치를 계산한다
6. 계산된 크기와 위치에 맞게 화면에 출력한다. 이 단계는 `Layout` - `Paint` - `Composite`의 세단계로 이루어진다.

![](assets/images/Pasted%20image%2020250124222428.png)


### Layout

뷰포트 내에서 요소들의 정확한 위치와 크기를 계산하는 과정

박스모델에 따라 텍스트나 요소의 박스가 화면에서 차지하는 영역이나 여백, 그 외 스타일 속성이 계산된다. `%`나 `rem`과 같은 상대적인 단위는 뷰포트에 맞춰서 픽셀 단위로 변환된다

레이아웃의 높이, 너비, 위치가 변화하거나 DOM에 추가/삭제 되면 Layout 단계부터 재시작되는 `Reflow`가 일어난다. (브라우저 창이 변경되었을때도 발생)

Reflow를 발생시키는 css 속성

| position    | display     | overflow       | width  | height |
| ----------- | ----------- | -------------- | ------ | ------ |
| min-width   | min-height  | padding        | margin | border |
| top         | bottom      | left           | right  | font   |
| white-space | line-height | vertical-align | float  | clear  |


### Paint

각 요소가 화면에 실제 픽셀로 그려지도록 변환하는 과정

렌더트리에 포함된 요소들이나 텍스트, 이미지들이 실제 픽셀로 그려진다. 
배경 이미지나 텍스트 색상, 그림자 등 레이아웃 수치를 변화시키지 않는 스타일의 변경이 발생했을 시 Paint 과정부터 재시작하는 `Repaint`가 일어난다

Repaint를 발생시키는 css 속성

| color         | background   | visibility | text-decoration |
| ------------- | ------------ | ---------- | --------------- |
| border-radius | border-style | box-shadow |                 |

### Composite

Layout, Paint 과정을 거치며 만들어진 레이어를 하나하나 그리면서 하나의 비트맵으로 합성하여 페이지를 완성하는 과정

Composite만 변경시키는 css 속성의 경우 Reflow, Repaint를 발생시키지 않기에 속도가 상대적으로 빠르다
- transform, opacity


## CSS 최적화

css 속성을 변경하며 애니메이션을 만들 시 다음과 같은 방법을 통해 성능을 끌어올릴 수 있다

### Reflow, Repaint 방지

가능한 렌더링 과정 중 뒷 단계인 Composite 단계의 속성을 변경하는 것이 좋다.
따라서 transform, opacity 등 composite 단계의 속성을 사용하여 애니메이션 만들기

### GPU 가속
`will-change`를 통한 GPU 가속을 사용할 수도 있다.

브라우저에게 예상되는 변화에 대한 힌트를 미리 제공하여 실제 요소가 변화되기 전에 브라우저가 적절하게 최적화할 수 있도록 하는 방법이다. 하지만 과도하게 사용할 경우 많은 기기 자원을 소모하기에 적절히 사용한다.



## 참고
- https://seongil-shin.github.io/posts/%EB%B8%8C%EB%9D%BC%EC%9A%B0%EC%A0%80-%EB%8F%99%EC%9E%91-%EC%9B%90%EB%A6%AC/
- https://seongil-shin.github.io/posts/css-%EC%B5%9C%EC%A0%81%ED%99%94/
- https://velog.io/@timosean/%EC%9B%B9-%EB%B8%8C%EB%9D%BC%EC%9A%B0%EC%A0%80%EC%9D%98-%EB%A0%8C%EB%8D%94%EB%A7%81Rendering-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0