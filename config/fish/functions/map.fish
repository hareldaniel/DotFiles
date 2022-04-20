#!/usr/bin/fish

function map \
	--description 'runs command for each line of stdin, by write it to stdin of command'
	while read line
		echo "$line" | eval "$argv"
	end
end

