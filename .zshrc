# ---- History ----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt sharehistory

# ---- Options ----
setopt autocd
setopt correct
setopt interactivecomments
setopt nocaseglob

# ---- Completion ----
autoload -Uz compinit && compinit
zstyle ':completion:*' list-colors ''

# ---- PATH ----
export PATH="$HOME/.local/bin:$PATH"

# ---- Pywal ----
(cat ~/.cache/wal/sequences &)
source ~/.cache/wal/colors.sh

# ---- Starship (LAST) ----
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

alias fetch=fastfetch
alias i_deletaur='yay -Rs'
alias i_delete='sudo pacman -Rs'
alias i_update='sudo pacman -Syu'
alias i_updateaur='yay -Syu'
alias i_want='sudo pacman -S'
alias i_wantaur='yay -S'
alias ls=lsd
alias please=sudo
alias vv=nvim

