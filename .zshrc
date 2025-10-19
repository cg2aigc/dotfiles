# ~/.config/.zshrc - Reconstructed with Zimfw + Starship
# ------------------------------------------------------------
[ -f "$HOME/.config/zsh/zshrc" ] && source "$HOME/.config/zsh/zshrc"


# 🖥 macOS自动化测试环境变量 Puppeteer / Chrome
export CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
# fpath=(/Users/PhoenixC/.docker/completions $fpath)
# autoload -Uz compinit
# compinit
# End of Docker CLI completions

# bun completions
[ -s "/Users/PhoenixC/.bun/_bun" ] && source "/Users/PhoenixC/.bun/_bun"

