#!/usr/bin/env bash
set -euo pipefail

DOTFILES_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/$(date +%Y%m%d-%H%M%S)-$$"
DRY_RUN=0
SKIP_BREW=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --skip-brew) SKIP_BREW=1 ;;
    -h|--help) echo 'Usage: ./install.sh [--dry-run] [--skip-brew]'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

if [[ "$SKIP_BREW" == 0 ]]; then
  if [[ "$(uname -s)" != Darwin ]]; then
    echo 'Brewfile targets macOS. Use --skip-brew and install tools separately.' >&2
    exit 1
  fi
  if [[ "$DRY_RUN" == 1 ]]; then
    echo "Would install Homebrew if missing, then run brew bundle --file=$DOTFILES_ROOT/Brewfile"
  else
    if ! command -v brew >/dev/null 2>&1; then
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
      else
        installer="$(mktemp)"
        trap 'rm -f "$installer"' EXIT
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"
        /bin/bash "$installer"
        if [[ -x /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        else
          eval "$(/usr/local/bin/brew shellenv)"
        fi
      fi
    fi
    brew bundle --file="$DOTFILES_ROOT/Brewfile"
  fi
fi

link_config() {
  local source="$1" target="$2"
  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
    echo "Already linked: $target"
    return
  fi
  if [[ "$DRY_RUN" == 1 ]]; then
    echo "Would back up existing $target and link it to $source"
    return
  fi
  mkdir -p "$(dirname "$target")"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_ROOT"
    mv "$target" "$BACKUP_ROOT/$(basename "$target")"
    echo "Backup: $BACKUP_ROOT/$(basename "$target")"
  fi
  ln -s "$source" "$target"
  echo "Linked: $target -> $source"
}

link_config "$DOTFILES_ROOT/nvim" "$CONFIG_ROOT/nvim"
if [[ -f "$DOTFILES_ROOT/skhd/skhdrc" ]]; then
  link_config "$DOTFILES_ROOT/skhd/skhdrc" "$CONFIG_ROOT/skhd/skhdrc"
fi
