# LOCALDIR/cfg/zsh/.zshrc

autoload -Uz edit-command-line run-help compinit zmv
zmodload zsh/complist
compinit

zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select

setopt auto_cd \
    glob_dots \
    hist_verify \
    hist_append \
    prompt_subst \
    share_history \
    extended_glob \
    rm_star_silent \
    hist_fcntl_lock \
    print_exit_value \
    complete_aliases \
    numeric_glob_sort \
    hist_save_no_dups \
    hist_ignore_space \
    hist_reduce_blanks \
    inc_append_history \
    hist_ignore_all_dups \
    interactive_comments

unsetopt multios

READNULLCMD=$PAGER

HISTFILE=$LOCALDIR/data/zsh/zhistory
HISTSIZE=25000
SAVEHIST=$HISTSIZE

# As we can't track directories alone with git and zsh won't make the needful
# directories either, we make them ourselves instead.
mkdir -p "$HISTFILE:h"

HELPDIR=/usr/share/zsh/$ZSH_VERSION/help
PROMPT='%m %n %#${vimode} %F{green}${repo}%F{cyan}%~%f '

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

function precmd {
    # Print basic prompt to the window title.
    print -Pn "\e];%n %~\a"

    if repo=$(git rev-parse --show-toplevel 2> /dev/null); then
        if [[ ! $repo ]]; then
            case $(git rev-parse --is-bare-repository) in
                'true') repo='bare'
            esac
        fi

        repo="${repo##*/} "
    fi
}

# Print the current running command's name to the window title.
function preexec {
    local cmd=${1//\%/}; cmd=${cmd//\$/}
    case $TERM in
        xterm-*) print -Pn "\e]2;$cmd:q\a"
    esac
}

# Replace vimode indicators.
function zle-line-init zle-keymap-select {
    vimode=${${KEYMAP/vicmd/c}/(main|viins)/i}
    zle reset-prompt
}

# Keybinds, use vimode explicitly.
bindkey -v

# Initialise vimode to insert mode.
vimode=i

# Remove the default 0.4s ESC delay, set it to 0.1s.
export KEYTIMEOUT=1

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

# Quick and easy note taking (I should make this into a seperate script).
function n {
    $EDITOR "${@[@]/#/"$HOME/doc/note/"}"
}
compdef "_files -W $HOME/doc/note -/" n

function nrm {
    rm -v "${@[@]/#/"$HOME/doc/note/"}"
}
compdef "_files -W $HOME/doc/note -/" nrm

function nmv {
    mv -v "${@[@]/#/"$HOME/doc/note/"}"
}
compdef "_files -W $HOME/doc/note -/" nmv

alias -g ...='../..'
alias -g ....='../../..'
alias rr='rm -rvI'
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias ln='ln -vi'
alias mkdir='mkdir -vp'
alias grep='grep --color=auto'

alias chmod='chmod -c --preserve-root'
alias chown='chown -c --preserve-root'
alias chgrp='chgrp -c --preserve-root'

alias ls='ls --color=auto --show-control-chars --group-directories-first -AlhXF'

alias vi='editor'
alias dmesg='dmesg -exL'
alias weechat='dtach-weechat'
alias mutt='dtach-mutt'
alias tmux="tmux -f $LOCALDIR/cfg/tmux/tmux.conf"

alias k='rlwrap k'

alias p='curl -F file=@- https://0x0.st'
alias xc='xclip -o | p'

# XXX Enforce LOCALDIR where possible.
alias aria2c="aria2c --dht-file-path $LOCALDIR/var/cache/aria2/dht.dat"
alias petite="petite --eehistory $LOCALDIR/data/chezscheme/history"
alias gdb="gdb -nh -x $LOCALDIR/cfg/gdb/init"

# XXX Package this in /etc/profile.d while switching to XDG
if hash nvidia-settings 2> /dev/null; then
    alias nvidia-settings="nvidia-settings --config=$LOCALDIR/cfg/nvidia/settings"
fi

# Bash-like help.
unalias run-help
alias help='run-help'

# Directory hashes.
if [[ -d $HOME/study ]]; then
    for d in "$HOME"/study/*(/); do
        hash -d "${d##*/}"="$d"
    done
fi

# Enable C-S-t in (vte) termite which opens a new terminal in the same working
# directory.
if [[ $VTE_VERSION ]]; then
    source /etc/profile.d/vte.sh
    __vte_prompt_command
fi
