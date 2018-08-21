# ZSH Theme - Preview: http://img.skitch.com/20091113-qqtd3j8xinysujg5ugrsbr7x1y.jpg
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

#PROMPT='%{$fg[green]%}%m%{$reset_color%} %2~ $(git_prompt_info)%{$reset_color%}%B»%b '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

PROMPT_TIME="%F{green}%D{%L:%M} %F{yellow}%D{%p}%f"

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo `basename $VIRTUAL_ENV`
}

# Theme with full path names and hostname
# Handy if you work on different servers all the time;

# %n = username
#
# PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[green]%}%~%{$reset_color%} %{$fg[yellow]%}$(git_branch)%{$reset_color%} %h %(!.#.$) '

# ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[cyan]%}git:("
# ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"


autoload -U colors && colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{red}'
zstyle ':vcs_info:*' unstagedstr '%F{red}'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
function virtualenv_info {
 [ $VIRTUAL_ENV ] && echo '['`basename $VIRTUAL_ENV`']'
}

theme_precmd () {

    PROMPT_NAME='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m FOOOO'

    PROMPT_DIR='%{$fg[green]%}${PWD/#$HOME/~}'

    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' %F{yellow}%c%u%b%F{reset}'
    } else {
        zstyle ':vcs_info:*' formats ' %F{red}*%b%F{reset}'  # P1
    }

    vcs_info
}


# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/#the-whole-thing
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '♖' && return
    hg root >/dev/null 2>/dev/null && echo '♗' && return
    echo '○'
}

# http://stackoverflow.com/questions/103857/what-is-your-favorite-bash-prompt

prompt_timer_begin()
{
    echo '_'
    if [ -z "$time_begin" ]; then
        echo 'pretty_time'
        time_begin="$(~/.files/.pretty_time)"
        echo "date: $(gdate +'%s')"
        echo "time_begin set: $time_begin"
    fi
}

prompt_timer_end()
{
    if [ ! -z "$time_begin" ]; then
        time_end="$(~/.files/.pretty_time)"
        echo "time_end set: $time_end"

        echo "pretty_time($time_begin, $time_end)"
        time_pretty=`~/.files/.pretty_time $time_begin $time_end`
        # echo "time_pretty set: $time_pretty"
        echo "time_pretty: $time_pretty"
        echo "time_begin after clear: $time_begin"
        time_begin=""

    fi
}


# set_begin()
# {
#   if [ -z "$begin" ]
#   then
#     begin="$(gdate +"%s %N")"
#     echo "begin: $begin"
#   fi
# }
# calc_elapsed()
# {
#   echo "calc_elapsed called: begin: $begin, "

#   read begin_s begin_ns <<< "$begin"
#   begin_ns="${begin_ns##+(0)}"
#   # PENDING - date takes about 11ms, maybe could do better by digging in
#   # /proc/$$.
#   read end_s end_ns <<< $(gdate +"%s %N")
#   end_ns="${end_ns##+(0)}"
#   local s=$((end_s - begin_s))
#   local ms

#   echo "end_ns: $end_ns, begin_ns: $begin_ns"

#   if [ "$end_ns" -ge "$begin_ns" ]
#   then
#     ms=$(((end_ns - begin_ns) / 1000000))
#   else
#     s=$((s - 1))
#     ms=$(((1000000000 + end_ns - begin_ns) / 1000000))
#   fi
#   elapsed="$(printf " %2u:%03u" $s $ms)"
#   if [ "$s" -ge 300 ]
#   then
#     elapsed="$elapsed [$(human_time $s)]"
#   fi
# }
# human_time()
# {
#   echo "human_time called: begin: $begin, "
#   local s=$1
#   local days=$((s / (60*60*24)))
#   s=$((s - days*60*60*24))
#   local hours=$((s / (60*60)))
#   s=$((s - hours*60*60))
#   local min=$((s / 60))
#   if [ "$days" != 0 ]
#   then
#     local day_string="${days}d "
#   fi
#   printf "$day_string%02d:%02d\n" $hours $min
# }
# timer_prompt()
# {
#   echo "timer_prompt called"

#   status2=$?
#   local size=16
#   calc_elapsed
#   pwd_string="${PWD: -$size}"
#   PS1="$elapsed $pwd_string $status2\\$ "
#   begin=
# }
# set_begin
# export PROMPT_COMMAND=timer_prompt





#https://gist.github.com/1949777
# function minutes_since_last_commit {
#     now=`date +%s`
#     last_commit=`git log --pretty=format:'%at' -1`
#     seconds_since_last_commit=$((now-last_commit))
#     minutes_since_last_commit=$((seconds_since_last_commit/60))
#     echo $minutes_since_last_commit
# }
# # Determine the time since last commit. If branch is clean,
# # use a neutral color, otherwise colors will vary according to time.
# function git_time_since_commit() {
#     if git rev-parse --git-dir > /dev/null 2>&1; then
#         # Only proceed if there is actually a commit.
#         if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
#             # Get the last commit.
#             last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
#             now=`date +%s`
#             seconds_since_last_commit=$((now-last_commit))

#             # Totals
#             MINUTES=$((seconds_since_last_commit / 60))
#             HOURS=$((seconds_since_last_commit/3600))

#             # Sub-hours and sub-minutes
#             DAYS=$((seconds_since_last_commit / 86400))
#             SUB_HOURS=$((HOURS % 24))
#             SUB_MINUTES=$((MINUTES % 60))

#             if [[ -n $(git status -s 2> /dev/null) ]]; then
#                 if [ "$MINUTES" -gt 30 ]; then
#                     COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
#                 elif [ "$MINUTES" -gt 10 ]; then
#                     COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
#                 else
#                     COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
#                 fi
#             else
#                 COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
#             fi

#             if [ "$HOURS" -gt 24 ]; then
#                 echo "|$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
#             elif [ "$MINUTES" -gt 60 ]; then
#                 echo "|$COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
#             else
#                 echo "|$COLOR${MINUTES}m%{$reset_color%}|"
#             fi
#         fi
#     fi
# }


# FOO='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m'

# trap prompt_timer_begin DEBUG

# setopt prompt_subst

# Prompt with virtual env included
# PROMPT='%{$fg[cyan]%}$(virtualenv_info) $fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[green]%}${PWD/#$HOME/~}%{$reset_color%}${vcs_info_msg_0_}%{$reset_color%} %(!.♔.♙)  %{$reset_color%}'

# PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[green]%}${PWD/#$HOME/~}%{$reset_color%}${vcs_info_msg_0_}%{$reset_color%} %(!.♔.♙)  %{$reset_color%}'

PROMPT='%F{cyan}%n%f@%F{cyan}%m%F{cyan}$(virtualenv_info) %f%f%F{green}${PWD/#$HOME/~}%f${vcs_info_msg_0_}%(!. ♔. ♙) '

# white_time_left_prompt
autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd


