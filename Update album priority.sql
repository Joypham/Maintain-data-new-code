UPDATE album_track
JOIN (
	SELECT
		album_track.TrackId,
		album_track.AlbumPriority,
		itunes_album_tracks_release.AlbumUUID,
		itunes_album_tracks_release.AlbumName,
		itunes_album_tracks_release.Artist,
		itunes_album_tracks_release.TrackArtist,
		itunes_album_tracks_release.TrackName
		
	FROM
		album_track
	JOIN itunes_album_tracks_release ON album_track.AlbumId = itunes_album_tracks_release.albumuuid
	AND itunes_album_tracks_release.TrackArtist = itunes_album_tracks_release.Artist
	AND 
	(itunes_album_tracks_release.Artist like '%Various Ar%'
	or 
	itunes_album_tracks_release.AlbumName like '%NOW That\'s What%')
where album_track.AlbumPriority <> 2
	GROUP BY
		itunes_album_tracks_release.AlbumUUID
) AS t1 ON t1.albumuuid = album_track.albumid
SET album_track.AlbumPriority = 2
