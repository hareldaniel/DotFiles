#!/usr/bin/fish

function country --description 'print the current country according public ip'
	curl 'https://api.myip.com/' 2> /dev/null |
		jq -r '.country'
end

