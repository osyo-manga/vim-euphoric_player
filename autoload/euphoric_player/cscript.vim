scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:root = substitute(expand("<sfile>:p:h"), '\\', '/', 'g')
if executable("cscript")
	let s:playlist_script = s:root."/euphoric_player_playlist.js"
	let s:playlist_list_script = s:root."/euphoric_player_playlist_list.js"
	let s:play_track_script = s:root."/euphoric_player_play_track.js"
else
	let s:playlist_script = ""
	let s:playlist_list_script = ""
endif


let s:has_vimproc = 0
silent! let s:has_vimproc = vimproc#version()

function! s:system(expr)
	return s:has_vimproc ? vimproc#system(a:expr) : system(a:expr)
endfunction

function! s:cscript(expr)
	return iconv(s:system(iconv(printf("cscript /Nologo %s", a:expr), &enc, "sjis")), "sjis", &enc)
endfunction

function! euphoric_player#cscript#playlist_list()
	return eval(get(split(s:cscript(s:playlist_list_script), "\n"), 0, []))
endfunction

function! euphoric_player#cscript#playlist(...)
	let playlist_name = get(a:, 1, "")
	return eval(get(split(s:cscript(s:playlist_script . " " . string(playlist_name)), "\n"), 0, []))
endfunction

function! euphoric_player#cscript#play_track(trackname, ...)
	let trackname = a:trackname
	let playlist_name = get(a:, 1, "")
	return eval(get(split(s:cscript(s:play_track_script . " " . string(trackname) . " " . string(playlist_name)), "\n"), 0, []))
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
