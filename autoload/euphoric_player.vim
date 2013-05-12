scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:is_win = has("win16") || has("win32") || has("win64")

function! euphoric_player#backend()
	return get(g:, "euphoric_player_backend",
\		  has("ruby") && s:is_win ? "win_ruby"
\		: executable("cscript")   ? "cscript"
\		: ""
\	)

endfunction

function! s:call(expr, ...)
	let backend = euphoric_player#backend()
	if !empty(backend)
		return call(printf("euphoric_player#%s#%s", backend, a:expr), a:000)
	else
		echo "Not support " . backend
	endif
endfunction


function! euphoric_player#playlist(...)
	return call("s:call", ["playlist"]  + a:000)
endfunction


function! euphoric_player#playlist_list()
	return s:call("playlist_list")
endfunction


function! euphoric_player#play_track(trackname, ...)
	return call("s:call", ["play_track"] + [a:trackname] + a:000)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
