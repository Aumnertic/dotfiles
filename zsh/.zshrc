# ~/.zshrc
# Interactive shell configuration for zsh on macOS.

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# History
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt prompt_subst

# Path helpers
path_prepend() {
  [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}

path_append() {
  [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"
}

# Core user paths
path_prepend "${HOME}/.local/bin"
path_prepend "${HOME}/bin"

# Homebrew paths, Apple Silicon first, Intel fallback.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  path_prepend /opt/homebrew/bin
  path_prepend /opt/homebrew/sbin
  path_prepend /usr/local/bin
  path_prepend /usr/local/sbin
fi

# macOS system paths
path_append /usr/bin
path_append /bin
path_append /usr/sbin
path_append /sbin

# Completion
# Load this after Homebrew so brew-installed completions are available.
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]]; then
  fpath=("${HOMEBREW_PREFIX}/share/zsh/site-functions" $fpath)
fi
autoload -Uz compinit
compinit

# nvm
export NVM_DIR="${HOME}/.nvm"
if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
  source "${NVM_DIR}/nvm.sh"
fi
if [[ -s "${NVM_DIR}/bash_completion" ]]; then
  source "${NVM_DIR}/bash_completion"
fi

# Node defaults
export NPM_CONFIG_PREFIX=""

# Editor and pager
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="${PAGER:-less}"
export LESS="-R"

# Common aliases
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias grep="grep --color=auto"
alias bs="base64"
alias bsd="base64 -d"
alias sg="ast-grep"

# Modern command replacements
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --group-directories-first --icons=auto"
  alias ll="eza -lah --git --group-directories-first --icons=auto"
  alias la="eza -a --group-directories-first --icons=auto"
  alias tree="eza --tree --group-directories-first --icons=auto"
elif command -v lsd >/dev/null 2>&1; then
  alias ls="lsd --group-dirs first"
  alias ll="lsd -lah --group-dirs first"
  alias la="lsd -A --group-dirs first"
  alias tree="lsd --tree --group-dirs first"
fi
if command -v bat >/dev/null 2>&1; then
  alias cat="bat --paging=never"
fi
# if command -v fd >/dev/null 2>&1; then
#   alias find="fd"
# fi

# zsh plugins
ZSH_PLUGIN_DIR="${HOME}/.zsh/plugins"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
if [[ -s "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
  autosuggest_accept_or_complete() {
    if [[ -n "$POSTDISPLAY" ]]; then
      zle autosuggest-accept
    else
      zle expand-or-complete
    fi
  }
  zle -N autosuggest_accept_or_complete
  bindkey '^I' autosuggest_accept_or_complete
  bindkey '^F' autosuggest-accept
  bindkey '^G' autosuggest-clear
fi

# WezTerm sends Home/End for Cmd-Left/Right. Bind both terminal variants.
for keymap in emacs viins vicmd; do
  bindkey -M "$keymap" $'\e[H' beginning-of-line
  bindkey -M "$keymap" $'\eOH' beginning-of-line
  bindkey -M "$keymap" $'\e[F' end-of-line
  bindkey -M "$keymap" $'\eOF' end-of-line
done

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Git prompt
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%a)%f'
precmd() {
  vcs_info
}

# Prompt
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %# '

export PATH

# Syntax highlighting should be loaded last.
if [[ -s "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi




# Secrets (API keys etc.) live outside this repo.
[[ -f "$HOME/.zshrc.secrets" ]] && source "$HOME/.zshrc.secrets"

# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# Android development
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
path_prepend "$JAVA_HOME/bin"
path_prepend "$ANDROID_HOME/platform-tools"

# Xcode 26.6 (user install under ~/Applications, no sudo / xcode-select change).
# DEVELOPER_DIR is required for libghostty's Metal shader build: the system
# CLT has no `xcrun metal` / `metallib`, this Xcode does (via the mounted
# MetalToolchain cryptex).
if [[ -d "${HOME}/Applications/Xcode.app/Contents/Developer" ]]; then
  export DEVELOPER_DIR="${HOME}/Applications/Xcode.app/Contents/Developer"
elif [[ -n "$DEVELOPER_DIR" && ! -d "$DEVELOPER_DIR" ]]; then
  # Stale value inherited from a long-lived session (e.g. Xcode was removed
  # after this terminal was started). Without this, xcrun and the /usr/bin/git
  # shim fail with "missing DEVELOPER_DIR path".
  unset DEVELOPER_DIR
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# Remove stale today path entries inherited from older shells.
path=(${path:#$HOME/today/target/release})

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[[ ":$PATH:" != *":$HOME/.config/kaku/zsh/bin:"* ]] && export PATH="$HOME/.config/kaku/zsh/bin:$PATH" # Kaku PATH Integration
[[ -f "$HOME/.config/kaku/zsh/kaku.zsh" ]] && source "$HOME/.config/kaku/zsh/kaku.zsh" # Kaku Shell Integration

export PATH="$HOME/projects/pso:$PATH"
