---
name: code-config-style
description: 쉘 스크립트 작성 및 리뷰에 특화된 스타일. 안전성·이식성·가독성을 우선시한다.
keep-coding-instructions: true
---

# Shell Scripts 출력 스타일

이 스타일은 `scripts/` 디렉터리의 Bash 스크립트를 작성하거나 검토할 때 적용된다.
코드의 **안전성(safety)**, **이식성(portability)**, **가독성(readability)** 을 항상 최우선 기준으로 삼는다.

---

## 응답 형식

- 코드 블록은 반드시 언어 식별자를 명시한다: ` ```bash ` 또는 ` ```sh `
- 스크립트 전체를 제공할 때는 파일 상단에 shebang과 설명 주석을 포함한다
- 스크립트 수정 시에는 변경 전/후를 명확히 구분하여 표시한다
- 위험하거나 주의가 필요한 명령은 코드 블록 아래에 `> ⚠️ 주의:` 형식으로 경고를 표시한다

---

## 코딩 규칙

### Shebang 선택 기준

| 스크립트 유형 | Shebang |
| ------------- | --------- |
| 일반 프로젝트 스크립트 (`deploy.sh`, `cache.sh` 등) | `#!/bin/bash` |
| 컨테이너 엔트리포인트 (`entrypoint.sh`) | `#!/bin/sh` |
| 이식성이 중요한 스크립트 (POSIX 전용) | `#!/bin/sh` |

`#!/usr/bin/env bash`는 사용하지 않는다 — 모든 대상 환경에 Bash 경로가 고정되어 있다.

### 헤더 형식

모든 스크립트는 아래 헤더 구조를 따른다:

```bash
#!/bin/bash

#set -euo pipefail
# ----------------------------------------------------------------------------------------------------------------------
# Scripts - {Category} - {Sub-Category} - {Description}
# ----------------------------------------------------------------------------------------------------------------------
```

`set -euo pipefail` 줄은 모든 프로젝트 스크립트에서 **의도적으로 주석 처리**한다.

> ⚠️ **`set -euo pipefail`을 비활성화하는 이유**: 이 프로젝트는 하위 스크립트를 서브셸에서 실행하지 않고
> `source`로 불러오는 모듈형 아키텍처를 사용한다. `set -u`를 활성화하면 나중에 로딩되는 다른 소싱된
> 스크립트가 선언한 변수에 대해 거짓 양성(false positive)이 발생한다. 대화형 `select` 메뉴도
> `set -e` 아래에서 오작동한다. 주석 처리된 줄은 이 결정이 잊힌 것이 아니라 의도적임을 나타내는
> 가시적 표시로 유지한다.

다른 스크립트를 소싱하지 않고 대화형 메뉴를 사용하지 않는 독립 유틸리티 스크립트에서는
`set -euo pipefail`을 **활성화할 수 있다**:

```bash
#!/bin/bash
# ----------------------------------------------------------------------------------------------------------------------
# Scripts - Utility - {Description}
# ----------------------------------------------------------------------------------------------------------------------
set -euo pipefail
IFS=$'\n\t'
```

### 섹션 구분자

세 가지 너비의 구분자를 사용한다 — 118자가 이 프로젝트의 표준 줄 길이다:

```bash
# ----------------------------------------------------------------------------------------------------------------------
# 주요 섹션 (최상위 스크립트 구분)
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# 하위 섹션 (함수 내부 컴포넌트 블록)
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Category - Item (명령어 그룹의 인라인 레이블)
```

### 변수 규칙

```bash
# Global constants — UPPER_CASE + underscore
PLATFORM_TYPE=$(uname -s)
PLATFORM_PROCESSOR=$(uname -m)
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Local variables inside functions — UPPER_CASE + underscore (project convention)
# Note: use 'local' to scope; always quote when expanding
local SUPERVISOR_STATUS
SUPERVISOR_STATUS=$(systemctl is-active supervisord)

# Always quote variable expansions
echo "${SUPERVISOR_STATUS}"
cp "${source_file}" "${dest_dir}/"

# Safe rm -rf: use :? to guard against empty variable
rm -rf "${BUILD_DIR:?BUILD_DIR is not set}"
```

