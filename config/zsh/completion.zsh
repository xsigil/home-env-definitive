# ==============================================================================
# Completion (XDG Cache への隔離 & 高度な補完ルール)
# ==============================================================================
# 曖昧マッチ・大文字小文字無視・スペル訂正
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=** l:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' prompt '%e'

# メニュー選択の有効化（Tab連打で候補をカーソル移動可能に）
zstyle ':completion:*' menu select

autoload -Uz compinit
[[ ! -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] && mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
