// iTunes のプレイリストを JSON で返す

function string(value){
	return "\"" + value.toString().split("\"").join("\\\"") + "\"";
}

function pair(first, second){
	return string(first) + ":" + string(second);
}


function track_to_json(track){
	return "{"
		      + pair("name", track.Name)
		+ "," + pair("artist", track.Artist)
		+ "," + pair("album_artist", track.AlbumArtist)
		+ "," + pair("album", track.Album)
		+ "," + pair("time", track.Time)
		+ "," + pair("played_count", track.PlayedCount)
		+ "," + pair("size", track.Size)
		+ "," + pair("trackID", track.TrackID)
		+ "," + pair("lyrics", track.Lyrics.replace(/[\n]/g, "\\n").replace(/[\r]/g, ""))
// 		+ "," + pair("lyrics", track.Lyrics.replace(/[\n]/g,""))
// 		+ "," + pair("lyrics", track.Lyrics.replace(/[\n]/g,"<br>").replace(/[\r]/g, ""))
// 		+ "," + pair("lyrics", track.Lyrics.replace(/[\n\r]/g, "\\n"))
// 		+ "," + pair("lyrics", track.Lyrics)
	+ "}"
}

function playlist_to_json(playlist){
	var result = "{"
		+ pair("name", playlist.Name) + ","
		+ pair("size", playlist.Size) + ","
		+ pair("time", playlist.Time) + ","
		+ pair("playlistID", playlist.PlaylistID) + ",";

	result += string("tracks") + ":[";

	for(var i = 1; i < playlist.Tracks.Count; ++i){
		var track = playlist.Tracks(i);
		result += track_to_json(track) + ",";
	}

	result += "]";

	result += "}";
	return result;
}



var itunes    = WScript.CreateObject('iTunes.Application');

var args = WScript.Arguments;
if(args.length == 0){
	WScript.Echo(playlist_to_json(itunes.CurrentPlaylist));
}
if(args.length == 1){
	var playlists = itunes.librarySource.Playlists;
	var playlist  = playlists.ItemByName(args(0));
	if( playlist ){
		WScript.Echo(playlist_to_json(playlist));
	}
	else{
		WScript.Echo("{}");
	}
}


// function disp_playlist(playlist){
// 	WScript.Echo(playlist.Name);
// 	WScript.Echo(playlist.Tracks.Count);
// 	for(var i = 1; i < playlist.Tracks.Count; ++i){
// 		var track = playlist.Tracks(i);
// 		var name = track.Name;
// 		var artist = track.Artist;
// // 		WScript.Echo(name + " : " + artist);
// 	}
// }


// WScript.Echo(playlists.Count);
// for(var i = 0; i < playlists.Count; ++i) {
// 	var playlist = playlists.Item(i+1);
// 	disp_playlist(playlist);
// // 	WScript.Echo(playlists.Item(i+1).Name);
// }



// disp_playlist(itunes.CurrentPlaylist);
// disp_playlist(itunes.libraryPlaylist);

// WScript.Echo(playlists.Count);
// for(var i = 0; i < playlists.Count; ++i) {
// 	WScript.Echo(playlists.Item(i+1).Name);
// };

// var playlist = playlists.Item(1);
// WScript.Echo(playlist.Name)
// WScript.Echo(play_lists.Item(1).Name);
// 
// var playlists = itunes.Playlists;
// WScript.Echo(playlists.Count)

// var args = WScript.Arguments;
// WScript.Echo(args(0))

// WScript.Echo(Number(arg(0)))
// WScript.Echo(playlists)

// for(var i = 1; i <= tracks.count; ++i){
//   var track = tracks.item(i);
//   WScript.Echo(track.name + "\t" + track.trackID);
// }


/* 
var library   = itunes.librarySource;
var playlists = library.playlists;
var playlist  = playlists.item(2); // Music
var tracks    = playlist.tracks;
 */
/* 
for(var i = 1; i <= tracks.count; ++i){
  var track = tracks.item(i);
  WScript.Echo(track.name + "\t" + track.trackID);
}
 */