### 함수 명명 규칙

이 프로젝트는 컨텍스트에 따라 **두 가지 명명 규칙**을 사용한다 — 상황에 맞는 규칙을 적용한다:

| 규칙 | 사용처 | 예시 |
|------|--------|------|
| `camelCase` | 배포 단계를 조율하는 라이프사이클 함수 | `setStart`, `setEnd`, `setExit`, `setEnvironment`, `setPlatform`, `setProject`, `setPhp`, `setRedis`, `setNginx`, `setBuild`, `setDocker`, `setUtility`, `setTools` |
| `snake_case` | 재사용 가능한 로직을 위한 유틸리티/헬퍼 함수 | `find_project_root`, `log_info`, `log_error`, `cleanup` |

```bash
# Lifecycle phase function (camelCase)
setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  if [ -f "${PROJECT_PATH}/scripts/base/app/php/base/_install.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/app/php/base/_install.sh"
  else
    echo "Please check a file : ./scripts/base/app/php/base/_install.sh" && exit
  fi
}

# Utility helper function (snake_case)
log_error() {
  local message="$1"
  echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') — ${message}" >&2
}
```

### 라이프사이클 구조

모든 최상위 스크립트(`deploy.sh`, `cache.sh`, `status.sh` 등)는 아래 고정 순서를 따른다:

```bash
# ----------------------------------------------------------------------------------------------------------------------
# START
# ----------------------------------------------------------------------------------------------------------------------

setStart          # Print start banner with timestamp

# Abstract
setEnvironment    # Select dev/prod via interactive menu
setPlatform       # Detect and configure OS-specific settings
setProject        # Source .env.app and prepare project directories

# Architecture (enable the components this script needs)
setPhp
#setRedis
#setPostgreSQL
#setRabbitMQ
#setNginx

# Build
setBuild

# Docker
setDocker

# Providers
#setProvider

# Utility
setUtility

# Tools
setTools

# ----------------------------------------------------------------------------------------------------------------------
# END
# ----------------------------------------------------------------------------------------------------------------------

setEnd            # Unset all exported variables and print end banner
```

필요하지 않은 단계 함수는 삭제하지 않고 주석 처리한다 — 이것이 단계를 건너뛰는 표준 방법이다.

### 프로젝트 루트 탐색

모든 최상위 스크립트는 `_abstract.sh`를 소싱하기 전에 저장소 루트를 찾아야 한다. 아래 표준 함수를 사용한다:

```bash
find_project_root() {
    local PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    while [[ "${PROJECT_DIR}" != "/" ]]; do
        if [[ -d "${PROJECT_DIR}/.git" ]] || [[ -f "${PROJECT_DIR}/.env.app" ]]; then
            echo "${PROJECT_DIR}"
            return 0
        fi
        PROJECT_DIR="$(dirname "${PROJECT_DIR}")"
    done
    return 1
}

PROJECT_PATH=$(find_project_root)
PROJECT_NAME=$(basename "$(realpath "${PROJECT_PATH}")")
cd "${PROJECT_PATH}" || exit
```

### 추상 스크립트 소싱

프로젝트 루트를 탐색한 **직후** `_abstract.sh`를 소싱한다 — `setStart`, `setEnd`, `setExit`,
`PLATFORM_TYPE`, `PLATFORM_PROCESSOR`를 정의한다:

```bash
if [ -f "${PROJECT_PATH}/scripts/base/_abstract.sh" ]; then
  source "${PROJECT_PATH}/scripts/base/_abstract.sh"
else
  echo "Please check a file : ./scripts/base/_abstract.sh" && exit
fi
```

**소싱되는 모든 스크립트**에 동일한 가드 패턴을 적용한다 — bare `source` 금지:

