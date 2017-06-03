# Jackfruit Theme by Shabith Ishan
#
# Based on  Steve Losh's Theme http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/#my-right-prompt-battery-capacity
# and Remy Sharp's Theme https://gist.github.com/remy/6079223#file-remy-zsh-theme and his online-check script https://gist.github.com/remy/6079223#file-online-check-sh
#
####

PROMPT='%{$reset_color%}→ '

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

CURRENT_BG='NONE'
SEGMENT_SEPARATOR='⮀'
 
ONLINE='%{%F{green}%}◉'
OFFLINE='%{%F{red}%}⦿'


function prompt_online() {
  if [[ -f ~/.offline ]]; then
    echo $OFFLINE
  else
    echo $ONLINE
  fi
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function get_pwd() {
  print -D $PWD
}

function battery_charge() {
  if [ -e ~/bin/batcharge.py ]
  then
    echo `python ~/bin/batcharge.py`
  else
    echo ''
  fi
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 10))
  else
    git=0
  fi

  local bat=$(battery_charge)
  if [ ${#bat} != 0 ]; then
    ((bat = ${#bat} - 18))
  else
    bat=0
  fi

  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} - ${bat} - ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} " 
  done
  echo $spacing
}

function precmd() {
print -rP '
$fg[cyan]%m: $fg[yellow]$(get_pwd)$(put_spacing)$(git_prompt_info) $(battery_charge)   $(prompt_online) '
}

