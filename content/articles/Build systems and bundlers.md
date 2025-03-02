https://github.com/orgs/web-infra-dev/discussions/24


## Build system

빌드 시스템은 여러 연속된 반복 작업을 자동으로 수행하는 소프트웨어 시스템이다. 주요 예시로는 Make, Shake, Bazel 이 있으며 Excel 이나 UI 프레임워크를 들 수도 있다.

이러한 것들로부터 공통된 컨셉을 찾을 수 있다
- Task : task descriptor에 의해 정의된 실제 로직. ex) makefile, excel 함수
- Input : task 의 input
- output : task 의 output. 다른 task의 input이 될 수 있음
- info : 빌드 사이에서 또는 다음 빌드에서 공유되고 사용되는 빌드 정보들. Make 에서는 파일 수정시간으로 번들러의 캐시로 사용된다.
- Store : input, output, info 가 저장되는 곳. Make에서는 파일시스템이다
- Build : 위 컨셉들을 기반으로, 빌드는 "정의된 Task와 현재 Store에 따라서 새로운 Input을 삽입하여 새로운 Store를 얻는 것"으로 간주할 수 있아

이러한 컨셉은 공통적이고, 다양한 빌드 시스템에서 상대적으로 비슷하게 구현된다. 하지만 빌드 시스템은 서로 다른데, 이는 다음 두 요인을 서로 다른 전략으로 차용하기 떄문이다
- Task를 재실행할 것인지 아닌지
- Task 실행 순서

이 두 요인은 Rebuilder와 Scheduler라는 비교적 중요한 개념에 해당된다. 서로 다른 빌드 시스템은 서로 다른 Rebuilder와 Scheduler의 조합으로 간주될 수 있다.


### Scheduler

Rebuilder 로 새로운 빌드를 수행하며 Task를 어떤 순서로 실행할지 결정한다
- Topological : task의 의존관계에 따라 topological sort를 수행하고, 그 결과를 기반으로 task를 수행한다
- Restarting : 실행할 task를 선택한다. 만약 task의 의존성이 완전히 실행되지 않았으면 다른 task를 실행하는 것을 모든 task가 실행완료될때까지 반복한다
- Suspending : 실행할 task를 선택한다.  만약 task의 의존성이 완전히 실행되지 않았으면 그 의존성을 먼저 실행한다. 이후 의존성들의 실행이 완료되면 선택한 그 task를 실행한다.

### Rebuilder

task를 재실행할 필요가 있는지, 재실행 결과나 캐시를 사용할 것인지 결정하며 Task를 어떻게 재실행 방법을 결정한다

- Dirty bit : 각 작업이 clean 한지 dirty 한지 체크한다. 빌드가 완료되면 모든 작업은 clean 하다. 다음 빌드 중에 변경된 input이 dirty로 표시되고 관련 task들은 재실행된다. 만약 input과 그 의존성들이 모두 clean 이면 그 input과 연동되는 task는 재실행될 필요가 없다.
- Verifying traces : 해시, 타임스탬프 등을 포함한 task 의존성에 관한 정보를 기록한다. 다음에 task를 실행할 때, 그 task의 의존성들이 변경되었는지 확인한다. 변경되었으면 그 task는 재실행된다. 그렇지 않으면 이전 결과가 재사용된다. 이는 캐시로 간주될 수 있으며, 기록된 해시나 타임스탬프는 캐시키이다. 
- Constructive taces : Verifying trace 에서 파생된 것으로 클라우드 캐싱을 사용한다. 차이점은 해시나 타임스탬프와 같은 가벼운 정보를 기록 하는 것 외에도 실제 콘텐츠를 기록한다는 것이다. 이 방법을 통해 trace가 네트워크로 전송될 때, 실제 컨텐츠가 전송된다. 따라서 클라우드 캐싱과 원격 task 실행이 실현된다.


## Build Systems

공통된 특징
- Dynamic dependencies : 어떤 Task가 의존하고 있는 Task가 정적으로 선언되어있는지 동적으로 계산되는지 여부. ex) makefile은 정적으로 의존관계를 파악하고, excel 함수는 동적으로 결정된다. 
- Minimality : 빌드에 필요한 최소한의 task 만을 실행한다. 물론 이 기준은 각자 다를 수 있다
- Early cutoff : task가 재실행되고 output이 변하지 않았을때, 이 task에 의존하는 다른 task의 실행을 중지할 수 있다.


### Make

> make = topological modTimeRebuilder

