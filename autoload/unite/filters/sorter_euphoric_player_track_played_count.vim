let s:save_cpo = &cpo
set cpo&vim


function! unite#filters#sorter_euphoric_player_track_played_count#define()
	return s:sorter
endfunction

let s:sorter = {
\	"name" : "sorter_euphoric_player_track_played_count",
\	"description" : "sort track played_count"
\}

function! s:sorter.filter(candidates, context)
	return unite#util#sort_by(a:candidates, 'str2nr(get(v:val.source__track, "played_count", 0))')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
