# ~/.config/zsh/.zprofile

export PATH="$HOME"/.local/bin:"$HOME"/.cabal/bin:"$PATH"

export XDG_CACHE_HOME="$HOME"/.cache
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share

export MPV_HOME="$XDG_CONFIG_HOME"/mpv
export SLRNHOME="$XDG_CONFIG_HOME"/slrn
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
export TIGRC_USER="$XDG_CONFIG_HOME"/tigrc
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME"/gimp
export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks
export XCOMPOSEFILE="$XDG_CONFIG_HOME"/XCompose
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME"/notmuchrc
export GUILE_HISTORY="$XDG_CONFIG_HOME"/guile/history
export PENTADACTYL_RUNTIME="$XDG_CONFIG_HOME"/pentadactyl
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/settings.ini

export XAUTHORITY="$XDG_RUNTIME_DIR"/X11-authority

export EDITOR=vim
export VISUAL=vim

export PAGER=less
export LESSHISTFILE="$XDG_CACHE_HOME"/lesshist

export BROWSER=firefox
export TERMINAL=termite

# Disable Mono and Gecko installation and .desktop creation
export WINEDLLOVERRIDES="winemenubuilder.exe,mscoree,mshtml=d"

export WINEARCH=win32
export WINEDEBUG=-all
export WINEPREFIX="$HOME"/.wine/default

export GREP_OPTIONS=--color=auto
export LESS=-R

export SDL_AUDIODRIVER=pulse

export GTK_IM_MODULE=xim

export GOPATH="$HOME"/dev/go

# Enable C-S-t in termite which opens a new terminal in the same working
# directory.
if [[ -n "$VTE_VERSION" ]]; then
    . /etc/profile.d/vte.sh
    __vte_osc7
fi
