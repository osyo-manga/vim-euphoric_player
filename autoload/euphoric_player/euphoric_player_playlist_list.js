// iTunes のプレイリストのリストを JSON で返す

function string(value){
	return "\"" + value + "\""
}

function pair(first, second){
	return string(first) + ":" + string(second);
}

function playlist_to_json(playlist){
	return "{"
		+ pair("name", playlist.Name) + ","
		+ pair("size", playlist.Size) + ","
		+ pair("time", playlist.Time) + ","
		+ pair("playlistID", playlist.PlaylistID)
	+ "}"
}

var itunes    = WScript.CreateObject('iTunes.Application');
var playlists = itunes.librarySource.Playlists;

var result = "[";

for(var i = 0; i < playlists.Count; ++i) {
	var playlist = playlists.Item(i+1);
// 	disp_playlist(playlist);
	result += playlist_to_json(playlist) + ",";
}

result += "]";

WScript.Echo(result)

