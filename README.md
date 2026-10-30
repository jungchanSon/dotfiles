# dotfiles

macOS 개발 환경 설정. LazyVim 설정과 기본 개발 도구를 한곳에서 관리합니다.

## 설치

```sh
git clone https://github.com/jungchanSon/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run
./install.sh
```

설치 스크립트는 Homebrew가 없으면 공식 설치 스크립트를 실행하고,
Brewfile의 패키지를 설치한 뒤 설정을 심볼릭 링크로 연결합니다.
Command Line Tools 설치 및 일부 패키지는 관리자 암호 입력이 필요할 수 있습니다.
설정만 연결하려면 `./install.sh --skip-brew`를 사용하세요.

- 기존 설정은 `~/.local/state/dotfiles/backups/`에 백업합니다.
- 같은 저장소 경로로 다시 실행하면 기존 링크를 유지합니다.
- 기본 설정 위치는 `~/.config`이며 `XDG_CONFIG_HOME`도 지원합니다.
- 저장소를 옮기면 설치 스크립트를 다시 실행해 링크를 갱신하세요.
- Homebrew를 처음 설치했다면 마지막 안내에 따라 `brew shellenv`를 셸 설정에 추가하세요.
- 터미널 폰트는 Nerd Font를 별도로 설치·선택하세요.

## 구성

| 경로 | 내용 |
| --- | --- |
| `Brewfile` | Neovim, 검색 도구, Node.js, 공식 Kotlin LSP, JDK 25 |
| `nvim/` | LazyVim 설정과 플러그인 잠금 파일 |
| `skhd/` | 향후 skhd 설정을 추가할 위치 |
| `install.sh` | 패키지 설치, 기존 설정 백업, 심볼릭 링크 연결 |

Brewfile은 현재 컴퓨터의 모든 앱 목록이 아닌 편집 환경용 기본 구성입니다.
GUI 앱이나 다른 개발 도구는 필요에 따라 추가할 수 있습니다.

## Neovim

첫 실행에 플러그인이 설치됩니다. `:Lazy restore`로 잠금 버전을 복원하고
`:checkhealth`, `:LspInfo`로 실행 환경을 확인하세요.
Mason을 사용하는 언어별 도구는 첫 사용 시 추가 설치될 수 있습니다.
Kotlin/Java 실행 경로 자동 탐색과 사용자 탐색기 기능은 [Neovim 안내](nvim/README.md)를 참고하세요.

## 공개 설정 관리

토큰, SSH 키, 실제 `.env`, 편집 기록·캐시는 저장소에 넣지 않습니다.
환경별 비밀값은 저장소 밖에서 환경변수로 설정합니다.
앱 로그인과 macOS 권한은 각 컴퓨터에서 직접 설정합니다.

## 라이선스

Apache-2.0. LazyVim starter에서 가져온 라이선스를 유지합니다.
외부 플러그인과 도구는 각 프로젝트의 라이선스를 따릅니다.