Make는 makefile로 task를 묘사한다. 의존성관계는 명확한데, 정적 의존성을 가지며 순환 의존성을 지원하지 않는다. 따라서 Make는 topological scheduler를 사용한다.

Make의 build info는 파일시스템 그 자체이다. 파일시스템에는 파일 수정 시간이 있고, Make는 그 수정 시간을 가지고 task를 재실행할지 결정한다. Make는 파일 수정시간을 dirty bit로 다루고 이는 dirty bit rebuilder의 일종이다.

물론 파일 변경 시간은 신뢰가능한 값은 아니다. 어떤 경우에서는 내용이 바뀐게 없어서 수정 시간이 변경될 수 있다. 

Make는 modTimeRebuilder로 재실행하지 않아도 될 task를 스킵함으로써 minimality를 챙긴다. 다만 modTimeRebuilder 때문에 Early cutoff에는 실패한다. 왜냐면 task가 재실행되고 새로운 output을 만들었을때 실제 내용은 바뀌지 않더라도 파일 수정 시간은 변경되기 때문이다. 따라서 Early cutoff는 달성될 수 없고, 이를 통해 Make는 최소한의 작업만을 수행한다고 보장할 수는 없다

### Excel

> excel = restarting dirtyBitRebuilder

엑셀은 셀 안에 함수로써 task를 묘사한다. 몇몇 함수는 정적 의존관계를 가지지만 몇몇은 동적이다. 따라서 엑셀은 restarting scheduler를 사용한다. 여기서 엑셀은 다음 빌드의 재실행 오버헤드를 줄이기위해 마지막 실행 순서를 기억해둔다.

엑셀은 dirty bit rebuilder 를 사용한다. 변경된 셀이 dirty로 표시되면 그 셀에 의존한 task들이 재실행된다. 또한 엑셀은 동적 의존관계를 가진 함수들을 각 빌드마다 dirty로 표시하고 매번 업데이트한다. 이는 성능을 포기하고 정확성을 위한 작업이다

엑셀은 minimality를 정적 의존관계에서는 달성되지만, 동적 의존 관계에서는 달성되지 않는다

### Bazel

> bazel = restarting ctRebuilder

Bazel도 restarting overhead를 줄이기 위해 restarting scheduler를 사용한다. 또한 ctRebuilder를 사용해 클라우드 캐싱과 원격 태스크 실행을 지원한다

### Shake

> shake = suspending vtRebuilder

vtRebuilder 를 사용하여 task가 실행되었을때 의존관계를 따라 그것들을 기록한다. 그리고 다음번에 실행되었을때 그 의존관계가 변하지 않았으면 실행을 스킵한다.

또한 현재 task가 실행되지 않았으면 현재 task에 의존한 task들도 실행하지 않는다. (의존관계가 변경되지 않는한) 이로써 minimality와 early cutoff가 달성된다

Shake는 task가 실행되었을때 의존성을 트래킹하고 사전에 정적으로 정의할 필요가 없기에, 동적 의존관계도 지원한다

### Cloud Shake

> cloudShake = suspending ctRebuilder

Shake를 기반으로 클라우드 캐싱을 지원하는 빌더이다

### Buck2

> buck2 = suspending ctRebuilder

Cloud Shake와 비슷하다. 동적 의존관계를 지원하며 minimality와 early cutoff, 클라우드 캐싱과 원격 태스크 실행을 지원한다.

## Bundlers

번들러는 빌드시스템에 task descriptor 일부의 조합으로 설명할 수 있다. 사실 빌드 시스템은 특정 task가 어떤 작업을 하는지 신경쓰지 않는다. 특정 task가 하는 작업은 유저에게 task description file을 통해 전달 된다. 그리고 빌드 시스템은 단지 task를 실행하는 것에만 집중한다. Gulp, Grunt와 같은 초창기 task runner는 빌드시스템에 가까웠다. 개발자는 이러한 task runner를 통해 파일 프로세싱 로직을 준비하고 task runner를 빌드시스템으로써 간주했다. 비슷하게 Turborepo는 task logic을 신경쓰지 않고 task를 실행시키는 것에만 집중한다


번들러는 그 자체로 task logic 의 일부를 묘사한다. 어떻게 모듈을 빌드할지, chunk를 분리할지, 최적화할지 등을 표현한다. 그리고 나머지는 유저 설정이나 플러그인으로 제공되며 이것들이 합쳐서 완전한 task descriptor가 된다

