var itunes    = WScript.CreateObject('iTunes.Application');

var args = WScript.Arguments;
if( args.length < 1 ){
	WScript.Echo("-1");
	WScript.quit(0);
}

if( args.length == 1 ){
	var track_name = args(0);
	var playlist = itunes.CurrentPlaylist
}
else{
	var track_name = args(0);
	var playlist_name = args(1);
	var playlist = itunes.librarySource.Playlists.ItemByName(playlist_name);
	if( !playlist ){
		playlist = itunes.CurrentPlaylist;
	}
}


var track = playlist.Tracks.ItemByName(track_name);
if( track ){
	track.Play();
	WScript.Echo("0");
}
else{
	WScript.Echo("-1");
}

