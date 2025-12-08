# HOME/.local/etc/zsh/.zshrc
# Requires /etc/zsh/zshenv to export ZDOTDIR=$HOME/.local/etc/zsh

autoload -Uz edit-command-line run-help compinit zmv
zmodload zsh/complist
compinit

zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select

setopt auto_cd \
    glob_dots \
    extended_glob \
    prompt_subst \
    rm_star_silent \
    print_exit_value \
    complete_aliases \
    numeric_glob_sort \
    hist_verify \
    hist_append \
    hist_fcntl_lock \
    hist_save_no_dups \
    hist_ignore_space \
    hist_ignore_all_dups \
    share_history \
    inc_append_history \
    interactive_comments

# This is the behaviour of the shell without disabling multios:
#   % { print stdout; print stderr >&2; } 2>&1 > /dev/null | xargs
#   stderr stdout
unsetopt multios

READNULLCMD=$PAGER

HISTFILE=$HOME/.local/share/zsh/zhistory
HISTSIZE=50000
SAVEHIST=$HISTSIZE

# Create the needed directories here as git can't track empty directories and
# zsh won't make them.
if [[ ! -d $HISTFILE:h ]]; then
    mkdir -p -- "$HISTFILE:h"
fi

HELPDIR=/usr/share/zsh/$ZSH_VERSION/help

PROMPT='${SSH_CONNECTION+%m }%n $vimode ${repo:+$repo }%F{cyan}%~%f '

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes

source <(dircolors)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

function precmd {
    # Print basic prompt to the window title.
    print -Pn "\e];%n %~\a"

    case $(git rev-parse --is-bare-repository 2> /dev/null) in
    false)
        repo=%F{green}${"$(git rev-parse --show-toplevel)":t}%f
        branch=$(git symbolic-ref --short HEAD)

        case $branch in
        master|main) ;;
        *) repo+="%F{red} $branch%f"
        esac

    ;;
    true)
        repo=%F{blue}${"$(git rev-parse --git-dir)":P:t}%f
    ;;
    *)
        repo=
    esac
}

# Print the current running command's name to the window title.
function preexec {
    printf '\e]2;%s\a' "$1"
}

# Replace vimode indicators.
function zle-line-init zle-keymap-select {
    vimode=${${KEYMAP/vicmd/c}/main/i}
    zle reset-prompt
}

# Keybinds, use vimode explicitly.
bindkey -v

# Initialise vimode to insert mode.
vimode=i

# Remove the default 0.4s ESC delay, set it to 0.1s.
KEYTIMEOUT=1

# Shift-tab.
bindkey $terminfo[kcbt] reverse-menu-complete

# Delete.
bindkey -M vicmd $terminfo[kdch1] vi-delete-char
bindkey          $terminfo[kdch1] delete-char

# Insert.
bindkey -M vicmd $terminfo[kich1] vi-insert
bindkey          $terminfo[kich1] overwrite-mode

# Home.
bindkey -M vicmd $terminfo[khome] vi-beginning-of-line
bindkey          $terminfo[khome] vi-beginning-of-line

# End.
bindkey -M vicmd $terminfo[kend] vi-end-of-line
bindkey          $terminfo[kend] vi-end-of-line

# Backspace (and <C-h>).
bindkey -M vicmd $terminfo[kbs] backward-char
bindkey          $terminfo[kbs] backward-delete-char

# Page up (and <C-b> in vicmd).
bindkey -M vicmd $terminfo[kpp] beginning-of-buffer-or-history
bindkey          $terminfo[kpp] beginning-of-buffer-or-history

# Page down (and <C-f> in vicmd).
bindkey -M vicmd $terminfo[knp] end-of-buffer-or-history
bindkey          $terminfo[knp] end-of-buffer-or-history

bindkey -M vicmd '^B' beginning-of-buffer-or-history

# Do history expansion on space.
bindkey ' ' magic-space

# Use M-w for small words.
bindkey '^[w' backward-kill-word
bindkey '^W' vi-backward-kill-word

bindkey -M vicmd '^H' backward-char
bindkey          '^H' backward-delete-char

# h and l whichwrap.
bindkey -M vicmd 'h' backward-char
bindkey -M vicmd 'l' forward-char

# Incremental undo and redo.
bindkey -M vicmd '^R' redo
bindkey -M vicmd 'u' undo

# Misc.
bindkey -M vicmd 'ga' what-cursor-position

# Open in editor.
bindkey -M vicmd 'v' edit-command-line

# History search.
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Patterned history search with zsh expansion, globbing, etc.
bindkey -M vicmd '^T' history-incremental-pattern-search-backward
bindkey          '^T' history-incremental-pattern-search-backward

# Verify search result before accepting.
bindkey -M isearch '^M' accept-search

alias -g ...='../..'
alias -g ....='../../..'
alias rm='rm -vI'
alias cp='cp -avi'
alias mv='mv -vi'
alias ln='ln -vi'
alias mkdir='mkdir -vp'
alias grep='grep --color=auto'

alias chmod='chmod -c --preserve-root'
alias chown='chown -c --preserve-root'
alias chgrp='chgrp -c --preserve-root'

alias ls='ls --color=auto --show-control-chars --group-directories-first -AlhXF'

alias v='editor'
alias vi='editor'
alias dmesg='dmesg -exL'

# Bash-like help.
unalias run-help
alias help='run-help'

# Quick note taking.
function n { vi -- "${@[@]/#/"$HOME"/doc/note/}" }
compdef "_files -W $HOME/doc/note" n

# XXX Temporary!
function s { vi -- "${@[@]/#/"$HOME"/CENTRAL/}" }
compdef "_files -W $HOME/CENTRAL" s

# Directory hashes.
if [[ -d $HOME/study ]]; then
    for d in "$HOME"/study/*(/); do
        tmp+=("${d:t}"="$d")
    done
    hash -d "${tmp[@]}"
    unset d tmp
fi
