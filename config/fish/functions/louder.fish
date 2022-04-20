#!/usr/bin/fish

function louder --description 'increase volue for each mp3 file in current dir'
	mkdir louder
	for i in *.mp3
		ffmpeg -i "$i" -b:a 320k -filter:a "volume=$argv[1]" "louder/$i"
	end
end

