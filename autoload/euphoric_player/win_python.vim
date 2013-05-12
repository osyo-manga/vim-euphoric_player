scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! euphoric_player#win_python#playlist_list()
	let result = []
python << EOF
import vim
import win32com.client

encode = vim.eval("&enc")

itunes = win32com.client.Dispatch("iTunes.Application")
playlists = itunes.librarySource.Playlists

result_expr = "let result = ["
for playlist in playlists:
	name = playlist.Name.replace('"', '\\"').encode(encode)
	size = playlist.Size
	time = playlist.Time.replace('"', '\\"').encode(encode)
	playlistID = playlist.PlaylistID
	result_expr += '''
{
	"name" : "%(name)s",
	"size" : "%(size)s",
	"time" : "%(time)s",
	"playlistID" : "%(playlistID)s",
},
''' % (locals());

result_expr += "]"

vim.command("".join(result_expr.split("\n")))
EOF
	return result
endfunction



function! euphoric_player#win_python#playlist(...)
	let playlist_name = get(a:, 1, "")
	let result = {}
ruby << EOF
import win32com.client

itunes = win32com.client.Dispatch("iTunes.Application")
playlists = itunes.librarySource.Playlists

playlist_name = vim.eval("playlist_name").encode("shift-jis")

if playlist_name == ""
	add_playlist(itunes.CurrentPlaylist)
else
	playlist = itunes.librarySource.Playlists.ItemByName(playlist_name)
	if playlist
		add_playlist(playlist)
	end
end
EOF

	return result
endfunction


function! euphoric_player#win_python#play_track(trackname, ...)
	let track_name = a:trackname
	let playlist_name = get(a:, 1, "")
	let result = 0
ruby << EOF
	require "win32ole"
	require "kconv"

playlist_name = VIM::evaluate("playlist_name").tosjis
track_name = VIM::evaluate("track_name").tosjis

itunes  = WIN32OLE.new("iTunes.Application")
if playlist_name.empty?
	playlist = itunes.CurrentPlaylist
else
	playlist = itunes.librarySource.Playlists.ItemByName(playlist_name)
	if !playlist
		playlist = itunes.CurrentPlaylist
	end
end

track = playlist.Tracks.ItemByName(track_name)
if track
	track.Play()
else
	VIM::command("let result = -1")
end
EOF

	return result
endfunction

function! euphoric_player#win_python#tracks()
	let result = []
ruby << EOF
	require "win32ole"
	require "kconv"

itunes  = WIN32OLE.new("iTunes.Application")

tracks = itunes.libraryPlaylist.Tracks

result = "let result = ["
tracks.each { |track|
#	lyrics = track.Lyrics.toutf8.gsub("\"", "'").gsub("\r", "\\n")
	dict = <<EOS
	{
		"name" : "#{track.Name.toutf8.gsub("\"", "'")}",
		"artist" : "#{track.Artist.toutf8.gsub("\"", "'")}",
		"album" : "#{track.Album.toutf8.gsub("\"", "'")}",
		"album_artist" : "#{track.AlbumArtist.toutf8.gsub("\"", "'")}",
		"size" : "#{track.Size.to_i}",
		"time" : "#{track.Time}",
		"played_count" : "#{track.PlayedCount}",
		"trackID" : "#{track.TrackID}",
	},
EOS
	result = result + dict
}
result += "]"

VIM::command(result.split("\n").join)
EOF

	return result
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
