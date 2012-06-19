
##############################################################
# Version
##############################################################

SCRIPT_VERSION="v1.4"

echo
echo ".bash_profile ($SCRIPT_VERSION)"
echo

##############################################################
# OSX / WINDOWS Compatability
##############################################################

# Supported arguments: "windows", "osx"
function is_os {
  if [ $1 = "windows" ] && [ "$OS" = "Windows_NT" ]; then
    return 0
  elif [ $1 = "osx" ] && [ ! "$OS" = "Windows_NT" ]; then
    return 0
  fi
  return 1
}

# Configure with: ~/.location
function is_location {
  if [ "`cat ~/.location | grep $1`" = $1 ]; then
    return 0
  fi
  return 1
}

# Create missing .location file if it doesn't exist
if [ ! -f ~/.location ]; then
  echo "home" > ~/.location
fi

##############################################################
# Path and Location
##############################################################

# Print operating system
echo -n "  OS:       "

# Bind for Windows
if is_os "windows"; then
  echo "Windows"
  export USER=$USERNAME                 # OSX already has this
  export PATH=$PATH
  export PATH=~/bin/windows:$PATH
  export EDITOR="vim"

# Bind for OSX
elif is_os "osx"; then
  echo "OSX"
  # Brew requires /usr/local/bin and /usr/local/sbin to be ahead of /usr/bin
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/local/sbin:$PATH

  # Path for node
  export NODE_PATH=/usr/local/lib/node_modules

  # Todo: Fix path to be LOCATION based.
  export PATH=/usr/local/Cellar/git/1.7.8/bin:$PATH
  export PATH=~/bin:$PATH
  export PATH=~/bin/osx:$PATH
  export EDITOR="sub -w"

  if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
  fi
fi

echo "  User:     $USER"

##############################################################
# Prompt
##############################################################

function git_branch {
   (echo -n "*"; git branch 2> /dev/null | sed -e '/^[^*]/d') | sed -e 's/\*\* \(.*\)/*\1/'
}

function heroku_account {
   (echo -n "^"; heroku accounts 2> /dev/null | sed -e '/^[^*]/d') | sed -e 's/\^\* \(.*\)/\^\1/'
}

function define_colors {
  local N=30
  local COLOR
  for COLOR in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    export COLOR_${COLOR}="\033[0;${N}m"
    export COLOR_${COLOR}_LIGHT="\033[1;${N}m"
    export PROMPT_COLOR_${COLOR}="\[\033[0;${N}m\]"
    export PROMPT_COLOR_${COLOR}_LIGHT="\[\033[1;${N}m\]"
    N=$(($N + 1))
  done

  COLOR_NONE="\033[0m"
  COLOR_COMMENT=$COLOR_BLACK
  PROMPT_COLOR_NONE="\[${COLOR_NONE}\]"
  PROMPT_COLOR_GIT=$PROMPT_COLOR_GREEN
  PROMPT_COLOR_USER=$PROMPT_COLOR_CYAN
  PROMPT_COLOR_HOST=$PROMPT_COLOR_CYAN
  PROMPT_COLOR_PATH=$PROMPT_COLOR_YELLOW
  PROMPT_COLOR_HISTORY=$PROMPT_COLOR_RED
  PROMPT_COLOR_TIME=$PROMPT_COLOR_MAGENTA

  # TODO: Extend bold, underline to all colors
  COLOR_BOLD="\033[1m"
  PROMPT_COLOR_BOLD="\[${COLOR_BOLD}\]"

  COLOR_UNDERLINE="\033[4m"
  PROMPT_COLOR_UNDERLINE="\[${COLOR_UNDERLINE}\]"
}
define_colors

alias print_colors="echo -e \"${COLOR_NONE}COLOR_NONE\";echo -e \"${COLOR_WHITE}COLOR_WHITE\t${COLOR_WHITE_LIGHT}COLOR_WHITE_LIGHT\";echo -e \"${COLOR_BLUE}COLOR_BLUE\t${COLOR_BLUE_LIGHT}COLOR_BLUE_LIGHT\";echo -e \"${COLOR_GREEN}COLOR_GREEN\t${COLOR_GREEN_LIGHT}COLOR_GREEN_LIGHT\";echo -e \"${COLOR_CYAN}COLOR_CYAN\t${COLOR_CYAN_LIGHT}COLOR_LIGHT_CYAN\";echo -e \"${COLOR_RED}COLOR_RED\t${COLOR_RED_LIGHT}COLOR_RED_LIGHT\";echo -e \"${COLOR_MAGENTA}COLOR_MAGENTA\t${COLOR_MAGENTA_LIGHT}COLOR_MAGENTA_LIGHT\";echo -e \"${COLOR_YELLOW}COLOR_YELLOW\t${COLOR_YELLOW_LIGHT}COLOR_YELLOW_LIGHT\";echo -e \"${COLOR_BLACK}COLOR_BLACK\t${COLOR_BLACK_LIGHT}COLOR_BLACK_LIGHT\""

# user@host|git|path
PS1="${PROMPT_COLOR_USER}\u${PROMPT_COLOR_NONE}@${PROMPT_COLOR_HOST}\h${PROMPT_COLOR_NONE}|${PROMPT_COLOR_GIT}\$(git_branch)${PROMPT_COLOR_NONE}|${PROMPT_COLOR_PATH}\w${PROMPT_COLOR_NONE}\$ "

# git|path
alias psn="PS1='\[${PROMPT_COLOR_GIT}\$(git_branch)${PROMPT_COLOR_NONE}|${PROMPT_COLOR_PATH}\w${PROMPT_COLOR_NONE}\]\$ '"

# heroku|git|path
alias psh="PS1='\[${PROMPT_COLOR_USER}\$(heroku_account)${PROMPT_COLOR_NONE}|${PROMPT_COLOR_GIT}\$(git_branch)${PROMPT_COLOR_NONE}|${PROMPT_COLOR_PATH}\w${PROMPT_COLOR_NONE}\]\$ '"

# user@host|git|path
alias ps1="PS1='\[${PROMPT_COLOR_USER}\u${PROMPT_COLOR_NONE}@${PROMPT_COLOR_HOST}\h${PROMPT_COLOR_NONE}|${PROMPT_COLOR_GIT}\$(git_branch)${PROMPT_COLOR_NONE}|${PROMPT_COLOR_PATH}\w${PROMPT_COLOR_NONE}\]\$ '"

# time|user@host|git|path
alias ps2="PS1='\[${PROMPT_COLOR_TIME}\t${PROMPT_COLOR_NONE}|${PROMPT_COLOR_USER}\u${PROMPT_COLOR_NONE}@${PROMPT_COLOR_HOST}\h${PROMPT_COLOR_NONE}|${PROMPT_COLOR_GIT}\$(git_branch)${PROMPT_COLOR_NONE}|${PROMPT_COLOR_PATH}\w${PROMPT_COLOR_NONE}\]\$ '"

# history|time|user@host|git|path
alias ps3="PS1='\[${PROMPT_COLOR_HISTORY}\!${PROMPT_COLOR_NONE}|${PROMPT_COLOR_TIME}\t${PROMPT_COLOR_NONE}|${PROMPT_COLOR_USER}\u${PROMPT_COLOR_NONE}@${PROMPT_COLOR_HOST}\h${PROMPT_COLOR_NONE}|${PROMPT_COLOR_GIT}\$(git_branch)${PROMPT_COLOR_NONE}|${PROMPT_COLOR_PATH}\w${PROMPT_COLOR_NONE}\]\$ '"

##############################################################
# Terminal aliases
##############################################################

