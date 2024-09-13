# PS1='\[\033[1;32m\]\u\[\033[0m\]@\h \[\033[1;32m\]`pwd|sed -e "s!$HOME!~!"|sed -re "s!([^/])[^/]+/!\1/!g"`\[\033[0m\]$(__git_ps1 " (%s) ")> '
EDITOR=vim
alias ~="cd ~"
# alias v="vim"
function v() {
    if [ -n "$VIM_TERMINAL" ]; then
        filename=$(realpath $1)
        echo -e "\e]51;[\"drop\", \"$filename\"]\07"
    else
        vim $1
    fi
}
alias vi="vim"
# alias rm="rm -i"
# alias t="tmux"
# alias ff="fastfetch"
# alias monka="echo monka"
# alias info="info --vi-keys"
