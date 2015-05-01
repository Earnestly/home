# XDG_CONFIG_HOME/zsh/.zprofile

export PATH=$HOME/.local/bin:$HOME/.cabal/bin:$PATH

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

export SLRNHOME=$XDG_CONFIG_HOME/slrn

# https://github.com/mozilla/rr/issues/1455#issuecomment-89714904
export _RR_TRACE_DIR=$XDG_DATA_HOME/rr

export CARGO_HOME=$XDG_DATA_HOME/cargo
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg
export INPUTRC=$XDG_CONFIG_HOME/inputrc
export RLWRAP_HOME=$XDG_DATA_HOME/rlwrap
export LYNX_CFG_PATH=$XDG_CONFIG_HOME/lynx
export TIGRC_USER=$XDG_CONFIG_HOME/tig/tigrc

# XXX This always seems to complain about no directory being found, not sure
#     why.
#export DVDCSS_CACHE =$XDG_CACHE_HOME/dvdcss

export PERL_CPANM_HOME=$XDG_CACHE_HOME/cpanm
export GIMP2_DIRECTORY=$XDG_CONFIG_HOME/gimp
export ELINKS_CONFDIR=$XDG_CONFIG_HOME/elinks
export XCOMPOSEFILE=$XDG_CONFIG_HOME/x11/xcompose
export HTTPIE_CONFIG_DIR=$XDG_CONFIG_HOME/httpie
export GUILE_HISTORY=$XDG_CONFIG_HOME/guile/history
export VIMPERATOR_RUNTIME=$XDG_CONFIG_HOME/vimperator
export PENTADACTYL_RUNTIME=$XDG_CONFIG_HOME/pentadactyl
export NOTMUCH_CONFIG=$XDG_CONFIG_HOME/notmuch/notmuchrc
export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/settings.ini


# Perl libraries.
export PERL5LIB=$HOME/.local/lib/perl5
export PERL_MM_OPT=INSTALL_BASE=$HOME/.local
export PERL_MB_OPT="--install_base $HOME/.local"

export GOPATH=$HOME/dev/go

# Xorg and XKB.
export GTK_IM_MODULE=xim
export XKB_DEFAULT_LAYOUT=gb
export XKB_DEFAULT_OPTIONS=compose:ralt,ctrl:nocaps
export XAUTHORITY=$XDG_RUNTIME_DIR/x11/xauthority

export EDITOR=vim
export VISUAL=vim
export SUDO_EDITOR=rvim

export LESS=-RX

export PAGER=less
export LESSHISTFILE=$XDG_CACHE_HOME/less/history

export BROWSER=firefox
export TERMINAL=termite

# LS_COLORS (or a valid TERM, which I don't have) is now required for `ls` to
# use colour.
source <(dircolors $XDG_CONFIG_HOME/terminal-colors.d/ls.enable)

# Disable Mono and Gecko installation and .desktop creation.
export WINEDLLOVERRIDES=winemenubuilder.exe,mscoree,mshtml=d
export WINEPREFIX=$XDG_DATA_HOME/wine/default
export WINEARCH=win32
export WINEDEBUG=-all

export SDL_AUDIODRIVER=pulse
