scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_euphoric_player_track_default#define()
	return s:converter
endfunction


let s:converter = {
\	"name" : "converter_euphoric_player_track_default",
\	"description" : "unite-euphoric_player default converter"
\}


function! s:resize(str, len)
	if  a:len <= 0
		return ""
	endif
	let result = a:str
	while (strwidth(result) > a:len)
		let list = split(result, '\zs')
		if len(list) == 1
			return ""
		endif
		let result = join(list[ :len(list)-2], "")
	endwhile
	return result
endfunction


function! s:converter.filter(candidates, context)
	let format = "%-30S - %-12S - %5S - %S"
	for candidate in a:candidates
		let track = candidate.source__track
		let word = printf(format, track.name, track.artist, track.time, track.album)
		let candidate.word = word
		let candidate.abbr = s:resize(word, winwidth("%")-5)
	endfor
	return a:candidates
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
