#!/usr/bin/fish

function dist --description 'print the distribution of any first word'
	awk '
		{
			k[$0]++
		}

		END {
			for (i in k) {
				print k[i], i
			}
		}' |
		sort -nr
end
