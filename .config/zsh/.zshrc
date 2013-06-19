# ~/.config/zsh/.zshrc

# modules
zmodload zsh/complist
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
       histreduceblanks

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

alias dmesg='dmesg -eL'
alias weechat-curses='dtach -A $XDG_RUNTIME_DIR/weechat weechat-curses -d ~/.config/weechat'

alias ix="curl -F 'f:1=<-' ix.io"

# force XDG_CONFIG_HOME where possible
alias irssi='irssi --home=~/.config/irssi'
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/ncmpcpp.conf'
alias gliv='gliv -g$HOME/.config/gliv/glivrc'
alias aria2c='aria2c --dht-file-path ~/.config/aria2/dht.dat'
alias mypaint='mypaint -c ~/.config/mypaint'

bindkey -e