여기서 몇가지 번들러와 빌드 시스템의 task 간에 차이가 있다
- 번들러 task의 의존성은 매우 동적이다. task logic 그 자체가 동적이다. 예를들어 한 모듈의 코드 생성은 다른 모듈의 결과에 의존하고, 한 모듈의 최적화는 다른 모듈의 최적화 결과에 의존한다. 또한 유저 설정과 플러그인도 task logic에 영향을 줄 수 있다. 하지만 초기 빌드 시스템은 동적 의존성을 잘 지원하지 않았고, 정적 의존성에 기반을 두었다. (최근에는 동적 의존성도 잘 지원한다)
- loop 를 다루는 방법이 다르다. 모듈 사이의 관계때문에 번들러는 종종 순회 의존성을 가진다. 따라서 번들러는 이러한 loop를 다루는 방법을 지원해야하지만, 대부분의 빌드 시스템은 loop를 지원하지 않는다.

또한 Build를 표준대로 빌드 시스템에서 정의한다면, bundler의 Build는 두 타입으로 나뉜다
- 컴파일러를 방해하지 않는 Build, watch mode 에서의 리빌드이다
- 컴파일러를 방해하는 Build, 이전 빌드가 완료된 후에 리빌드한다.

이러한 두 타입의 Build는 메모리 캐시, 영구 캐시라는 두가지 다른 종류의 info를 생성한다. 이 두 info는 단독으로 사용될 수 있고 특정 시나리오에서는 혼합되어 사용될 수 있다

### Webpack/Parcel/Rollup/esbuild

> passBasedBundler = foreach ctRebuilder

전통적인 pass-based bundler에서는 task의 실행 순서(Scheduler)와 task를 실행할지 말지 결정하는 것(Rebuilder)는 매 pass 마다 다르다. 매 pass는 task 실행 순서와 실행 전략은 현재 stage의 task logic에 맞춰진다

예를들어 webpack에서는
- module graph 와 chunk graph 가 비순환 그래프가 아니기에 topological scheduler가 대부분의 stage에서는 사용될 수 없다
- SideEffectsFlagPlugin : module의 수신 연결을 최적화할때, 이 모듈의 부모 모듈의 수신연결이 이미 최적화되었는지 보장해야한다. 이는 suspending scheduler에 속하지만 모듈 관계의 연결만을 업데이트하고, 크지 않은 계산 오버헤드를 가진다. 따라서 "always true"인 task 실행을 스킵할 수 있는 로직은 없다
- FlagProvidedExportsPlugin : re-export는 export 된 모듈의 컨텐츠에 영향을 끼치기에, re-exports를 포함한 모듈과 re-exports를 사용하는 모듈은 의존 관계로 기록된다. re-exports를 사용하는 모듈의 export된 컨텐츠가 변경되었을때는 re-exports를 포함하는 모듈의 export된 컨텐츠는 모듈의 export 된 컨텐츠에 변화가 없을때까지 재계산된다.  이는 restarting scheduler에 포함된다. export 된 컨텐츠를 계산하는 것은 어느정도 부하가 있기에 몇몇 작업을 스킵하기 위해 cache가 사용될 수 있고 이는 vtRebuilder에 속한다
- 대부분의 다른 stage에서 task logic은 module build, module codegen과 같은 task 순서를 신경쓰지 않고 영구 캐시가 지원된다. 따라서 대부분의 다른 pass에서는 `foreach` scheduler와 ctRebuilder의 조합이 사용된다

pass-based bundler에서는 cache로 minimality를 구현한다. 하지만 서로 다른 pass에서 task는 서로를 모르기에 서로 다른 pass에서 task는 early cutoff를 달성하지 못하고, 이는 캐시 검증이 필요한 작업이 과도하게 발생하기에 이른다. 이는 종종 pass-based bundler가 느려지는 원인이 된다. (the failure to achieve Early cutoff leads to a lack of Minimality.)


### Turbopack

> turbopack = suspending ctRebuilder

전통적인 pass-based bundler 과 다르게, Turpopack은 처음부터 끝까지 개별 컴파일 단계(pass)를 강조하지 않는다. 대신에 query-based에 가깝다. task 정의, task 결과를 query를 통해 정의한다.

pass-based bundlers 와 비교해서 turbopack은 오로지 query 결과를 얻기위해 실행해야하는 일부 task에만 집중하고 다른 작업은 실행하지 않는다. 특히 개발환경에서는 완전한 ModuleGraph, ChunkGraph가 없다. 프로덕션에서는 완전한 그래프로 집계하여 전체 ModuleGraph/ ChunkGraph에 대한 전역 최적화를 수행하는데 계속 사용된다.

