# ==============================================================================
# Base Environment
# ==============================================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BROWSER=links
export GPG_TTY=$(tty)
export MAIL="${HOME}/_maildir"

# PATH: ~/.local/bin を最優先
export PATH="${HOME}/.local/bin:${PATH}"

# PostgreSQL (OSINT & Geo Analysis)
export PGOPTIONS='-c search_path=public,osint,estat,iso,offshore,geopolit,geonames,ofac,mlit,insights'
export DBUI='postgres:///the_world?search_path=public,osint,estat,iso,offshore,geopolit,geonames,mlit,ofac,insights'

# Hardware & Display
export CUDA_VISIBLE_DEVICES=0
export FULL_DISPLAY_COORDINATE="1920,0 1920x1080"

# SSH Agent (systemd user socket)
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# ==============================================================================
# History (XDG State へ隔離)
# ==============================================================================
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
export HISTORY_IGNORE="(AWS|SECRET|PASSWORD|PASSWD|*auth*|*token*)"

setopt inc_append_history
setopt share_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ==============================================================================
# Completion (XDG Cache へ隔離 & 高度補完)
# ==============================================================================
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=** l:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' prompt '%e'
zstyle ':completion:*' menu select

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

# ==============================================================================
# Utility Functions
# ==============================================================================
function ff() {
    local selected_file=$(rg --no-heading --line-number "$1" | fzf | awk -F: '{print $1 " +" $2}')
    if [[ -n "$selected_file" ]]; then
        xargs -I{} nvim {} <<< "$selected_file"
    fi
}

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

function weather_check() {
    local ops=$1
    curl --socks4 localhost:9050 "wttr.in/Machida?${ops}&lang=en"
}

function ipify() {
    curl -s 'https://api.ipify.org?format=json'
}

function extract_emails() {
    find "$1" -type f | xargs file | grep "text" | cut -d: -f1 | xargs cat | grep 'mailto' | sed -n 's/\(.*\)mailto:\([^"][^"]*\)".*/\2/gp' | sort -u
}

function gput() {
    local target="${HOME}/_links/tmp/g.txt"
    if [ -p /dev/stdin ]; then
        cat > "$target"
    else
        wl-paste > "$target"
    fi
}

# ==============================================================================
# Load Modular Sub-configs
# ==============================================================================
[[ -f "${ZDOTDIR}/export.zsh" ]]  && source "${ZDOTDIR}/export.zsh"
[[ -f "${ZDOTDIR}/alias.zsh" ]]   && source "${ZDOTDIR}/alias.zsh"
[[ -f "${ZDOTDIR}/keybind.zsh" ]] && source "${ZDOTDIR}/keybind.zsh"
[[ -f "${ZDOTDIR}/prompt.zsh" ]]  && source "${ZDOTDIR}/prompt.zsh"
