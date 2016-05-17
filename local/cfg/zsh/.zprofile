# LOCALDIR/cfg/zsh/.zprofile

export LOCALDIR="$HOME/local"

export PATH="$LOCALDIR/bin:$PATH"

export XDG_DATA_HOME="$LOCALDIR/data"
export XDG_CONFIG_HOME="$LOCALDIR/cfg"
export XDG_CACHE_HOME="$LOCALDIR/var/cache"

export SVDIR="$LOCALDIR/service"
export GNUPGHOME"=$LOCALDIR/cfg/gnupg"
export INPUTRC="$LOCALDIR/cfg/inputrc"
export RLWRAP_HOME="$LOCALDIR/data/rlwrap"
export DVDCSS_CACHE="$LOCALDIR/cfg/dvdcss"
export TIGRC_USER="$LOCALDIR/cfg/tig/tigrc"
export WEECHAT_HOME="$LOCALDIR/cfg/weechat"
export PERL_CPANM_HOME="$LOCALDIR/cfg/cpanm"
export WINEPREFIX="$LOCALDIR/cfg/wine/default"
export ELINKS_CONFDIR="$LOCALDIR/cfg/elinks"

# <https://github.com/jkbrzt/httpie/issues/145>
export HTTPIE_CONFIG_DIR="$LOCALDIR/cfg/httpie"

export LESSHISTFILE="$LOCALDIR/var/cache/less/history"
export GTK2_RC_FILES="$LOCALDIR/cfg/gtk-2.0/gtkrc"
export NOTMUCH_CONFIG="$LOCALDIR/cfg/notmuch/notmuchrc"

export TERMINFO_DIRS="$LOCALDIR/data/terminfo:/usr/share/terminfo"
export UNCRUSTIFY_CONFIG="$LOCALDIR/cfg/uncrustify/uncrustify.cfg"

# Chicken libraries.
export CHICKEN_REPOSITORY="$LOCALDIR/lib/chicken"
export CHICKEN_INCLUDE_PATH="$LOCALDIR/lib/chicken"

# Perl libraries.
export PERL5LIB="$LOCALDIR/lib/perl5"
export PERL_MM_OPT="INSTALL_BASE=$LOCALDIR"
export PERL_MB_OPT="--install_base $LOCALDIR"

export GOPATH="$LOCALDIR/lib/go"

# xkbcommon understands XKB environments which is useful as wayland compositors
# will be able to use them.  The syntax is the same as Xorg's configuration.
export XKB_DEFAULT_LAYOUT="us"
export XKB_DEFAULT_OPTIONS="compose:ralt,ctrl:nocaps"
 
# See ~/local/cfg/X11/xinitrc
#export XAUTHORITY="$XDG_RUNTIME_DIR/X11/XAuthority"

# A recent change in GTK now hardcodes HOME/.XCompose but will look for
# "Compose" in XDG_CONFIG_HOME/gtk-3.0/Compose.
# <https://git.gnome.org/browse/gtk+/commit/?id=a41f02f9b1843e0f00>
export GTK_IM_MODULE="xim"
export XCOMPOSEFILE="$LOCALDIR/cfg/X11/XCompose"

# General exports.
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim -Z"
export LESS="-RX"
export PAGER="less"
export BROWSER="qutebrowser"
export TERMINAL="termite"
export WINEARCH="win32"
export WINEDEBUG="-all"
export SDL_AUDIODRIVER="pulse"

# Disable initial installation of Mono and Gecko; prevent .desktop creation.
export WINEDLLOVERRIDES="winemenubuilder.exe,mscoree,mshtml=d"

# LS_COLORS (or a valid TERM, which I don't have) is now required for ls to
# use colour.  <https://savannah.gnu.org/forum/forum.php?forum_id=8032>
source <(dircolors "$LOCALDIR/cfg/coreutils/dircolors")
 
# Nvidia specific, I should include this under conditional hostname expansion.
export __GL_SHADER_DISK_CACHE_PATH="$LOCALDIR/var/cache/nvidia/"
export CUDA_CACHE_PATH="$LOCALDIR/var/cache/nvidia"

# Unused exports, but kept as backups if their need ever arises.
# export SLRNHOME="$XDG_CONFIG_HOME/slrn"
# export STACK_ROOT="$XDG_DATA_HOME/stack"
# export CARGO_HOME="$XDG_DATA_HOME/cargo"
# export LYNX_CFG_PATH="$XDG_CONFIG_HOME/lynx"
# export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"
# export CABAL_CONFIG="$XDG_DATA_HOME/cabal/config"
# export GUILE_HISTORY="$XDG_CONFIG_HOME/guile/history"
 
# XXX Requires program code in an environment, this is not ideal but means one
#     less symlink and one less dotfile.
# export VIMPERATOR_INIT=":source $XDG_CONFIG_HOME/vimperator/vimperatorrc"
# export VIMPERATOR_RUNTIME="$XDG_DATA_HOME/vimperator"
