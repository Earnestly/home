# ~/.config/zsh/.zshrc

# Modules
autoload -Uz edit-command-line run-help compinit zmv
zmodload zsh/complist
compinit

zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select

# Shell options
setopt autocd \
    dotglob \
    nobgnice \
    histappend \
    histverify \
    promptsubst \
    rmstarsilent \
    extendedglob \
    sharehistory \
    printexitvalue \
    histsavenodups \
    completealiases \
    numericglobsort \
    histignorespace \
    histreduceblanks \
    histignorealldups \
    interactivecomments \

READNULLCMD="$PAGER"
HELPDIR="$XDG_CONFIG_HOME"/zsh/help
HISTFILE="$XDG_CONFIG_HOME"/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE

# Style
PROMPT='%m %n %#${vimode} %F{cyan}%~%f '

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes

# Functions
# Print basic prompt to the window title
function precmd {
    print -Pn '\e];%n %~\a'
}

# Print the current running command's name to the window title
function preexec {
    local cmd=${1[(wr)^(*=*|sudo|exec|ssh|-*)]}
    print -Pn "\e];$cmd:q\a"
}

# Replace vimode indicators
function zle-line-init zle-keymap-select {
    vimode="${${KEYMAP/vicmd/c}/(main|viins)/i}"
    zle reset-prompt
}

# Keybinds
bindkey -v

# Initialise vimode to insert mode
vimode=i

# Shift-tab
bindkey $terminfo[kcbt] reverse-menu-complete

# Delete
bindkey -M vicmd $terminfo[kdch1] vi-delete-char
bindkey          $terminfo[kdch1] delete-char

# Insert
bindkey -M vicmd $terminfo[kich1] vi-insert
bindkey          $terminfo[kich1] overwrite-mode

# Home
bindkey -M vicmd $terminfo[khome] vi-beginning-of-line
bindkey          $terminfo[khome] vi-beginning-of-line

# End
bindkey -M vicmd $terminfo[kend] vi-end-of-line
bindkey          $terminfo[kend] vi-end-of-line

# Backspace (and <C-h>)
bindkey -M vicmd $terminfo[kbs] backward-char
bindkey          $terminfo[kbs] backward-delete-char

# Page up (and <C-b> in vicmd)
bindkey -M vicmd $terminfo[kpp] beginning-of-buffer-or-history
bindkey          $terminfo[kpp] beginning-of-buffer-or-history

bindkey -M vicmd '^B' beginning-of-buffer-or-history

# Page down (and <C-f> in vicmd)
bindkey -M vicmd $terminfo[knp] end-of-buffer-or-history
bindkey          $terminfo[knp] end-of-buffer-or-history

# Do history expansion on space
bindkey ' ' magic-space

# Use M-w for small words
bindkey '^[w' backward-kill-word
bindkey '^W' vi-backward-kill-word

bindkey -M vicmd '^H' backward-char
bindkey          '^H' backward-delete-char

# h and l whichwrap
bindkey -M vicmd 'h' backward-char
bindkey -M vicmd 'l' forward-char

# Incremental undo and redo
bindkey -M vicmd '^R' redo
bindkey -M vicmd 'u' undo

# Misc
bindkey -M vicmd 'ga' what-cursor-position

# Open in editor
bindkey -M vicmd 'v' edit-command-line

# History search
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Patterned history search with zsh expansion, globbing, etc.
bindkey -M vicmd '^T' history-incremental-pattern-search-backward
bindkey          '^T' history-incremental-pattern-search-backward

# Verify search result before accepting
bindkey -M isearch '^M' accept-search

# Quick and easy note taking (I should make this into a seperate script)
function n {
    $EDITOR "${@[@]/#/"$HOME/docs/notes/"}"
}
compdef "_files -W $HOME/docs/notes -/" n

function nrm {
    rm -v "${@[@]/#/"$HOME/docs/notes/"}"
}
compdef "_files -W $HOME/docs/notes -/" nrm

function nmv {
    mv -v "${@[@]/#/"$HOME/docs/notes/"}"
}
compdef "_files -W $HOME/docs/notes -/" nmv

# aliases
alias ...='cd ../..'
alias ....='cd ../../..'
alias rr='rm -rvI'
alias rm='rm -vI'
alias cp='cp -vi'
alias mv='mv -vi'
alias ln='ln -vi'
alias mkdir='mkdir -vp'

alias chmod='chmod -c --preserve-root'
alias chown='chown -c --preserve-root'
alias chgrp='chgrp -c --preserve-root'

alias ls='ls --color=auto --group-directories-first -hXF'
alias la='ls --color=auto --group-directories-first -AhXF'
alias ll='ls --color=auto --group-directories-first -lhXF'

alias dmesg='dmesg -exL'
alias weechat="exec dtach -A $XDG_RUNTIME_DIR/weechat /usr/bin/weechat"
alias mutt="exec dtach -A $XDG_RUNTIME_DIR/mutt /usr/bin/mutt -F ~/.config/mutt/muttrc"

alias ix="curl -F 'f:1=<-' ix.io"
alias sprunge="curl -F 'sprunge=<-' sprunge.us"
alias xc='xclip -o | sprunge'

# XXX force XDG_CONFIG_HOME where possible
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/ncmpcpp.conf'
alias aria2c='aria2c --dht-file-path ~/.config/aria2/dht.dat'

# Bash-like help
unalias run-help
alias help='run-help'

# Directory hashes
for d in "$HOME"/dev/^temp*(/); do
    hash -d "${d##*/}=$d"
done

# Enable C-S-t in (vte) termite which opens a new terminal in the same working
# directory.
if [[ -n "$VTE_VERSION" ]]; then
    source /etc/profile.d/vte.sh
    __vte_prompt_command
fi
