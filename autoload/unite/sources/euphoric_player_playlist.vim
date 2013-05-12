scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! unite#sources#euphoric_player_playlist#define()
	return s:source
endfunction

let s:source = {
\	"name" : "euphoric_player_playlist",
\	"description" : "iTunes playlist list",
\	"sorters" : "sorter_nothing",
\}


function! s:source.gather_candidates(args, context)
	let playlists = euphoric_player#playlist_list()
	return map(copy(playlists), '{
\		"word" : v:val.name,
\		"kind" : "source",
\		"action__source_name" : "euphoric_player_tracks",
\		"action__source_args" : [v:val.name],
\		"source__playlist" : v:val,
\	}')
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo



