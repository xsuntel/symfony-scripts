---
name: javascript-stimulus-style
description: ES Modules + Stimulus (Hotwire) — assets/controllers/ 전체 파일에 적용되는 스타일 가이드
keep-coding-instructions: true
---

# JavaScript 스타일 가이드

이 문서는 **출력 표현·포매팅**을 규정한다. 코딩 표준(모듈·변수·최신 문법·클래스 설계·Stimulus
관례·비동기 에러 처리)의 상세와 코드 예제는 규칙이 단일 출처(SoT)다 — 여기서 재서술하지 않는다.

@see .claude/rules/app/javascript-stimulus/00-overview-rule.md ~ 02-quality-rule.md — 코딩 표준(SoT)
@see .claude/rules/app/php-symfony/10-frontend-rule.md — AssetMapper·importmap·부트스트랩
@see .claude/docs/app/javascript-stimulus-docs.md — StimulusBundle 통합·컴포넌트 예제

## 표준 준수 (요약)

- ES Modules만(`import`/`export`), `const` 기본·`var` 금지, `async/await`(생 `.then()` 금지).
- 최신 문법(`?.`·`??`·논리 할당·구조 분해·스프레드·템플릿 리터럴·private `#field`).
- Stimulus: 하나의 컨트롤러=하나의 동작, `static targets/values/classes/outlets` 상단 선언,
  `connect()/disconnect()` 훅(`constructor` 금지), `this.*Target`(`document.querySelector` 금지),
  `{name}ValueChanged()`·outlet·`this.dispatch()` 사용. 상세·예제는 위 규칙 참조.
- 서드파티는 `importmap:require`(`<script src>`·`node_modules` import 금지), 상대 import에 `.js` 확장자, 경로 별칭 금지.

## 포매팅

- 세미콜론: **생략** (ES 모듈 내 ASI 신뢰).
- 따옴표: 문자열에 단따옴표 `'`, 템플릿 리터럴에 백틱.
- 들여쓰기: 2 스페이스. 줄 길이 소프트 제한 120자.
- 여러 줄 배열·객체에 후행 쉼표.
- 함수 본문 여는 중괄호 `{` 앞 공백, 이름과 `(` 사이 공백 없음.

## 코드 블록 형식

- JavaScript 코드는 `javascript` 언어 식별자를 가진 펜스 코드 블록으로 감싼다.
- 컨트롤러 파일 생성 시 블록 바로 앞에 `assets/` 기준 경로를 주석으로 명시한다:

```
// assets/controllers/toggle_controller.js
```

## 다중 파일 응답

여러 파일을 생성할 때, 파일당 경로 주석 하나를 여는 펜스 바로 앞에 두고 전체 파일 내용을 잇는다.

## 인라인 설명 형식

코드 블록 뒤에는 아래 헤딩만 사용한다:

- **How it works** — 코드가 하는 일, 3~5개 항목
- **Why this way** — 아키텍처 또는 성능 근거
- **Next steps** — `importmap:require`, Twig 연결 등 (관련 있을 때만)

금지: "Here is the code:" 같은 전문, 작성 내용 요약, "Great question!"·"Certainly!" 같은 문구.
