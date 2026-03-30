# This theme requires nerd fonts
# https://github.com/ryanoasis/nerd-fonts

# edit these to change behavior
# possible values are defined in the function "define_chars" below
set_settings() {
  SEPARATOR_SET=$ARROW
  SEPARATOR_MODE=$SEPARATOR_MODE_ALL_LEFT_BUT_LAST
  START_SYMBOL=$EMPTY
  SYMBOL_MODE=$SYMBOL_MODE_ENABLED
}

define_chars() {
  # Separators
  ARROW=($'\ue0b2'$'\ue0b0')
  ICE_WAVEFORM=($'\ue0ca'$'\ue0c8')
  PIXELATED_SQUARE=($'\ue0c7'$'\ue0c6')
  PIXELATED_SQUARE_SMALL=($'\ue0c5'$'\ue0c4')
  TRAPAZOID=($'\ue0d4'$'\ue0d2')
  HALF_CIRCLE=($'\ue0b6'$'\ue0b4')

  # Separator Modes
  SEPARATOR_MODE_ALL_RIGHT=0
  SEPARATOR_MODE_ALL_RIGHT_BUT_FIRST=1
  SEPARATOR_MODE_ALL_LEFT_BUT_LAST=2
  SEPARATOR_MODE_ALL_LEFT=3

  # Symbol Modes
  SYMBOL_MODE_DISABLED=0
  SYMBOL_MODE_ENABLED=1

  # Start Symbols
  EMPTY=''
  ARCH_LINUX=$'\uf303'
  DEBIAN=$'\uf306'
  UBUNTU=$'\uf31b'
  APPLE=$'\uf302'
  TUX=$'\uf31a'
  GNOME=$'\uf7ab'
  BIOHAZARD=$'\ue286'
}

set_chars() {
  SEPARATOR_LEFT="${SEPARATOR_SET[1]}"
  SEPARATOR_RIGHT="${SEPARATOR_SET[2]}"
}

CURRENT_BG='NONE'
CURRENT_FG='white'
FIRST_SEPARATOR_SET=false
DEFAULT_BG='black'

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    if [[ $SEPARATOR_MODE == $SEPARATOR_MODE_ALL_RIGHT ]]; then
      # Right
      echo -n " %{$bg%F{$CURRENT_BG}%}$SEPARATOR_RIGHT%{$fg%} "
    elif [[ $SEPARATOR_MODE == $SEPARATOR_MODE_ALL_RIGHT_BUT_FIRST ]]; then
      if [[ $FIRST_SEPARATOR_SET != true ]]; then
        # Left
        echo -n " %F{$1}$SEPARATOR_LEFT%{$bg%}%{$fg%} "
      else
        # Right
        echo -n " %{$bg%F{$CURRENT_BG}%}$SEPARATOR_RIGHT%{$fg%} "
      fi
    else
      # Left
        echo -n " %F{$1}$SEPARATOR_LEFT%{$bg%}%{$fg%} "
    fi
    FIRST_SEPARATOR_SET=true
  else
    if [[ $3 == $EMPTY ]]; then
      echo -n "%{$bg%}%{$fg%}"
    else
      echo -n "%{$bg%}%{$fg%} "
    fi
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    if [[ $SEPARATOR_MODE == $SEPARATOR_MODE_ALL_LEFT ]]; then
      echo -n " %F{$DEFAULT_BG}$SEPARATOR_LEFT"
    else
      echo -n " %{%k%F{$CURRENT_BG}%}$SEPARATOR_RIGHT"
    fi
  fi
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black red "%n@%m"
  fi
}

### show symbol
prompt_symbol() {
  if [[ $SYMBOL_MODE == $SYMBOL_MODE_ENABLED ]]; then
    prompt_segment black white "$START_SYMBOL"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path

   if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment $GIT_UNCHANGED_BG $GIT_UNCHANGED_FG
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment white black '%~'
}

## Main prompt
build_prompt() {
  define_chars
  set_settings
  set_chars

  RETVAL=$?

  prompt_symbol

  # Set bold
  echo -n '%B'

  # Segments
  #prompt_context
  prompt_dir
  prompt_git
  prompt_end

  # Unset bold
  echo -n '%b'
}

PROMPT='%{%f%k%}$(build_prompt)%{%f%k%} '
