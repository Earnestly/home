# ~/.config/zsh/.zprofile

export PATH="$HOME"/bin:"$PATH"

export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_DIRS=/usr/local/share/:/usr/share/

export XDG_CACHE_HOME=~/.cache
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share

export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/settings.ini
export MPV_HOME="$XDG_CONFIG_HOME"/mpv
export QUVI_HOME="$XDG_CONFIG_HOME"/quvi
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg

export EDITOR=vim
export VISUAL=vim

export PAGER=less
export LESSHISTFILE=-

export BROWSER=firefox
export TERMINAL=termite

export WINEARCH=win32
export WINEDEBUG=-all
export WINEPREFIX="$HOME"/.wine/default
export WINEDLLOVERRIDES=winemenubuilder.exe=d

export GREP_OPTIONS=--color=auto
export LESS=-R

export SDL_AUDIODRIVER=pulse

export GTK_IM_MODULE=xim
