function prompt_virtualenv {
  PYPATH=$(which python)
  if [ ! -f $PYPATH ]; then
    echo ""
  else
    NEW_PATH=${PYPATH: : -7}
    PYV=$(ls $NEW_PATH | grep "^python[23].[0-9]$" | head -c 7 | tail -c 1)

    venv=$VIRTUAL_ENV
    if [[ -d $venv ]]; then
      prompt=${venv##*/}
      echo "($prompt)"
    else
      env=$CONDA_DEFAULT_ENV
      if [[ $env = "" ]]; then
        env="root"
      fi
      if [[ ${PYV:0:1} = "3" ]]; then
        prompt=$PY3$env$BRACKET
      elif [[ ${PYV:0:1} = "2" ]]; then
        prompt=$PY2$env$BRACKET
      fi
      echo "($prompt)"
    fi
  fi
}

PROMPT=$'
[%{$fg_bold[green]%}%n%b%{$fg[magenta]%}@%{$fg[cyan]%}%m%{$fg_bold[blue]%}%{$reset_color%}] %{$fg[white]%}[%~] %{$fg[yellow]%}$(prompt_virtualenv) %{$fg_bold[blue]%}%D{[%H:%M:%S]} $(git_prompt_info)\
%{$reset_color%}%{$fg[green]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '

export VIRTUAL_ENV_DISABLE_PROMPT="true"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

