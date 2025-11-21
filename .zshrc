# 💻 Interactive shell settings

export EDITOR="code"
export VISUAL="code"
export PATH="/opt/homebrew/bin:$PATH"

# Syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# FZF with better previews
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Better ls, cat, find, grep
alias ls="eza --icons"
alias cat="bat"
alias find="fd"
alias grep="ripgrep"

# Git shortcuts
alias gs="git status -sb"
alias gc="git commit -m"
alias ga="git add ."
alias gp="git push"
alias gl="git pull --rebase"

# AI coding shortcuts
alias ai="oai chat"
alias explain="oai chat -m gpt-5.1 'Explain like I'm five:'"

# Node / TS
alias nr="npm run"
alias nd="npm run dev"
alias t="pnpm test"

echo "💡 Ready to build."

