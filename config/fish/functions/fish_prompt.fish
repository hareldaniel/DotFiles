#!/usr/bin/fish

function fish_prompt --description 'Write out the prompt'
	set -l color_cwd
    set -l suffix
	set -l color_success
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$'
    end

	if test $status = 0
		set color_success (set_color -o green)
	else
		set color_success (set_color -o red)
	end

    echo -n -s $color_success (prompt_basename) (owner) ' ' (set_color -o cyan) (parse_branch_name) (set_color -o white) "$suffix " (set_color normal)
end

function owner
	set -l owner (stat -c %U .)
	if test $owner != $USER
		printf "%s:%s" (set_color -o magenta) $owner
	end
end

function prompt_basename
	if test $PWD = $HOME
		echo '~'
	else
		basename $PWD
	end
end

function parse_branch_name
	git branch 2> /dev/null | awk '$1 ~ /\*/ {print "(" $2 ") ";}'
end

