# Editor Integration
export EDITOR="nvim"
export VISUAL="nvim"
export PSQL_EDITOR="nvim"
export PAGER="less -R"

# Language Runtimes (XDG Compliance & PATH)
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
[[ -d "${CARGO_HOME}/bin" ]] && export PATH="${CARGO_HOME}/bin:${PATH}"
[[ -d "${HOME}/.cargo/bin" ]] && export PATH="${HOME}/.cargo/bin:${PATH}"

export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
[[ -d "${GOPATH}/bin" ]] && export PATH="${GOPATH}/bin:${PATH}"

export PYENV_ROOT="${HOME}/.pyenv"
if [[ -d "${PYENV_ROOT}/bin" ]]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi

# Recon Profile
export NMAP_SERVICES="${XDG_CONFIG_HOME:-$HOME/.config}/nmap/nmap-services"
export PATH="$HOME/.local/share/ssh-to/machines:$PATH:$HOME/.local/bin"
