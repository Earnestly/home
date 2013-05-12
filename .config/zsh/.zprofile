# ~/.config/zsh/.zprofile

export PATH="$HOME/bin:$PATH"

export BROWSER=firefox

# Force $XDG_CONFIG_HOME where possible
export GTK2_RC_FILES=~/.config/gtk-2.0/settings.ini
export MPV_HOME=~/.config/mpv
export QUVI_HOME=~/.config/quvi

export EDITOR=vim
export VISUAL=vim

export PAGER=less
export LESSHISTFILE=-
export TERMINAL=termite

export WINEARCH=win32
export WINEDEBUG=-all
export WINEDLLOVERRIDES=winemenubuilder.exe=d

export GREP_OPTIONS=--color=auto
export LESS=-R

export SDL_AUDIODRIVER=pulse

# Start systemd --user
#if ! pgrep -u $USER systemd &> /dev/null; then
#	systemd --user &
#fi
