# Editor
alias vim="nvim"
alias vi="nvim"

# Date & Timestamps
alias datestamp="date +%Y%m%d"
alias timestamp="date +%Y%m%d%H%M%S"

# Navigation & Listing
alias ll="ls -c --color=auto"

# Text Processing & Document Building
alias check_japanese="grep -P '[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF]'"
alias pandoc_md2pdf="pandoc --to=pdf --pdf-engine=lualatex -V documentclass=bxjsarticle -V classoption=pandoc"

# Network & Anonymity
alias elinks="elinks -anonymous"
alias trans="proxychains -q -f ${XDG_CONFIG_HOME:-$HOME/.config}/proxychains/tor.conf trans"
alias ptrans="trans -x localhost:8118"

# Database & OSINT
alias world="psql the_world"
alias dbui="nvim --cmd 'autocmd VimEnter * DBUI'"

alias cd-secret="cd ~/_lair/secret"
alias cd-public="cd ~/_lair/public"
alias cd-private="cd ~/_lair/private"