# SOLARIZED        TERMCOL     XTERM/HEX     HEX       16/8   RGB           HSB           L*A*B        LIGHT          DARK
# --------------   ---------   -----------   -------   ----   -----------   -----------   ----------   ------------   ------------
# base03           brblack     234 #1c1c1c   #002b36    8/4     0  43  54   193 100  21   15 -12 -12   ---            bg
# base02           black       235 #262626   #073642    0/4     7  54  66   192  90  26   20 -12 -12   ---            bg highlight
# base01           brgreen     240 #585858   #586e75   10/7    88 110 117   194  25  46   45 -07 -07   emphasis       comment
# base00           bryellow    241 #626262   #657b83   11/7   101 123 131   195  23  51   50 -07 -07   text           ---
# base0            brblue      244 #808080   #839496   12/6   131 148 150   186  13  59   60 -06 -03   ---            text
# base1            brcyan      245 #8a8a8a   #93a1a1   14/4   147 161 161   180   9  63   65 -05 -02   comment        emphasis
# base2            white       254 #e4e4e4   #eee8d5    7/7   238 232 213    44  11  93   92 -00  10   bg highlight   ---
# base3            brwhite     230 #ffffd7   #fdf6e3   15/7   253 246 227    44  10  99   97  00  10   bg             ---
# yellow           yellow      136 #af8700   #b58900    3/3   181 137   0    45 100  71   60  10  65   accent         accent
# orange           brred       166 #d75f00   #cb4b16    9/3   203  75  22    18  89  80   50  50  55   accent         accent
# red              red         160 #d70000   #dc322f    1/1   220  50  47     1  79  86   50  65  45   accent         accent
# magenta          magenta     125 #af005f   #d33682    5/5   211  54 130   331  74  83   50  65 -05   accent         accent
# violet           brmagenta    61 #5f5faf   #6c71c4   13/5   108 113 196   237  45  77   50  15 -45   accent         accent
# blue             blue         33 #0087ff   #268bd2    4/4    38 139 210   205  82  82   55 -10 -45   accent         accent
# cyan             cyan         37 #00afaf   #2aa198    6/6    42 161 152   175  74  63   60 -35 -05   accent         accent
# green            green        64 #5f8700   #859900    2/2   133 153   0    68 100  60   60 -20  65   accent         accent
# --------------   ---------   -----------   -------   ----   -----------   -----------   ----------   ------------   ------------
# PRISMIZED        TERMCOL     XTERM/HEX     HEX       16/8   RGB           HSB           L*A*B        LIGHT          DARK
# --------------   ---------   -----------   -------   ----   -----------   -----------   ----------   ------------   ------------
# darkbasered      n/a                                         27   0   3                              ---            bg
# darkbaseorange   n/a                                         30  16   1                              ---            bg
# darkbaseyellow   n/a                                         30  30   0                              ---            bg
# darkbasegreen    n/a                                         12  26  14                              ---            bg
# darkbasecyan     n/a                                          0  28  29                              ---            bg
# darkbasepurple   n/a                                         20  12  29                              ---            bg

if is_os "osx"; then

  function terminal_theme {
    TERMINAL_THEME=$1; if [ -z "$TERMINAL_THEME" ]; then TERMINAL_THEME="SolarizedDarkEvan"; fi
    osascript -e "tell application \"Terminal\" to set current settings of window 1 to settings set \"$TERMINAL_THEME\""
  }

  function light { terminal_theme "SolarizedLightEvan"; }
  function dark { terminal_theme "SolarizedDarkEvan"; }
  function blue { dark; }
  function white { light; }
  function red { dark; osascript -e "tell application \"Terminal\" to set background color of window 1 to {6885, 0, 765}"; }
  function green { dark; osascript -e "tell application \"Terminal\" to set background color of window 1 to {3060, 6630, 3570}"; }
  function purple { dark; osascript -e "tell application \"Terminal\" to set background color of window 1 to {5100, 3060, 7395}"; }
  function cyan { dark; osascript -e "tell application \"Terminal\" to set background color of window 1 to {0, 7140, 7395}"; }
  function orange { dark; osascript -e "tell application \"Terminal\" to set background color of window 1 to {7650, 4080, 255}"; }
  function yellow { dark; osascript -e "tell application \"Terminal\" to set background color of window 1 to {7650, 7650, 0}"; }

  # Run -- Echo your command as it is run
  function comment { echo -e "${COLOR_COMMENT}[$@]${COLOR_NONE}"; }
  function run { comment $@; $@; }

  # Color terminal during run
  function runl { light; run $@; dark; }
  function rund { dark; run $@; light; }
  function runr { red; run $@; dark; }
  function rung { green; run $@; dark; }
  function runp { purple; run $@; dark; }
  function runy { yellow; run $@; dark; }
  function runo { orange; run $@; dark; }
  function runc { cyan; run $@; dark; }

  # Beep
  function beep { echo -n ''; }

  # Growl
  function growl { growlnotify -m $@; }
  function grun { $@; growlnotify -t "Completed" -m "$@"; }
  function grunl { light; grun $@; dark; }
  function grund { dark; grun $@; light; }
  function grunr { red; grun $@; dark; }
  function grung { green; grun $@; dark; }
  function grunp { purple; grun $@; dark; }
  function grunc { cyan; grun $@; dark; }
  function gruno { orange; grun $@; dark; }
  function gruny { yellow; grun $@; dark; }

