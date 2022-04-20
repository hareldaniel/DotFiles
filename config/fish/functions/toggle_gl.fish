#!/usr/bin/fish

function toggle_gl --description 'Toggle google host block'
	set -l url 'www.google.com'
	~/Scripts/toggle_domain.sh $url
end

