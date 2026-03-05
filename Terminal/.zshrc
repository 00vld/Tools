# ~/.zshrc file for zsh interactive shells.
# Kali Linux default + custom updates

##### ZSH OPTIONS #####

setopt autocd
setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst

WORDCHARS='_-'
PROMPT_EOL_MARK=""

##### KEYBINDINGS #####

bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo

##### COMPLETION #####

autoload -Uz compinit
fpath=(~/.zsh/completions $fpath)
compinit -d ~/.cache/zcompdump

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose true

##### HISTORY #####

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify

alias history="history 0"
alias ssh='TERM=xterm-256color ssh'

##### TIME FORMAT #####

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

##### DEBIAN CHROOT #####

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

##### COLOR PROMPT DETECTION #####

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if command -v tput >/dev/null && tput setaf 1 >/dev/null 2>&1; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

##### PROMPT CONFIG (KALI DEFAULT) #####

configure_prompt() {
    prompt_symbol=㉿
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            ;;
    esac
    unset prompt_symbol
}

##### KALI PROMPT FLAGS #####

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

if [ "$color_prompt" = yes ]; then
    VIRTUAL_ENV_DISABLE_PROMPT=1
    configure_prompt
fi

##### TERMINAL TITLE #####

case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|ghostty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
    ;;
esac

precmd() {
    print -Pnr -- "$TERM_TITLE"
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -n "$_NEW_LINE_BEFORE_PROMPT" ]; then
            print ""
        fi
        _NEW_LINE_BEFORE_PROMPT=1
    fi
}

##### LS / GREP COLORS #####

if command -v dircolors >/dev/null; then
    eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias ip='ip --color=auto'
fi

##### AUTOSUGGESTIONS #####

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
fi

##### SYNTAX HIGHLIGHTING #####

if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

##### TMUX AUTOSTART #####

if command -v tmux &>/dev/null; then
    if [ -z "$TMUX" ]; then
        tmux attach -t main || tmux new -s main
    fi
fi

##### FZF #####

[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

export FZF_DEFAULT_OPTS="
--height=40%
--layout=reverse
--border
--cycle
--inline-info
--preview-window=right:60%:wrap
--bind=ctrl-u:preview-page-up,ctrl-d:preview-page-down
--bind=ctrl-k:preview-up,ctrl-j:preview-down
"

##### SAFE CLEAR (KEEP TMUX SCROLLBACK) #####

clear() {
  printf '\033[H'
}

##### TMUX-ONLY MINIMAL PROMPT #####

if [[ -n "$TMUX" ]]; then
  PROMPT="❯ "
  RPROMPT=""
fi

# Ensure proper colors over SSH
if [[ -n "$SSH_CONNECTION" ]]; then
  export TERM=xterm-256color
fi

## Alias
export PATH="$HOME/vpn/bin:$PATH"
alias hosts='cat /etc/hosts'
