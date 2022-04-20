#!/usr/bin/fish

function toggle_fb --description 'Toggle facebook host block'
	set -l url 'www.facebook.com'
	~/Scripts/toggle_domain.sh $url
end

