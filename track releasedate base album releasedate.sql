UPDATE tracks
Join (
Select * from 
(SELECT
	itunes_album_tracks_release.AlbumUUID,
	itunes_album_tracks_release.AlbumName,
	itunes_album_tracks_release.Seq,
	itunes_album_tracks_release.TrackName,
	itunes_album_tracks_release.TrackArtist,
	tracks.Id as trackid,
	albums.Valid,
	albums.ReleaseDate as album_release_date,
	tracks.ReleaseDate as tracks_release_date,
	ROW_NUMBER () over ( PARTITION BY tracks.id ORDER BY tracks.Id, albums.ReleaseDate ASC ) AS `RankOverTrack`
FROM
	itunes_album_tracks_release
JOIN tracks ON tracks.Title = itunes_album_tracks_release.TrackName
AND tracks.Artist = itunes_album_tracks_release.TrackArtist
AND tracks.Valid > 0
and
tracks.title not like '%Karaoke%'
and
tracks.id = '84FB6B30D9044FCEA6F19C117EB848A1'


Join albums on albums.uuid =itunes_album_tracks_release.AlbumUUID and albums.valid = 1

and albums.ReleaseDate 
where 
itunes_album_tracks_release.Artist not like '%Various Artists%'
and
itunes_album_tracks_release.AlbumName not like '%NOW That\'s What%' and itunes_album_tracks_release.AlbumName not like '%NOW Party Anthems%'
) as t1
where 
RankOverTrack = 1
and 
(album_release_date <> tracks_release_date
or 
tracks_release_date is null
or 
tracks_release_date = ''
)
order by trackname, trackartist
) as t3
On tracks.id = t3.trackid 
set 
tracks.ext = JSON_SET(IFNULL(tracks.Ext, JSON_OBJECT()),'$.albumuuid_releasedate',t3.Albumuuid,'$.releasedate',t3.album_release_date)