else

  function beep { echo -n ''; }
  function run { $@; }
  function runl { $@; }
  function rund { $@; }
  function runr { $@; }
  function rung { $@; }
  function runp { $@; }
  function runy { $@; }
  function runo { $@; }
  function runc { $@; }
  function growl { $@; }
  function grunl { $@; }
  function grunr { $@; }
  function grung { $@; }
  function grunp { $@; }
  function grunc { $@; }
  function gruno { $@; }
  function gruny { $@; }

fi

##############################################################
# One-time Aliases
##############################################################

if is_os "osx"; then
  function onetime_setup {
    # Ensure dropbox is /d
    run ln -s $HOME/Dropbox/ $HOME/d

    # Add .gitconfig, .bash_profile to path
    run ln -s $HOME/.files/.gitconfig $HOME/.gitconfig
    run ln -s $HOME/.files/.bash_profile $HOME/.bash_profile

    # Add sublime to commandline path
    run ln -s '/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl' $HOME/bin/sub

    # Hotlink sublime user settings to dropbox
    run rm -rf "$HOME/Library/Application Support/Sublime Text 2/Packages/User"; ln -s "$HOME/d/env/sublime/Packages/User" "$HOME/Library/Application Support/Sublime Text 2/Packages/User"
  }
fi

##############################################################
# Bash Aliases
##############################################################

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

alias p='sub ~/.files/.osx.sh ~/.files/.links.sh ~/.files/.gitconfig ~/.files/.bash_profile'

alias hlist='history $@'
alias hclear='history -c'             # history clear
alias hgrep='history | grep -i $@'   # history grep

##############################################################
# Navigation Aliases
##############################################################

alias asdf='clear;'
alias cl='clear; ls -lhG $@'
alias cla='clear; ls -lhAG $@'
alias l='run ls -lhG $@'
alias la='run ls -lhAG $@'
alias ls="run ls -G $@"

alias s='cd ..'

alias diff='run git difftool --extcmd=/usr/bin/opendiff $@'
alias diffs='run git difftool --staged --extcmd=/usr/bin/opendiff $@'

##############################################################
# Location aliases
#
# Edit ~/.location to configure
##############################################################

echo -n "  Aliases: "

##############################
# Shared Aliases
##############################

alias d='cd ~/d/ $@'
alias e='cd ~/e/ $@'
alias g='cd ~/g/ $@'

##############################
# Home Aliases
##############################

if is_location "home"; then
  echo -n " @Home"

  alias dd='cd ~/d/dev/$@'
  alias f='cd ~/d/dev/face/$@'
  alias fu='cd ~/d/leaguefu/$@'
  alias fr='cd ~/framd/$@'
  alias lf='cd ~/leaguefu/$@'
  alias ggg='cd ~/gg/$@'
  alias sm='cd ~/smite/$@'
  alias smdb='cd ~/smite-db-mongoose/$@'
  alias smd='cd ~/smite-demo/$@'
  alias smc='cd ~/smite-client/$@'
  alias frd='cd ~/framd/docs/$@'
  alias frp='cd ~/framd/prototype/$@'
  alias frs='cd ~/framd/source/$@'

