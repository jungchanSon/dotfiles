# 개인 LazyVim 설정

`~/.config/nvim` 전체를 Git으로 관리합니다. `lazy-lock.json`과 `lazyvim.json`도 포함합니다.
플러그인, 언어 서버 바이너리, 캐시, JDK는 저장소에 포함하지 않습니다.

## 다른 컴퓨터에 설치

기존 설정을 백업한 다음 저장소를 `~/.config/nvim`에 clone하고 `nvim`을 실행합니다.
Neovim은 현재 설정에서 사용하는 버전과 호환되는 최신 안정 버전을 설치하세요.
Git, ripgrep, fd, Nerd Font가 필요합니다. 프론트엔드 도구에는 Node.js도 준비하세요.
플러그인은 첫 실행에 설치됩니다. `:Lazy restore`로 잠금 파일의 버전을 복원할 수 있습니다.
`:checkhealth`와 `:LspInfo`로 도구 설치 및 서버 연결을 확인하세요.

## Kotlin

JetBrains 공식 kotlin-lsp를 별도 설치합니다. macOS Homebrew:

```sh
brew install JetBrains/utils/kotlin-lsp
```

다른 OS나 수동 설치는 https://github.com/Kotlin/kotlin-lsp 의 설치 안내를 따릅니다.
탐색 순서:

1. `KOTLIN_LSP_CMD`: 서버 실행 파일의 전체 경로 (인자 제외)
2. PATH의 `kotlin-lsp` 또는 `intellij-server` (Mason 경로 포함)
3. Neovim data 디렉터리의 형제 폴더 `kotlin-lsp/kotlin-server-*/bin/intellij-server`

3번은 이 컴퓨터의 기존 수동 설치와 호환되며 최신 버전을 우선합니다.
서버가 없으면 Kotlin LSP를 비활성화합니다. 설치 후 Neovim을 재시작하세요.
기존 `kotlin_language_server`는 비활성화되어 있습니다.

## Java

Java 언어 서버에는 JDK 25 이상을 준비합니다. 프로젝트의 빌드용 JDK와 별개입니다.
다음 순서에서 유효한 JDK 25 이상을 선택합니다.

1. `JDTLS_JAVA_HOME`
2. `JAVA_HOME`
3. macOS의 `/usr/libexec/java_home -v '25+'`
4. PATH의 `java`가 속한 JDK

예시 (사용하는 셸 설정에 추가):

```sh
export JDTLS_JAVA_HOME="$HOME/path/to/jdk-25"
export KOTLIN_LSP_CMD="$HOME/path/to/kotlin-lsp"
```

적합한 JDK를 찾지 못하면 jdtls의 기본 실행 환경을 유지합니다.
Java 서버가 실행되지 않으면 JDK 25 이상을 설치하고 `JDTLS_JAVA_HOME`을 지정하세요.

## 탐색기 사용자 기능

- Enter / l: 단일 하위 폴더 연속 펼치기
- 선택한 긴 파일명: 같은 줄에서 탐색기 경계 밖으로 확장 표시
- 기본 폭: 40칸

설정 파일: `lua/plugins/explorer.lua`
