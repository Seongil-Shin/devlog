---
title: template
author: 신성일
date: 2025-01-23 19:00:00 +0900
categories: study
tags:
  - "#study"
---
https://velog.io/@k-svelte-master/nextjs-rsc-csr-ssr

서버컴포넌트
- SSR 로 렌더링 되며 하이드레이션 대상에서 제외됨
- 단순 HTML 스니펫이므로 클라이언트에서 이벤트 핸들러나 상태, hook 등의 사용이 불가능함.
- 하이드레이션을 위한 js 를 포함하지 않으므로 번들 사이즈를 줄이는데 도움을 준다

클라이언트 컴포넌트 ("use client")
- SSR로 렌더링 되며 하이드레이션 대상에 포함됨
- 리액트 컴포넌트이므로 이벤트 핸들러, 상태, hook 등의 사용이 가능함
- 서버컴포넌트가 없던 시절에는 SSR 되는 모든 것이 클라이언트 컴포넌트였음.

서버액션 ("use server")
- 클라이언트에서 서버 함수를 호출할 수 있도록 하는 방법