##############################
# Work Aliases
##############################

elif is_location "work"; then
  echo -n " @Work"
fi

echo # Newline

# Run, change color, and echo
function ssh {
  runr /usr/bin/ssh "$@"
}

##############################################################
# Git aliases
##############################################################

alias m='git checkout master'     # Change to master branch\
alias b='git checkout -'          # Toggle to last branch
alias go='git checkout $@'

# Git core information

alias gb='run git branch'
# alias_echo 'gs' 'git status'
alias gs='run git status'
function gl {
  comment "git lg | head -n ${1:-20}"
  git lg | head -n ${1:-20}
}
alias gg='echo -e "\n------------ Git Branch ------------ \n";git branch;echo -e "\n------------ Git Status ------------ \n";git status;echo -e "\n------------ Git Log -------------- \n";git lg | head -n 12'

alias gd='run git diff'
alias gds='run git diff --staged'
alias gdc='run git diff --cached'

# Git core manipulation

alias ga='run git add'
alias gap='run git add -p'

alias gf='run git fetch'
alias gp='run git pull'

alias gc='run git commit'
alias gcm='run git commit -m "$@"'

alias gr='run git remote $@'
alias grv='run git remote -v $@'
alias gra='run git remote add $@'

alias gch='run git checkout'
alias gchp='run git checkout -p'

alias gpush='run git stash'
alias gpop='run git stash pop'

alias grm='run git rebase master'
alias grom='run git rebase origin/master'
alias grim='run git rebase -i origin/master'
alias gromf='gf && grom'
alias gros='run git rebase origin/staging'
alias gris='run git rebase -i origin/staging'

alias gack='run git add . && git commit -m "f"'
alias grimace='run git add . && git commit -m "f" && git rebase -i master'

# To remember
alias git_reset_head='run git reset -p HEAD'
alias git_deleted='run git ls-files -d'
alias git_restore_deleted='run git ls-files -d | xargs git checkout --'
alias git_undo_cherrypick='run git reset --merge ORIG_HEAD'
alias git_remember_merge_changes='run git rerere'
alias git_rebase_top_commit='run git rebase -i HEAD~'
alias git_rebase_top_4_commits='run git rebase -i HEAD~4'
alias git_list_remote_branches='run git br -r'
alias git_delete_remote_branch='echo "git push <remotename> --delete <branchname>"'
alias git_show_file_stats_between_branches='git '
# Visual diffs in OSX using built in opendiff
##############################################################
# Node aliases
##############################################################

alias n='runl node $@'
alias na='runp nodemon src/app.js'
alias np='sub package.json'

alias fs='runl foreman start -p 3000 $@'
alias fl='run cat Procfile'
alias fl='sub Procfile'

##############################################################
# Cake aliases
##############################################################

alias c='cake $@'

##############################################################
# Heroku aliases
##############################################################

alias h='run heroku $@'

alias hc='run heroku config $@'
alias hca='run heroku config:add $@'
alias hcr='run heroku config:remove $@'

alias hk='run heroku keys $@'
alias hka='run heroku keys:add $@'
alias hkr='run heroku keys:remove $@'

alias hl='run heroku logs $@'
alias hlt='run heroku logs --tail $@'
function hln {
  run heroku logs -n ${1:-20}
}
#alias hln='run heroku logs -n $@ 5'

alias ha='run heroku accounts'
alias has='run heroku accounts:set $@'

##############################################################
# Rails aliases
##############################################################

alias rtest='growl rake'
alias rmig='growl runl rake db:migrate'
alias rmigtest='growl runl rake db:migrate RAILS_ENV=test'
alias roll='growl run rake db:rollback'
alias rsd='runl rails server --debugger'
alias rs='run rails server'

##############################################################
# Unsorted
##############################################################

alias pg='run ps axw | grep -i'
alias plg='run port list | grep -i'

echo

