let s:save_cpo = &cpo
set cpo&vim


function! unite#filters#sorter_euphoric_player_track_artist#define()
	return s:sorter
endfunction

let s:sorter = {
\	"name" : "sorter_euphoric_player_track_artist",
\	"description" : "sort track artist"
\}

function! s:sorter.filter(candidates, context)
	return unite#util#sort_by(a:candidates, 'get(v:val.source__track, "artist", "")')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
