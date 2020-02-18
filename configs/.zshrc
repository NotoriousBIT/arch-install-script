# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.7.1

## HISTORY
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

#
CASE_SENSITIVE="false"
setopt MENU_COMPLETE
setopt no_list_ambiguous

autoload -Uz compinit
compinit

## Colorize the ls output ##
LS_COLORS='fi=0;93:'
export LS_COLORS
zstyle ':completion:*' menu yes select list-colors ${(s.:.)LS_COLORS}

alias ls='ls --color=always'

## Colorize the exa output
export EXA_COLORS="fi=38;5;16:"

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -la --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing

source /home/testsystem/git/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

ZLE_RPROMPT_INDENT=0

POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='#ffa300'

POWERLEVEL9K_OS_ICON_FOREGROUND='#282a38'
POWERLEVEL9K_DIR_HOME_FOREGROUND='#282a38'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='#282a38'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='#282a38'
POWERLEVEL9K_DIR_FOREGROUND='#282a38'

POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#282a38'
POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#282a38'
