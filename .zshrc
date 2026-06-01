setopt HIST_VERIFY
setopt NO_BEEP
setopt printeightbit
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit && compinit -u

path=(
	$HOME/bin
	$HOME/.local/bin
	$HOME/Library/Python/3.9/bin
	$(brew --prefix)/opt/llvm/bin
	$path
)
export PATH
export EDITOR=nvim
export VISUAL=nvim

[[ -f /usr/bin/xcrun ]] && export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

PROMPT='%S+%sMacBook%S+%se235718:%~$ '

alias vi='nvim'
alias vim='nvim'
alias top='htop'
alias ls='ls -GF'
alias h='fc -l -d -20'
alias code.='code .'
alias code,='code .'
alias firefox='open -a FireFox'
alias chatgpt="open -a FireFox https://chatgpt.com"

code() {
	if [[ "$1" == "," ]]; then
		command code .
	else
		command code "$@"
	fi
}

fs() {
	if [[ $# == 0 ]]; then
		echo "Usage: fs [size] (e.g., fs 13, fs 11.5)"
		return 1
	fi

	new_size=$1
	toml_path="$HOME/.config/alacritty/alacritty.toml"

	if [ -f $toml_path ]; then
		sed -i '' "s/size *= *[0-9.]*/size = $new_size/" $toml_path
		echo "Alacritty font size changed to $new_size"
	else
		echo "Error: alacritty.toml not found at $toml_path"
	fi
}

export FZF_DEFAULT_OPTS="--bind 'ctrl-j:down,ctrl-k:up,ctrl-n:down,ctrl-p:up'"
source <(fzf --zsh)

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
