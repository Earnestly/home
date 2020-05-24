# HOME/.local/etc/zsh/.zprofile

export PATH="$HOME/.local/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.local/etc"
export XDG_CACHE_HOME="$HOME/.local/var/cache"

export SVDIR="$HOME/.local/var/service"
export CCACHE_DIR="$HOME/.local/share/ccache"
export IPFS_PATH="$HOME/.local/srv/ipfs"
export GNUPGHOME"=$HOME/.local/etc/gnupg"
export INPUTRC="$HOME/.local/etc/inputrc"
export RLWRAP_HOME="$HOME/.local/share/rlwrap"
export PLTUSERHOME="$HOME/.local/share/racket"
export DVDCSS_CACHE="$HOME/.local/etc/dvdcss"
export TIGRC_USER="$HOME/.local/etc/tig/tigrc"
export WEECHAT_HOME="$HOME/.local/etc/weechat"
export PERL_CPANM_HOME="$HOME/.local/etc/cpanm"
export WINEPREFIX="$HOME/.local/etc/wine/default"
export ELINKS_CONFDIR="$HOME/.local/etc/elinks"

export LESSHISTFILE="$HOME/.local/var/cache/less/history"
export GTK2_RC_FILES="$HOME/.local/etc/gtk-2.0/gtkrc"
export NOTMUCH_CONFIG="$HOME/.local/etc/notmuch/notmuchrc"

export TERMINFO_DIRS="$HOME/.local/share/terminfo:/usr/share/terminfo"
export UNCRUSTIFY_CONFIG="$HOME/.local/etc/uncrustify/uncrustify.cfg"

# Chicken libraries.
export CHICKEN_REPOSITORY="$HOME/.local/lib/chicken"
export CHICKEN_INCLUDE_PATH="$HOME/.local/lib/chicken"

# Perl libraries.
# export PERL5LIB="$HOME/.local/lib/perl5"
# export PERL_MM_OPT="INSTALL_BASE=$HOME/.local"
# export PERL_MB_OPT="--install_base $HOME/.local"

export GOPATH="$HOME/.local/lib/go"

# xkbcommon understands XKB environments which is useful as wayland compositors
# will be able to use them.  The syntax is the same as Xorg's configuration.
export XKB_DEFAULT_LAYOUT="us"
export XKB_DEFAULT_OPTIONS="compose:ralt,ctrl:nocaps"

# A recent change in GTK now hardcodes HOME/.XCompose but will look for
# "Compose" in XDG_CONFIG_HOME/gtk-3.0/Compose.
# <https://git.gnome.org/browse/gtk+/commit/?id=a41f02f9b1843e0f00>
export GTK_IM_MODULE="xim"
export XCOMPOSEFILE="$HOME/.local/etc/X11/XCompose"

# General exports.
export EDITOR="editor"
# export VISUAL="visual"
export SUDO_EDITOR="editor -Z"
export LESS="-RX"
export PAGER="less"
export BROWSER="web"
export TERMINAL="terminal"
export WINEARCH="win32"
export WINEDEBUG="-all"
export SDL_AUDIODRIVER="pulse"

# Disable initial installation of Mono and Gecko; prevent .desktop creation.
export WINEDLLOVERRIDES="winemenubuilder.exe,mscoree,mshtml=d"

# LS_COLORS (or a valid TERM, which I don't have) is now required for ls to
# use colour.  <https://savannah.gnu.org/forum/forum.php?forum_id=8032>
# source <(dircolors "$HOME/.local/etc/coreutils/dircolors")

# Unused exports, but kept as backups if their need ever arises.
# export SLRNHOME="$XDG_CONFIG_HOME/slrn"
# export STACK_ROOT="$XDG_DATA_HOME/stack"
# export CARGO_HOME="$XDG_DATA_HOME/cargo"
# export LYNX_CFG_PATH="$XDG_CONFIG_HOME/lynx"
# export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"
# export CABAL_CONFIG="$XDG_DATA_HOME/cabal/config"
# export GUILE_HISTORY="$XDG_CONFIG_HOME/guile/history"
# export VIMPERATOR_INIT=":source $XDG_CONFIG_HOME/vimperator/vimperatorrc"
# export VIMPERATOR_RUNTIME="$XDG_DATA_HOME/vimperator"
