set -Ux EDITOR nvim
set -Ux VISUAL nvim

if status is-interactive
    and not set -q TMUX
    exec tmux new-session
end

function fish_greeting
    fastfetch
end

function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience

alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.="eza -a | grep -e '^\.'"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