turbo task로 알려진 turbopack의 incremental computation engine은 turbopack을 구동하는 빌드 시스템이다. task, scheduler, rebuilder와 같은 빌드시스템 컨셉은 turbo task 안에서 구현된다. Turbopack의 상위 레이어는 turbo task을 기반으로 번들러의 특정 작업을 설명하는 것과 같다. 이 관점에서 incremental computation engine 그 자체는 빌드 시스템과 같다. incremental computation engine인 DICE에 기반을 둔 Buck2 도 비슷하다. DICE는 이미 빌드 시스템에서 핵심 함수를 다루었고, Buck2는 유저에 의해 설명된 task 실핼을 DICE의 task로써 구현한다.

turbopack은 전체적으로 turbo task을 기반으로 하며, Suspending과 ctRebuilder를 조합하여 전체적인 Minimality와 early cutoff를 달성한다


### Vite

> vite = suspending vtRebuilder

vite 그 자체는 번들링을 하지 않지만, vite는 빌드 시스템의 정의에 따라 개발 과정에서 연속적으로 task를 실행한다. vite는 여러 모듈을 패키지 하지 않고 각 모듈 자체를 컴파일한다. 그래서 vite의 task logic은 모듈을 컴파일한다는 상당히 심플한 것이다. vite는 오직 브라우저가 요청할때만 모듈을 빌드한다. 해당 요청은 브라우저에 캐시가 없을때면 발동된다. 요청의 순서는 모듈 import의 순서이고, 이는 브라우저에서 결정된다. 따라서 Vite는 Suspending과 vtRebuilder를 조합한 자체 빌드 시스템의 일부로 브라우저의 ESM 모듈 시스템을 활용한다는 것을 알 수 있다

브라우저의 ESM 모듈 시스템을 활용하는 것은 구현을 심플하게 만들어주지만, 브라우저 ESM 모듈 시스템 그자체는 빌드 시스템의 목표로 구현된 것은 아니다. 따라서 실제 빌드 시스템에 비해 몇가지 제한이 있다
- 동시에 요청가능한 개수는 브라우저에의해 제한된다. task와 리소스 종속 관계외에도 동시 task 수는 브라우저에 의해 제한된다
- 브라우저 캐시는 공유되지 않는다. build information과 task cache는 공유되지 않고 브라우저는 vtRebuilder가 ctRebuilder로 바꾸지 못하도록 제한된다.

### Rspack

> incrementalRspack = foreach dirtyBitAndCtBuilder

Rspack 자체는 pass-based bundler에 속한다. 하지만 Hot Module Replacement의 성능을 최적화하기 위해 Rspack은 affected-based incremental을 도입했다. 짧게 말하면 affected-based incremental은 다양한 stage에서 변경을 모으고, 다음 stage는 모아진 변경 사항을 기반으로 영향을 받는 task를 계산한다. 그래서 영향을 받는 task만 재실행한다.

빌드시스템 관점에서 affected-based incremental은 pass-based bundler의 빌드 시스템을 기반으로, 다양한 stage 사이에서 변경사항을 모으고 후속 stage에서 early cutoff를 달성하는 새로운 Rebuilder이다. Early cutoff를 얻기위해 Rspack는 Minimality를 더했다. 이 접근법은 self-adjusting computation에 가깝다. 

변경사항에서 영향을 받는 input을 찾고, 상응하는 task를 재실행하는 것은 dirty input으로 간주된다. 이러한 구현은 incremental computation 보다 덜 지능적이지만 비교적 간단하고 효과적인 방법이다


## Summary

![](assets/images/Pasted%20image%2020250221200403.png)

많은 번들러는 자신을 차세대 번들러라고 주장한다. 하지만 빌드 시스템을 기반으로 한 task 실행의 관점에서 봤을때 대부분은 사실 현존하는 빌드 시스템 대비 크게 장점이나 다른 점이 부족하다. 이러한 많은 훌륭한 기능들이 번들러에 통합된 것이다

- Minimality : rebuild 성능에 큰 영향을 끼침
- Early cutoff : minimality에 영향을 끼침. early cutoff를 구현한 번들러는 안한 번들러보다 좀 더 minimality를 지킨다
- Parallelism : task 사이에 의존관계가 명확해지면 task는 가능한 동시에 실행될 수 있다. suspending은 종종 async/await를 사용해 동시성을 확보한다
- Remote Cache 
- Remote Execution