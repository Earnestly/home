# ~/.config/zsh/.zshrc

# modules
zmodload zsh/complist
autoload -Uz run-help   
autoload -Uz compinit
compinit

# shell options
setopt autocd \
       dotglob \
       extendedglob \
       completealiases \
       histappend \
       sharehistory \
       histignorespace \
       histignorealldups \
       histsavenodups \
       histverify \
       rmstarsilent \
       interactivecomments \
       histreduceblanks

HELPDIR=~/.config/zsh/help
HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE

# style
PROMPT='%m • %n %# %F{cyan}%~%f '

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' rehash yes

# functions
precmd() {
    print -Pn '\e];%n %~\a'
}

preexec() { 
    local cmd=${1[(wr)^(*=*|sudo|ssh|-*)]}
    print -Pn "\e];$cmd:q\a"
} 

# Quick and easy note taking
n() {
    $EDITOR "${@[@]/#/"$HOME/docs/notes/"}"
}
compdef "_files -W $HOME/docs/notes -/" n

nrm() {
    rm -v "${@[@]/#/"$HOME/docs/notes/"}"
}
compdef "_files -W $HOME/docs/notes -/" nrm

nmv() {
    mv -v "${@[@]/#/"$HOME/docs/notes/"}"
}
compdef "_files -W $HOME/docs/notes -/" nmv

# aliases
alias ...='cd ../..'
alias ....='cd ../../..'
alias rr='rm -rv'
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
alias weechat="dtach -A $XDG_RUNTIME_DIR/weechat /usr/bin/weechat"
alias mutt="dtach -A $XDG_RUNTIME_DIR/mutt /usr/bin/mutt -F ~/.config/mutt/muttrc"

alias ix="curl -F 'f:1=<-' ix.io"
alias sprunge="curl -F 'sprunge=<-' sprunge.us"

# XXX force XDG_CONFIG_HOME where possible
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/ncmpcpp.conf'
alias aria2c='aria2c --dht-file-path ~/.config/aria2/dht.dat'
alias mypaint='mypaint -c ~/.config/mypaint'

# bash-like help
unalias run-help
alias help='run-help'

# hashes
for d in "$HOME"/devel/^temp*(/); do
    hash -d "${d##*/}=$d"
done

# keybinds
bindkey -e
bindkey '^W' vi-backward-kill-word
