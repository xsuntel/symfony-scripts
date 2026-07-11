---
name: php-symfony-style
description: PHP 8.4 / Symfony 8 — app/src/ 전체 파일에 적용되는 스타일 가이드
keep-coding-instructions: true
---

# PHP 스타일 가이드

이 문서는 **출력 표현·포매팅**을 규정한다. 코딩 표준(PHP 8.4 기능·타입 안전성·DI·attribute·
Doctrine·테스트 정책)의 상세와 코드 예제는 규칙이 단일 출처(SoT)다 — 여기서 재서술하지 않는다.

@see .claude/rules/app/php-symfony/00-overview-rule.md ~ 11-performance-rule.md — 코딩 표준(SoT)
@see .claude/docs/app/php-symfony-docs.md — 레이어별 코드 템플릿

## 표준 준수 (요약)

- **PSR-1 / PSR-4 / PSR-12** 준수. 네임스페이스는 `app/src/` 경로와 1:1.
- PHP 8.4 기능(생성자 프로모션·`readonly`·`match`·backed `enum`·property hooks·비대칭 가시성),
  타입 선언 필수(`mixed` 지양), 생성자 주입만 — 상세·예제는 위 규칙 참조.

## 명명 규칙 (PSR-1 / PSR-12)

| 심볼 | 규칙 | 예시 |
|------|------|------|
| 클래스 | PascalCase | `OrderStatusService` |
| 인터페이스 | PascalCase + `Interface` | `OrderRepositoryInterface` |
| 트레이트 | PascalCase + `Trait` | `TimestampableTrait` |
| 열거형 | PascalCase + `Enum` | `OrderStatusEnum` |
| 메서드 / 프로퍼티 / 변수 | camelCase | `findActiveOrders()`, `$createdAt` |
| 상수 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |

## 포매팅 규칙 (PSR-12)

- 들여쓰기 4 스페이스(탭 금지), 줄 길이 소프트 제한 120자, 한 줄에 하나의 구문.
- 여는 중괄호는 클래스/함수/제어 구조 키워드와 같은 줄, 닫는 중괄호는 별도 줄.
- 함수·메서드 이름과 여는 괄호 사이 공백 없음, 이진 연산자 앞뒤 공백 하나.
- 여러 줄 배열·인수 목록 마지막 항목에 후행 쉼표.
- 모든 프로퍼티·메서드에 가시성 선언. `abstract`/`final`은 가시성 앞, `static`은 가시성 뒤.

## 파일 헤더 순서

모든 PHP 파일은 아래 순서를 정확히 따른다:

1. `<?php` → 빈 줄
2. `declare(strict_types=1);` → 빈 줄
3. `namespace App\...;` → 빈 줄
4. `use` 구문 — 알파벳 순, 그룹 순서: PHP 내장 → Doctrine → Symfony(`Symfony\*`,`Twig\*`) → App(`App\*`) → 빈 줄
5. 클래스 선언

## 코드 블록 형식

- PHP 코드는 `php` 언어 식별자를 가진 펜스 코드 블록으로 감싼다.
- 파일 생성 시 블록 바로 앞에 `app/` 기준 전체 경로를 주석으로 명시한다:

```
// app/src/Entity/Domain/Name.php
```

## 다중 파일 응답

여러 파일을 생성할 때, 각 블록 앞에 경로 주석을 명시하고 바로 다음에 전체 파일 내용을 잇는다.

## 인라인 설명 형식

코드 블록 뒤에는 아래 헤딩만 사용한다:

- **How it works** — 코드가 하는 일, 3~5개 항목
- **Why this way** — 아키텍처 또는 성능 근거
- **Next steps** — 마이그레이션 명령, `debug:router` 등 (관련 있을 때만)

금지: "Here is the code:" 같은 전문, 작성 내용 요약, "Great question!"·"Certainly!" 같은 문구.

## 생성 코드의 주석 스타일

- 생성된 PHP에 블록 주석(`/* ... */`) 금지. 인라인 주석은 WHY가 자명하지 않을 때만.
- 네이티브 타입이 계약을 표현하면 `@param`/`@return` docblock 금지.
- 섹션 구분자는 아래 형식만 (긴 컨트롤러/핸들러 메서드에만):

```php
// -----------------------------------------------------------------------------------------------------------------
// Section Name
// -----------------------------------------------------------------------------------------------------------------
```

## 테스트 코드 표현

- PHPUnit 12 attribute(`#[Test]`,`#[DataProvider]`,`#[CoversClass]`)만 사용, 클래스는 `final`.
- 메서드명: `it_{behavior}()`(Unit/Integration), `test_{route}_{assertion}()`(Functional).
- 레이어 경계·모킹 정책 등 테스트 표준은 `.claude/rules/app/php-symfony/09-testing-rule.md` 참조.
