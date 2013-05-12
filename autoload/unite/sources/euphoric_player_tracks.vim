scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! unite#sources#euphoric_player_tracks#define()
	return s:source
endfunction

let s:source = {
\	"name" : "euphoric_player_tracks",
\	"sorters" : "sorter_nothing",
\	"is_volatile" : 0,
\	"description" : "iTunes playlist tracks",
\	"action_table" : {
\		"play_track" : {
\			"description" : "play",
\			"is_selectable" : 0,
\		}
\	},
\	"default_action" : "play_track",
\}

function! s:source.action_table.play_track.func(candidate)
	call euphoric_player#play_track(a:candidate.action__track_name, a:candidate.action__playlist_name)
endfunction

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


function! s:source.gather_candidates(args, context)
	let playlist = call("euphoric_player#playlist", a:args)
	if !has_key(playlist, "tracks")
		return []
	endif
	let format = "%-30S - %-12S - %5S - %S"
	return map(copy(playlist.tracks), '{
\		"abbr" : s:resize(printf(format, v:val.name, v:val.artist, v:val.time, v:val.album), winwidth("%")-5),
\		"word" : printf(format, v:val.name, v:val.artist, v:val.time, v:val.album),
\		"action__track_name"    : v:val.name,
\		"action__playlist_name" : playlist.name,
\	}')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

