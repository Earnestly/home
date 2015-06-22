# XDG_CONFIG_HOME/zsh/.zshrc

# Modules.
autoload -Uz edit-command-line run-help compinit zmv
zmodload zsh/complist
compinit

zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select

# Shell options.
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
    hist_ignore_space \
    hist_reduce_blanks \
    inc_append_history \
    hist_ignore_all_dups \
    interactive_comments

READNULLCMD=$PAGER
HELPDIR=/usr/share/zsh/$ZSH_VERSION/help
HISTFILE=$XDG_CONFIG_HOME/zsh/.zhistory
HISTSIZE=25000
SAVEHIST=$HISTSIZE

# Style.
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

PROMPT='%m %n %#${vimode}%F{green}${branch}%f%F{cyan}%~%f '

# Functions.
# All I want is the git branch for now, vcs_info is way overkill to do this.
function get_git_branch {
    if [[ -d .git ]]; then
        read -r branch < .git/HEAD
        branch=" ${branch##*/} "
    else
        branch=" "
    fi
}

# Print basic prompt to the window title.
function precmd {
    print -Pn "\e];%n %~\a"
    get_git_branch
}

# Print the current running command's name to the window title.
function preexec {
    if [[ $TERM == xterm-* ]]; then
        local cmd=${1[(wr)^(*=*|sudo|exec|ssh|-*)]}
        print -Pn "\e];$cmd:q\a"
    fi
}

# Replace vimode indicators.
function zle-line-init zle-keymap-select {
    vimode=${${KEYMAP/vicmd/c}/(main|viins)/i}
    zle reset-prompt
}

# Simple widget for quoting the current word or the previous if cursor
# positioned on a blank.
function quote-word {
    zle vi-forward-word
    zle vi-backward-blank-word
    zle set-mark-command
    zle vi-forward-blank-word-end
    zle quote-region
}
zle -N quote-word

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

# Quote the current or previous word.
bindkey -M vicmd 'Q' quote-word

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

# Aliases.
alias -g ...='../..'
alias -g ....='../../..'
alias rr='rm -rvI'
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias ln='ln -vi'
alias mkdir='mkdir -vp'
alias grep='grep --color=auto'

alias e='emacsclient -t'

alias chmod='chmod -c --preserve-root'
alias chown='chown -c --preserve-root'
alias chgrp='chgrp -c --preserve-root'

alias ls='ls --color=auto --show-control-chars --group-directories-first -AhXF'
alias ll='ls --color=auto --show-control-chars --group-directories-first -AlhXF'

alias dmesg=dmesg -exL
alias weechat='dtach-weechat'
alias mutt='dtach-mutt'
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

alias k='rlwrap k'

alias i="curl -F 'f:1=<-' ix.io"
alias s="curl -F 'sprunge=<-' sprunge.us"
alias p="curl -F 'c=@-' https://ptpb.pw"
alias xc='xclip -o | i'

# XXX force XDG_CONFIG_HOME where possible.
alias ncmpcpp="ncmpcpp -c $XDG_CONFIG_HOME/ncmpcpp/ncmpcpp.conf"
alias aria2c="aria2c --dht-file-path $XDG_CACHE_HOME/aria2/dht.dat"
alias gdb="gdb -nh -x $XDG_CONFIG_HOME/gdb/init"

# Bash-like help.
unalias run-help
alias help='run-help'

# Directory hashes.
if [[ -d $HOME/dev ]]; then
    for d in $HOME/dev/*(/); do
        hash -d ${d##*/}=$d
    done
fi

# Enable C-S-t in (vte) termite which opens a new terminal in the same working
# directory.
if [[ -n $VTE_VERSION ]]; then
    source /etc/profile.d/vte.sh
    __vte_prompt_command
fi
