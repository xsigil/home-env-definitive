autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' (%F{green}%b%f)'
zstyle ':vcs_info:git:*' actionformats ' (%F{green}%b%f|%F{red}%a%f)'

precmd() {
    vcs_info
}

PROMPT='%m:%1~${vcs_info_msg_0_}%# '