```bash
if [ -f "${PROJECT_PATH}/scripts/base/_platform.sh" ]; then
  source "${PROJECT_PATH}/scripts/base/_platform.sh"
else
  echo "Please check a file : ./scripts/base/_platform.sh" && exit
fi
```

### 다중 플랫폼 분기

플랫폼에 민감한 모든 코드는 `_abstract.sh`가 설정한 `PLATFORM_TYPE`으로 분기해야 한다:

```bash
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux
  # --------------------------------------------------------------------------------------------------------------------
  ...

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Mac - OS
  # --------------------------------------------------------------------------------------------------------------------
  ...

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows - WSL2
  # --------------------------------------------------------------------------------------------------------------------
  ...

else
  echo "Please check Operating System"
  setExit
fi
```

### 에러 처리

```bash
# Guard missing command
command -v rsync &>/dev/null || { log_error "rsync is not installed."; exit 1; }

# Guard missing directory
[[ -d "${TARGET_DIR}" ]] || { log_error "Directory not found: ${TARGET_DIR}"; exit 1; }

# Guard unset required variable — preferred over bare exit
[[ -n "${ENVIRONMENT_NAME}" ]] || { echo "Error: ENVIRONMENT_NAME is not set."; exit 1; }

# setExit — call when a fatal condition is detected inside a source'd script
# Uses kill -SIGKILL $$ to terminate the parent shell that sourced this script.
# Do NOT use plain 'exit' inside sourced sub-scripts; it would only exit the subshell.
setExit
```

> ⚠️ `setExit`은 의도적으로 `kill -SIGKILL $$`를 호출한다. 하위 스크립트가 부모 셸에 `source`로
> 로딩된 경우, 일반 `exit`은 현재 함수 스코프만 종료한다. `kill -SIGKILL $$`는 소싱 부모 셸의
> PID에 SIGKILL을 전송하여 전체 스크립트 트리가 확실히 중단된다.
> 복구 불가능한 오류에만 `setExit`을 사용한다.

### 대화형 환경 메뉴

```bash
setEnvironment() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ENV ] ${PLATFORM_TYPE} - ${PLATFORM_PROCESSOR}"
  echo -e "----------------------------------------------------------------------------------------------------------\n"

  PS3="Menu: "
  select num in "dev" "prod" "exit"; do
    case "$REPLY" in
    1)
      ENVIRONMENT_NAME="dev"
      break
      ;;
    2)
      ENVIRONMENT_NAME="prod"
      break
      ;;
    3)
      echo "exit()"
      setEnd
      ;;
    *)
      echo "[ ERROR ] Unknown Command"
      setEnd
      ;;
    esac
  done
  echo
}
```

### 인자 처리

```bash
function usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -d, --dir <path>    Target directory (default: /tmp)
  -v, --verbose       Verbose output
  -h, --help          Show this help
EOF
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -d|--dir)   TARGET_DIR="$2"; shift 2 ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -h|--help)  usage; exit 0 ;;
        *) echo "[ ERROR ] Unknown option: $1"; usage; exit 1 ;;
    esac
done
```

---

## ShellCheck 설정

프로젝트에는 아래 규칙이 비활성화된 `scripts/.shellcheckrc`가 포함되어 있다:

| 코드 | 비활성화 이유 |
| ------ | ------------- |
| `SC2034` | 라이브러리 스크립트에서 설정된 변수는 소싱하는 부모가 사용 — ShellCheck에서는 "미사용"으로 보임 |
| `SC2168` | 이름 있는 함수 외부에서 실행되는 소싱된 하위 스크립트에서 `local` 사용 (예: `_platform.sh`) |
| `SC1091` | 소스 경로가 동적(`${PROJECT_PATH}/…`)이어서 lint 시점에 해석 불가 |
| `SC2155` | 한 줄에 선언과 할당 — 이 코드베이스에서 가독성을 위해 허용 |
| `SC2225` | 이 프로젝트에서 사용되는 복합 명령어에 한정 |
| `SC2024` | 출력 리다이렉션과 `sudo` (설치 스크립트에서 의도적) |

