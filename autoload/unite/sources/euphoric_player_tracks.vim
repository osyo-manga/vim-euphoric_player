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
\	"converters" : "converter_euphoric_player_track_default"
\}

function! s:source.action_table.play_track.func(candidate)
	call euphoric_player#play_track(a:candidate.action__track_name, a:candidate.action__playlist_name)
endfunction

function! s:source.gather_candidates(args, context)
	let playlist = call("euphoric_player#playlist", a:args)
	if !has_key(playlist, "tracks")
		return []
	endif

	return map(copy(playlist.tracks), '{
\		"word" : printf("%s - %s", v:val.name, v:val.artist),
\		"action__track_name"    : v:val.name,
\		"action__playlist_name" : playlist.name,
\		"source__track" : v:val
\	}')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

