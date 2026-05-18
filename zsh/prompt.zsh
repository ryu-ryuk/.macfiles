zmodload zsh/datetime 2>/dev/null
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST

typeset -g _CMD_START=0
typeset -g _CMD_DURATION=""
typeset -g _LAST_PWD="" _LAST_VENV=""
typeset -g _NODE_PILL="" _PY_PILL=""

_prompt_preexec() { _CMD_START=$EPOCHREALTIME }

_prompt_precmd() {
  local exit_code=$?
  _CMD_DURATION=""
  if (( _CMD_START > 0 )); then
    local elapsed=$(( EPOCHREALTIME - _CMD_START ))
    _CMD_START=0
    if (( elapsed >= 2 )); then
      if (( elapsed < 60 )); then
        _CMD_DURATION=$(printf '%.1fs' "$elapsed")
      else
        local total=${elapsed%.*}
        _CMD_DURATION=$(printf '%dm%ds' $((total/60)) $((total%60)))
      fi
    fi
  fi
  _refresh_lang_pills
  _build_prompt "$exit_code"
}

_find_marker_dir() {
  local d=$PWD markers="$@" m
  for _ in 1 2 3 4 5 6 7 8; do
    for m in ${=markers}; do
      [[ -e $d/$m ]] && { print -r -- "$d|$m"; return 0; }
    done
    [[ $d == "/" || $d == $HOME ]] && return 1
    d=${d:h}
  done
  return 1
}

_lang_node_pill() {
  local hit dir marker ver=""
  hit=$(_find_marker_dir package.json .nvmrc) || return
  dir=${hit%|*}
  marker=${hit##*|}

  if [[ -e $dir/.nvmrc ]]; then
    ver=$(<$dir/.nvmrc)
    ver=${ver//[$' \t\r\n']/}
    [[ -n $ver && $ver != v* ]] && ver="v$ver"
  elif ! typeset -f nvm_lazy_load >/dev/null 2>&1; then
    ver=$(node -v 2>/dev/null)
  fi

  print -rn -- "%K{#a6e3a1}%F{#11111b}  node${ver:+ $ver} %k%f"
}

_lang_python_pill() {
  if [[ -n $VIRTUAL_ENV ]]; then
    print -rn -- "%K{#74c7ec}%F{#11111b}  ${VIRTUAL_ENV:t} %k%f"
    return
  fi

  local hit dir marker ver=""
  hit=$(_find_marker_dir pyproject.toml setup.py requirements.txt Pipfile .python-version) || return
  dir=${hit%|*}
  marker=${hit##*|}

  if [[ $marker == .python-version ]]; then
    ver=$(<$dir/.python-version)
    ver=${ver//[$' \t\r\n']/}
  else
    ver=$(python3 -V 2>/dev/null | awk '{print $2}')
  fi

  print -rn -- "%K{#74c7ec}%F{#11111b}  py${ver:+ $ver} %k%f"
}

_refresh_lang_pills() {
  if [[ $PWD != $_LAST_PWD || $VIRTUAL_ENV != $_LAST_VENV ]]; then
    _LAST_PWD=$PWD
    _LAST_VENV=$VIRTUAL_ENV
    _NODE_PILL=$(_lang_node_pill)
    _PY_PILL=$(_lang_python_pill)
  fi
}

_git_segment() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch="" ahead=0 behind=0 staged=0 modified=0 untracked=0 conflicts=0 stashed=0
  local line ab xy
  while IFS= read -r line; do
    case "$line" in
      '# branch.head '*)
        branch=${line#'# branch.head '}
        [[ $branch == '(detached)' ]] && branch="@$(command git rev-parse --short HEAD 2>/dev/null)"
        ;;
      '# branch.ab '*)
        ab=${line#'# branch.ab '}
        ahead=${${ab%% *}#+}
        behind=${${ab##* }#-}
        ;;
      '1 '*|'2 '*)
        xy=${line:2:2}
        [[ ${xy:0:1} != '.' ]] && (( staged++ ))
        [[ ${xy:1:1} != '.' ]] && (( modified++ ))
        ;;
      '? '*) (( untracked++ )) ;;
      'u '*) (( conflicts++ )) ;;
    esac
  done < <(command git status --porcelain=v2 --branch 2>/dev/null)

  [[ -z $branch ]] && return
  stashed=$(command git rev-list --walk-reflogs --count refs/stash 2>/dev/null) || stashed=0

  local seg=" %F{#cba6f7} ${branch}%f"
  (( ahead > 0 ))     && seg+=" %F{#a6e3a1}⇡${ahead}%f"
  (( behind > 0 ))    && seg+=" %F{#f38ba8}⇣${behind}%f"
  (( conflicts > 0 )) && seg+=" %F{#f38ba8}✘${conflicts}%f"
  (( staged > 0 ))    && seg+=" %F{#a6e3a1}●${staged}%f"
  (( modified > 0 ))  && seg+=" %F{#fab387}✚${modified}%f"
  (( untracked > 0 )) && seg+=" %F{#b4befe}?${untracked}%f"
  (( stashed > 0 ))   && seg+=" %F{#89dceb}*${stashed}%f"
  print -rn -- "$seg"
}

_build_prompt() {
  local exit_code=$1
  local NL=$'\n'

  local shell_pill="%K{#cba6f7}%F{#11111b}  zsh %k%f"
  local user_pill="%K{#f5c2e7}%F{#11111b}  %n %k%f"
  [[ -n $SSH_CONNECTION || -n $SSH_TTY ]] && \
    user_pill="%K{#f9e2af}%F{#11111b}  %n@%m %k%f"

  local path_pill="%K{#313244}%F{#cdd6f4}  %3~"
  local git_seg
  git_seg=$(_git_segment)
  [[ -n $git_seg ]] && path_pill+="$git_seg"
  path_pill+=" %k%f"

  local dur_pill=""
  [[ -n $_CMD_DURATION ]] && \
    dur_pill="%K{#f9e2af}%F{#11111b} 󰔚 ${_CMD_DURATION} %k%f"

  local exit_pill=""
  (( exit_code != 0 )) && \
    exit_pill="%K{#f38ba8}%F{#11111b} ✘ ${exit_code} %k%f"

  local chev_color
  (( exit_code == 0 )) && chev_color="#b4befe" || chev_color="#f38ba8"

  PROMPT="${NL}${shell_pill}${user_pill}${path_pill}${_NODE_PILL}${_PY_PILL}${dur_pill}${exit_pill} %F{${chev_color}}❯%f "
  RPROMPT="%F{#6c7086}%D{%H:%M}%f"
}

add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd  _prompt_precmd
