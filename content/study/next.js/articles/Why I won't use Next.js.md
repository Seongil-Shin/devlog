https://www.epicweb.dev/why-i-wont-use-nextjs
### Summary  
🧐 여러 모던 프레임워크 중에서 선택해야 하는 상황에 대한 글.  
Remix와 Next.js를 비교하면서, Remix를 선호하는 이유 설명.  
  
### Facts  
- "모던" 프레임워크 선택에 대한 고민 상황과 프레임워크 학습의 중요성.  
- Remix는 2020년에 출시되었으며, 웹 애플리케이션 개발 문제 해결을 목표로 하는 풀 스택 웹 프레임워크.  
- Next.js와 비교하여 Remix를 선택하는 이유에 대한 설명.  

### 주장들
- 프레임워크가 웹 플랫폼을 적절하게 수용하는 중요성.  
	- next.js는 Web API를 한번 감싸서 줌, Remix는 비교적 직접적으로 개발자에게 제공함
	- 따라서 문제가 생겼을때 next.js는 next.js 문서를 봐야하지만, Remix는 MDN 문서를 봐도 됨
	- next.js로 개발하면 다른 프레임워크 등장 시 새로 배워야하지만, Remix로 개발하면 그 지식은 Web Standard 이기에 다른 곳에서도 쓸 수 있음
- Next.js의 제한된 호스팅 옵션과 Remix의 자유로운 호스팅 가능성 비교.
	- Next.js는 Vercel 외에 곳에서 배포할 때 어려움이 있다. Vercel은 Next.js를 Vercel에 호스팅하도록 하기위해 많은 공을 들였다. 따라서 Vercel 외에 곳에서 Next.js를 사용하는 건 사실 상 다른 프레임워크를 사용하는 것과 같다.
	- Remix는 JS가 실행가능하면 어디서든 배포가 쉽다
- React 팀과의 협력 부족에 대한 우려와 Next.js의 미래에 대한 의견.  
	- Next.js는 React의 실험적인 기능 위에 만들어진 기능으로 stable 하다고 배포하고 있다
- Too much magic
	- magic이 많으면 편할 수는 있지만, 무엇이 벌어지는지 명확히 알기 힘들 수 있다
	- magic 이 많아지면 웹 플랫폼에 악영향을 끼칠 수 있다. 
	- 문제가 생겼을때 next.js에서 덮어쓴 fetch와 web standard fetch를 모두 조사해야한다
- Next.js의 안정성 및 복잡성에 대한 비판적인 의견
	- next.js는 점차 복잡해지고 많은 기능을 제공하는데, remix는 API를 줄이려하고 있다
	- next.js는 나온지 얼마 안됐는데 벌써 버전 13인데 반해, Remix는 major version을 조심스럽게 업데이트하고 있다. 업그레이드를 생각하면서 업데이트하고 있다.