새 스크립트를 커밋하기 전에 항상 `shellcheck`을 실행한다:

```bash
shellcheck scripts/deploy/dev/linux/ubuntu/deploy.sh
```

---

## 이식성 가이드라인

- **Shebang**: 프로젝트 스크립트에 `#!/bin/bash`; Docker 엔트리포인트에만 `#!/bin/sh`
- **Bash 4+ 기능** (`associative array`, `mapfile`): 사용 시 최소 버전을 명시
- macOS와 Linux 명령어 차이:
  - `sed -i ''` (macOS) vs `sed -i` (Linux) → 크로스 플랫폼에는 `perl -pi -e` 선호
  - `date -d` (GNU)는 macOS에서 사용 불가 → 필요 시 `python3 -c "from datetime import …"` 사용
- macOS에서 GNU coreutils를 가정하지 않는다 — 멀티 플랫폼 스크립트 수정 시 양 플랫폼에서 테스트

---

## 보안 체크리스트

스크립트를 제안하거나 리뷰할 때 아래 항목을 자동으로 검토한다:

- [ ] 외부 입력 (인자, 환경 변수)은 사용 전 검증됨
- [ ] `eval` 금지; 불가피한 경우 명시적으로 표시
- [ ] 임시 파일은 `mktemp`로 생성, `trap`으로 정리
- [ ] 시크릿 (비밀번호, 토큰)은 환경 변수 또는 `.env.app`에서 읽음 — 하드코딩 금지
- [ ] 스크립트 권한: `chmod 700` 또는 `chmod 750`
- [ ] 변수를 사용하는 `rm -rf`는 항상 `${VAR:?}` 가드 사용

```bash
# Safe rm -rf pattern
rm -rf "${BUILD_DIR:?BUILD_DIR is not set}"
```

---

## 주석 규칙

```bash
# ── Section separator (major block) ─────────────────────────────────────────

# >>>> Category - Sub-item (inline group label)

# TODO: items that need future improvement
# FIXME: known bugs or temporary workarounds
# NOTE: non-obvious behavior that would surprise a reader
```

---

## 안티패턴

다음 패턴이 발견되면 반드시 지적하고 안전한 대안을 제시한다:

| 안티패턴 | 이유 | 대안 |
| --------- | ------ | ------ |
| `cat file \| grep` | 불필요한 cat 사용 | `grep pattern file` 또는 `< file grep pattern` |
| `cat file \| cmd` | 불필요한 cat 사용 | `cmd < file` |
| `rm -rf /` 또는 가드 없는 `rm -rf "${VAR}"` | 전체 파일 시스템 삭제 가능 | `rm -rf "${VAR:?}"` |
| `ls \| grep` | 공백과 특수문자에서 오작동 | `find` + `-name` |
| 따옴표 없는 `[[ $var == *foo* ]]` | 단어 분리 위험 | 항상 큰따옴표: `[[ "$var" == *foo* ]]` |
| `export VAR=password123` | 프로세스 목록에 시크릿 노출 | `.env.app`에서 읽거나 `read -s` 사용 |
| 광범위한 `2>/dev/null` | 에러를 조용히 숨김 | 명시적 에러 처리 |
| 존재 여부 확인 없는 `source` | 파일 없을 시 조용히 실패 | 위의 가드된 소스 패턴 사용 |

---

## 응답 구조

스크립트를 제공할 때는 아래 순서로 응답한다:

1. **목적 한 줄 요약** — 스크립트가 무엇을 하는지
2. **사전 요구사항** — 필요한 도구, 권한, 환경변수
3. **스크립트 코드 블록** — 완전한 실행 가능 코드
4. **실행 방법** — `chmod +x`, 실행 명령 예시
5. **주의사항** (해당 시) — 부작용, 롤백 방법, 환경 의존성
