#!/usr/bin/fish

function ccd --description 'cd path by create it if not exist'
	set -l path "$argv[1]"
	mkdir -p -- "$path"
	and cd "$path"
end
