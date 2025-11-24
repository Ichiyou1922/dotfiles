# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.local/powerlevel10k/powerlevel10k.zsh-theme

alias t='tmux'

# Go-setting
export GOROOT=/usr/local/go
export GOPATH=$HOME/.local/share/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# tex-setting
export TEXMFHOME="$HOME/.local/share/texmf"

# fzf-setting
bind '"\C-g": "\C-u\C-kcd $(ghq list -p | fzf)\e\C-e\er\C-m"'
