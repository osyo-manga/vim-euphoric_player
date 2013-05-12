scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! euphoric_player#win_ruby#playlist_list()
	let result = []
ruby << EOF
	require "win32ole"
	require "kconv"

	$encode = VIM::evaluate("&enc")

	itunes  = WIN32OLE.new("iTunes.Application")
	playlists = itunes.librarySource.Playlists
	playlists.each { |playlist|
		dict = <<EOS
add(result, {
	"name" : "#{playlist.Name.gsub('"', '\\"')}",
	"size" : "#{playlist.Size.to_i}",
	"time" : "#{playlist.Time}",
	"playlistID" : "#{playlist.PlaylistID}",
})
EOS
		VIM::evaluate(dict.split("\n").join.encode($encode))
	}
EOF
	return result
endfunction


function! euphoric_player#win_ruby#playlist(...)
	let playlist_name = get(a:, 1, "")
	let result = {}
ruby << EOF
	require "win32ole"
	require "kconv"

	$encode = VIM::evaluate("&enc")

def add_playlist(playlist)
	if !playlist
		return
	end
	dict = <<EOS
	let result = {
		"name" : "#{playlist.Name.encode($encode)}",
		"size" : "#{playlist.Size.to_i}",
		"time" : "#{playlist.Time}",
		"playlistID" : "#{playlist.PlaylistID}",
		"tracks" : [],
	}
EOS
	VIM::command(dict.split("\n").join)

	tracks_expr = "let result.tracks = ["
	playlist.Tracks.each { |track|
		lyrics = track.Lyrics.gsub('"', '\\"').gsub("\r", "\\n")
		dict = <<EOS
			{
				"name" : "#{track.Name.gsub('"', '\\"')}",
				"artist" : "#{track.Artist.gsub('"', '\\"')}",
				"album" : "#{track.Album.gsub('"', '\\"')}",
				"album_artist" : "#{track.AlbumArtist.gsub('"', '\\"')}",
				"size" : "#{track.Size.to_i}",
				"time" : "#{track.Time}",
				"played_count" : "#{track.PlayedCount}",
				"trackID" : "#{track.TrackID}",
				"lyrics" : "#{lyrics}",
			},
EOS
		tracks_expr = tracks_expr + dict
	}
	tracks_expr += "]"
	VIM::command(tracks_expr.split("\n").join.encode($encode))
end

itunes  = WIN32OLE.new("iTunes.Application")

playlist_name = VIM::evaluate("playlist_name").tosjis
if playlist_name.empty?
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


function! euphoric_player#win_ruby#play_track(trackname, ...)
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

function! euphoric_player#win_ruby#tracks()
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
