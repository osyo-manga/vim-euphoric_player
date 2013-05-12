let s:save_cpo = &cpo
set cpo&vim


function! unite#filters#sorter_euphoric_player_track_name#define()
	return s:sorter
endfunction

let s:sorter = {
\	"name" : "sorter_euphoric_player_track_name",
\	"description" : "sort track name"
\}

function! s:sorter.filter(candidates, context)
	return unite#util#sort_by(a:candidates, 'get(v:val.source__track, "name", "")')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
