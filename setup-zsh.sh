#!/usr/bin/env bash
set -e

echo "Installing Zsh and tools..."

sudo apt update
sudo apt install -y \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    fzf \
    zoxide

echo "Configuring user Zsh..."

sudo chsh -s /usr/bin/zsh "$USER"

cat > "$HOME/.zshrc" <<'EOF'
# Zsh autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh

# zoxide
eval "$(zoxide init zsh)"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Keyboard
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word

# Prompt
setopt PROMPT_SUBST

prompt_symbol() {
    local exit_status=$?

    if [[ $exit_status -eq 0 ]]; then
        PROMPT_SYMBOL='%F{green}%%%f'
    else
        PROMPT_SYMBOL='%F{red}%%%f'
    fi
}

precmd_functions+=(prompt_symbol)

PROMPT='%F{cyan}%m%f %F{blue}%~%f ${PROMPT_SYMBOL} '
EOF

echo "Configuring root Zsh..."

sudo chsh -s /usr/bin/zsh root

sudo tee /root/.zshrc > /dev/null <<'EOF'
# Zsh autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh

# zoxide
eval "$(zoxide init zsh)"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Keyboard
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word

# Root prompt
PROMPT='%F{red}%m%f %F{yellow}%~%f %F{red}#%f '
EOF

echo
echo "Zsh setup complete."
echo "Log out and log back in to start using Zsh."