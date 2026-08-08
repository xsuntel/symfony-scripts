---
name: api-platform-style
description: API Platform 4.x / Symfony 8 — app/src/ApiResource/ · app/src/State/ 에 적용되는 스타일 가이드
keep-coding-instructions: true
---

# API Platform 스타일 가이드

이 문서는 **출력 표현·포매팅**을 규정한다. 코딩 표준(리소스 선언·operation·직렬화·State·검증·
보안·페이지네이션·필터·테스트)의 상세와 코드 예제는 규칙이 단일 출처(SoT)다 — 여기서 재서술하지 않는다.

@see .claude/rules/api/base/api-platform-rule.md — API Platform 표준(SoT)
@see .claude/rules/app/base/php-symfony/00-overview-rule.md — `## API Platform` 절
@see .claude/docs/api/base/api-platform-docs.md — 리소스·State 상세 예제

## 표준 준수 (요약)

- Doctrine `Entity`에 `#[ApiResource]`를 직접 붙이지 않는다 — 항상 `App\ApiResource\`의 DTO를 경유.
- operation을 **명시적 배열**로 지정 — 기본 세트에 암묵 의존 금지.
- 직렬화 그룹 명명: `{resource}:read`(응답) / `{resource}:write`(입력).
- State Provider/Processor는 `App\State\`에 두고 생성자 주입만 — 도메인 로직은 `Service`에 위임.
- 검증은 `#[Assert\...]`, 에러는 RFC 7807/Hydra 자동 직렬화 — 커스텀 에러 조립 금지. 상세는 위 규칙 참조.

## 명명 규칙 (PSR-1 / PSR-12)

| 심볼 | 규칙 | 예시 |
|------|------|------|
| 리소스 DTO | PascalCase + `Resource` | `BookResource` |
| State Provider | PascalCase + `Provider` | `BookProvider` |
| State Processor | PascalCase + `Processor` | `BookProcessor` |
| 직렬화 그룹 | `{resource}:read` / `{resource}:write` | `book:read`, `book:write` |
| 메서드 / 프로퍼티 | camelCase | `provide()`, `$title` |

## 파일 헤더 순서

모든 PHP 파일은 아래 순서를 정확히 따른다:

1. `<?php` → 빈 줄
2. `declare(strict_types=1);` → 빈 줄
3. `namespace App\ApiResource\...;` 또는 `namespace App\State\...;` → 빈 줄
4. `use` 구문 — 알파벳 순, 그룹 순서: PHP 내장 → Doctrine → **ApiPlatform(`ApiPlatform\*`)** →
   Symfony(`Symfony\*`) → App(`App\*`) → 빈 줄
5. 클래스 선언 (`final class ... Resource` / `final readonly class ... Provider`)

## 코드 블록 형식

- PHP 코드는 `php` 언어 식별자를 가진 펜스 코드 블록으로 감싼다.
- 파일 생성 시 블록 바로 앞에 `app/` 기준 전체 경로를 주석으로 명시한다:

```
// app/src/ApiResource/Company/BookResource.php
```

## 다중 파일 응답

여러 파일을 생성할 때, 각 블록 앞에 경로 주석을 명시하고 바로 다음에 전체 파일 내용을 잇는다.
리소스 세트는 **Resource(DTO) → State Provider/Processor → 관련 Exception** 순으로 배치한다.

## 인라인 설명 형식

코드 블록 뒤에는 아래 헤딩만 사용한다:

- **How it works** — operation·직렬화·State 흐름, 3~5개 항목
- **Why this way** — DTO 분리·State 위임 또는 성능 근거
- **Next steps** — `debug:api-resource`, 마이그레이션, 테스트 작성 등 (관련 있을 때만)

금지: "Here is the code:" 같은 전문, 작성 내용 요약, "Great question!"·"Certainly!" 같은 문구.

## 생성 코드의 주석 스타일

- 생성된 PHP에 블록 주석(`/* ... */`) 금지. 인라인 주석은 WHY가 자명하지 않을 때만.
- 네이티브 타입이 계약을 표현하면 `@param`/`@return` docblock 금지.
- operation 배열이 길면 각 operation 위에 한 줄 인라인 주석으로 의도(보안·URI 변수 등)를 표기.

## 테스트 코드 표현

- 기능 테스트는 `ApiPlatform\Symfony\Bundle\Test\ApiTestCase`를 상속(일반 `WebTestCase` 아님), 클래스는 `final`.
- item IRI는 `findIriBy(Resource::class, [...])`로 조회 — URL 하드코딩 금지.
- operation별 정상/검증 실패(422)/인가 거부 케이스를 커버 — 상세는 위 규칙의 `## 테스트` 절 참조.
