---
name: twig-symfony-style
description: Twig 3.x / Symfony 8 — app/templates/ 전체 파일에 적용되는 스타일 가이드
keep-coding-instructions: true
---

# Twig 스타일 가이드

이 문서는 **출력 표현·포매팅**을 규정한다. 코딩 표준(상속·부분 템플릿·컴포넌트·자동
이스케이프·보안·성능)의 상세와 코드 예제는 규칙이 단일 출처(SoT)다 — 여기서 재서술하지 않는다.

@see .claude/rules/app/base/twig-symfony/00-overview-rule.md — Twig 템플릿 표준(SoT)
@see .claude/rules/app/base/php-symfony/07-template-rule.md — 명명·상속·컴포넌트(SoT)
@see .claude/docs/app/base/twig-symfony-docs.md — 문법·필터·함수 상세 예제

## 표준 준수 (요약)

- 파일명은 **snake_case**, 확장자는 2개(`{format}.twig`) — 예: `index.html.twig`, `report.xml.twig`.
- 템플릿 경로는 대응 컨트롤러 경로를 반영: `templates/{domain}/{subdomain}/{action}.html.twig`.
- include/embed 전용 부분 템플릿은 `_` 접두사 — 예: `_user_profile.html.twig`.
- 3단계 상속: `base.html.twig`(루트) → `{domain}/layout.html.twig`(섹션) → 페이지.
- 자동 이스케이프(`html`)는 항상 활성 유지. `|raw`는 신뢰된 서버 생성 HTML에만. 상세는 위 규칙 참조.

## 명명 규칙

| 심볼 | 규칙 | 예시 |
|------|------|------|
| 템플릿 파일 | snake_case + 2중 확장자 | `order_detail.html.twig` |
| 부분 템플릿 | `_` 접두 + snake_case | `_order_row.html.twig` |
| 블록 | snake_case | `{% block page_content %}` |
| 매크로 | snake_case | `{% macro form_row() %}` |
| Twig 변수 | snake_case (PHP 전달값과 일치) | `{{ created_at }}` |

## 포매팅

- 들여쓰기 2 스페이스(탭 금지), 줄 길이 소프트 제한 120자.
- 구문 구분자 내부에 공백 하나: `{{ value }}`, `{% if x %}` (`{{value}}`·`{%if x%}` 금지).
- 필터 체이닝은 파이프 앞뒤 공백 없이: `{{ title|upper|trim }}`.
- 여러 줄 태그·해시 인자 마지막 항목에 후행 쉼표.
- 중첩 블록·제어 구조는 여는 태그와 닫는 태그를 같은 들여쓰기 레벨로 정렬.

## 코드 블록 형식

- Twig 코드는 `twig` 언어 식별자를 가진 펜스 코드 블록으로 감싼다.
- 파일 생성 시 블록 바로 앞 첫 줄에 `templates/` 기준 전체 경로를 Twig 주석으로 명시한다:

```
{# templates/order/detail.html.twig #}
```

## 다중 파일 응답

여러 파일을 생성할 때, 각 블록 첫 줄에 경로 주석을 두고 바로 다음에 전체 파일 내용을 잇는다.
레이아웃·페이지·부분 템플릿을 함께 낼 때는 상속 상위(base/layout) → 하위(page/partial) 순으로 배치한다.

## 인라인 설명 형식

코드 블록 뒤에는 아래 헤딩만 사용한다:

- **How it works** — 템플릿이 렌더하는 것, 3~5개 항목
- **Why this way** — 상속·부분 템플릿 분리 또는 성능 근거
- **Next steps** — `lint:twig`, 컨트롤러 연결, 폼 테마 등록 등 (관련 있을 때만)

금지: "Here is the code:" 같은 전문, 작성 내용 요약, "Great question!"·"Certainly!" 같은 문구.

## 생성 템플릿의 관례

- 비즈니스 로직·집계·Repository 호출을 템플릿에 두지 않는다 — 데이터는 Controller/Extension이 준비.
- 반복 마크업은 `extends`/`block`·`include`/`embed`·`macro`로 제거한다.
- URL은 `path()`/`url()`, 정적 자산은 `asset()`로 참조 — 경로 하드코딩 금지.
- 디버그 출력(`{{ dump() }}`·`{% dump %}`)은 최종 산출물에 남기지 않는다.

## 테스트 코드 표현

- 렌더 검증은 Functional(WebTestCase)로 수행 — 렌더된 DOM(셀렉터·텍스트·응답 코드)을 assert.
- 문법·폐기 린트는 `lint:twig` / `lint:twig --show-deprecations`로 통과시킨다.
- 리뷰 지적 심각도는 `[MUST]` / `[SHOULD]` / `[CONSIDER]` — `[MUST]`만 머지 차단.
