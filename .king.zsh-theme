# ZSH Theme - Preview: http://img.skitch.com/20091113-qqtd3j8xinysujg5ugrsbr7x1y.jpg
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

#PROMPT='%{$fg[green]%}%m%{$reset_color%} %2~ $(git_prompt_info)%{$reset_color%}%B»%b '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

# Theme with full path names and hostname
# Handy if you work on different servers all the time;

# %n = username
#
# PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[green]%}%~%{$reset_color%} %{$fg[yellow]%}$(git_branch)%{$reset_color%} %h %(!.#.$) '

# ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[cyan]%}git:("
# ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"


autoload -U colors && colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{yellow}'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' %F{blue}%c%u%b%F{reset}'
    } else {
        zstyle ':vcs_info:*' formats ' %F{red}%b%F{reset}'  # P1
    }

    vcs_info
}

setopt prompt_subst
# PROMPT='%B%F{magenta}%c%B%F{green}${vcs_info_msg_0_}%B%F{magenta} %{$reset_color%}%% '
PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[green]%}%~%{$reset_color%}${vcs_info_msg_0_}%{$reset_color%} %(!.♔.♙)  %{$reset_color%}'

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
