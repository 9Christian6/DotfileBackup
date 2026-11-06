# source /home/christian/.zprofile
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#Define Screen names
export PRIMARYSCREEN=$(/home/christian/Bin/getScreenName.sh 0)
export SECONDARYSCREEN=$(/home/christian/Bin/getScreenName.sh 1)

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/christian/.oh-my-zsh"

#Path to binaries and optionals
export BIN="/home/christian/Bin"
export OPT="/home/christian/Opt"

#Path to config directory
export CONFIG="/home/christian/.config"

#Path to trash directory
export TRASH="/home/christian/.local/share/Trash"

export CLICOLOR_FORCE=1
export GREP_COLORS='ms=92:me=39:sl=0'

export ANSIWEATHERRC="/home/christian/.config/ansiweather/ansiweatherrc"
unset DEBUG_INFOD_URLS

# Tell QT applications to use qt6ct
export QT_QPA_PLATFORMTHEME=qt6ct

# Set emulator
# export TERMINAL="/usr/bin/xterm"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# source /home/christian/Opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/christian/.zshrc.pre-oh-my-zsh

preexec() {
  export LEFT_PROMPT_LINE="$(print -P -- ${(qqq)PROMPT})"
  export RIGHT_PROMPT_LINE="$(print -P -- ${(qqq)RPROMPT})"
}

function set_kitty_title_preexec() {
    print -Pn "\e]0;Kitty: %~\a"
}

function set_kitty_title_precmd() {
    print -Pn "\e]0;Kitty: %~\a"
}

add-zsh-hook preexec set_kitty_title_preexec
add-zsh-hook precmd set_kitty_title_precmd
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git vi-mode zsh-syntax-highlighting)

plugins=( zsh-syntax-highlighting zsh-autosuggestions git )

source $ZSH/oh-my-zsh.sh

#enable zsh autocomplete after git commands
compdef -d git
#completion after git command
zstyle ':completion:*:*:git:*' user-commands new-branch:'custom new branch function'

#---------------------------------------------------------------------
#User conf////////////////////////////////////////////////////////////
#---------------------------------------------------------------------
# WebDAV performance fix - disable synchronous operations
if [[ "$PWD" == *"Nextcloud"* ]] || [[ "$PWD" == *"remote"* ]]; then
  # Disable command not found handler (major cause of lag)
  unset command_not_found_handle
  unset COMMAND_NOT_FOUND_INSTALL_PROMPT

    # Disable directory size calculation in prompt
    PS1='\u@\h:\W\$ '  # Simple prompt without path expansion

    # Disable tab completion for large directories
    complete -o nospace -F _nothing 2>/dev/null

    # Disable history file writes on every command
    unset HISTFILE

    # Disable terminal title updates
    unset PROMPT_COMMAND

    # Use simple line editing
    set +o emacs
    set +o vi
fi

#Add Bin and Opt to path
export PATH="$HOME/Bin:$PATH"
export PATH="$HOME/Opt:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/Opt/PythonEnvs/myVirtualEnv/bin:$PATH"
export PATH="$HOME/.devcontainers/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export XDG_CONFIG_HOME="$HOME/.config"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Enable vi mode
set -o vi

function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    printf '\e[2 q'   # block cursor
  else
    printf '\e[6 q'   # beam cursor
  fi
}

function zle-line-init {
  printf '\e[6 q'     # beam when starting insert mode
}

zle -N zle-keymap-select
zle -N zle-line-init

# Keybinds
bindkey '^ ' autosuggest-accept

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [ -f "$HOME/.aliases" ]; then
  . "$HOME/.aliases"
fi

if [ -f "$HOME/.functions" ]; then
  . "$HOME/.functions"
fi

. "$HOME/.local/share/../bin/env"
#---------------------------------------------------------------------
#User conf\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#---------------------------------------------------------------------

#Ollama env variables
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_API_KEY=""
export ANTHROPIC_BASE_URL=http://localhost:11434
export OLLAMA_NUM_PARALLEL=1
export OLLAMA_MAX_LOADED_MODELS=1
export OLLAMA_GPU_LAYERS=9999
export OPENAI_BASE_URL="http://localhost:11434/v1"
export OPENAI_API_KEY="ollama"
export OLLAMA_HOST="http://localhost:11434"
export OLLAMA_NUM_GPU=999          # Force full GPU offload
export OLLAMA_CONTEXT_LENGTH=4096  # Keep KV cache in VRAM (8K+ may swap)

# NPM global bin (added by Qwen Code installer)
export PATH="$HOME/.npm-global/bin:$PATH"

# OpenClaw Completion
[ -f "/home/christian/.openclaw/completions/openclaw.zsh" ] && source "/home/christian/.openclaw/completions/openclaw.zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/christian/Opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/christian/Opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/christian/Opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/christian/Opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export SYSTEMD_EDITOR=nvim
