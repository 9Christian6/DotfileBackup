# source /home/christian/.zprofile

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/christian/.oh-my-zsh"

# Set emulator
# export TERMINAL="/usr/bin/xterm"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
#ZSH_THEME="apple"
DEFAULT_USER="$USER"

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
plugins=(
  zsh-autosuggestions
  )
# Keybinds
bindkey '^ ' autosuggest-accept

source $ZSH/oh-my-zsh.sh


# User configuration

#Add Bin and Opt to path
export PATH="$HOME/Bin:$PATH"
export PATH="$HOME/Opt:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='nvim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
#Print ascii art
#/home/christian/Bin/fm6000 -dog -c magenta
#/usr/local/bin/pokemon-colorscripts -r

#Print Habit stack
#cat ~/Habits

#functions
function addAlias(){echo "alias $1='$2'" >> ~/.zshrc; }
#function search(){la | grep -i $1}
function search(){lsa|awk '{print $9}' | grep -i $1}
function showInstalled(){dpkg --list "*$1*"}
function makecd(){mkdir $1 && cd $1}
function startSilent(){nohup "$@" >/dev/null 2>&1&}
function open(){nohup xdg-open "$@" >/dev/null 2>&1&}

#aliases
alias :Q='exit'
alias :q='exit'
alias :wq='exit'
alias Backup='sudo rsnapshot -v alpha'
alias DS='flatpak run org.desmume.DeSmuME'
alias M64='nohup mupen64plus ~/Opt/N64Games/Mario64.n64 &'
alias update='/home/christian/Bin/Update.sh'
alias Update='/home/christian/Bin/Update.sh'
alias cl="xdotool key ctrl+l"
#alias clear="cd . && clear"
alias cla="cl"
alias cleanmake='cmake --build . --target clean'
alias cleanmakerun='cleanmake && makerun'
alias clearmake='cmake --build . && clear'
alias cls="cd ~ && cl"
alias config='/usr/bin/git --git-dir=/home/christian/dotfiles/ --work-tree=/home/christian'
alias Dankbarkeit='$HOME/Bin/Dankbarkeit.sh'
alias delete='gio trash'
alias disableXBox='sudo systemctl stop xow.service'
alias dotfileBackup='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias editi3='nvim $HOME/.config/i3/config'
alias editPolybar='nvim $HOME/.config/polybar/config'
alias editZsh='nvim $HOME/.zshrc && source $HOME/.zshrc'
alias editZshrc='nvim $HOME/.zshrc && source $HOME/.zshrc'
alias editsway='$HOME/Bin/editsway.sh'
alias editpolybar='nvim $HOME/.config/polybar/config.ini'
alias editzsh='nvim $HOME/.zshrc && source $HOME/.zshrc'
alias editzshrc='nvim $HOME/.zshrc && source $HOME/.zshrc'
alias enableXBox='sudo systemctl start xow.service'
alias htop='btop'
alias la="ls -a"
alias lgrep='la | grep'
alias listDisks='sudo fdisk -l | grep -i "Disk /dev/sd"'
alias network='sudo nethogs'
# alias open='xdg-open'
alias scriptBackup='/usr/bin/git --git-dir=/home/christian/scripts/ --work-tree=/home/christian'
# alias sudo='doas '
# alias doas='doas '
alias sudoDotfileBackup='sudo /usr/bin/git --git-dir=/home/christian/dotfiles/ --work-tree=/home/christian'
alias sudoconfig='sudo /usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
alias tetris='vitetris'
alias vifm='$HOME/.config/vifm/scripts/vifmrun'
alias vim='nvim'
alias zshrc='nvim $HOME/.zshrc && source $HOME/.zshrc'
alias Weather='curl wttr.in/Heusweiler'
alias calculator='bc -l'
alias timer='$HOME/Bin/timer.sh'
alias lock='$HOME/Opt/i3lock-multimonitor/lock $HOME/Opt/Wallpapers/RoomAtNightCroppedWithBackground.png'
alias lsa='ls -lt -c -r'

source /home/christian/Opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
