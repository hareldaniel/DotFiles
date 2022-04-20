#!/usr/bin/fish

function toggle_yt --description 'Toggle youtube host block'
	set -l url 'www.youtube.com'
	~/Scripts/toggle_domain.sh $url
end

