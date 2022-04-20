#!/usr/bin/env fish

# environment variables
export MPD_HOST="master@$HOME/.mpd/socket"
export EDITOR=vim
export MANPAGER='nvim +Man!'
export BEMENU_OPTS='-l 10 --fn universal'
set -a PATH ~/.local/bin

# aliases
alias ':q'=exit
alias la="ls -A"
alias pa="~/Scripts/playlist_manage.sh start"
alias po="~/Scripts/playlist_manage.sh stop"
alias pg="~/Scripts/playlist_manage.sh generate"
alias pt="~/Scripts/playlist_manage.sh toggle"
alias cal="cal -s"		# sunday as first day of week
alias free="free -h"
alias df="df -h"
alias syu="sudo pacman -Syu"
alias tor="transmission-remote"
abbr e 'echo'

# Functions
function fish_command_not_found
	echo "Command not found: '$argv[1]'"
end
