-- UPDATE tracks
-- Join(
Select * from (
SELECT
    CONCAT('https://aimg.vibbidi-vid.com/',albums.square_image_url) as album_image_url,
		tracks.ImageURL as image_url,
    itunes_album_tracks_release.albumname,
    itunes_album_tracks_release.Artist,
    albums.TotalTracks,
		albums.ReleaseDate,
    itunes_album_tracks_release.AlbumUUID,
    tracks.id as trackid,
    
    ROW_NUMBER () over (PARTITION BY tracks.id ORDER BY albums.TotalTracks DESC,albums.ReleaseDate DESC) AS `Rankovertrack`
FROM
    itunes_album_tracks_release
JOIN albums ON albums.UUID = itunes_album_tracks_release.AlbumUUID
AND albums.valid > 0 and (albums.title not like '%NOW That\'s What%' and albums.title not like '%NOW Party Anthems%')
and albums.square_image_url is not NULL
JOIN tracks ON tracks.Title = itunes_album_tracks_release.TrackName
AND itunes_album_tracks_release.TrackArtist = tracks.Artist
AND tracks.valid = 1 

and 
tracks.Id in 
(
'B7FF39E2F37B4C379766E3CC1BBA7262'
)
where
itunes_album_tracks_release.Artist <> 'Various Artists'
and
itunes_album_tracks_release.AlbumName not like '%NOW That\'s What%'
and 
itunes_album_tracks_release.AlbumName not like '%NOW Party Anthems%'
and
itunes_album_tracks_release.Valid = 1
) as t1
where 
t1.Rankovertrack = 1
and
(t1.image_url <> t1.album_image_url or t1.image_url is null)
order by 
trackid,
t1.Rankovertrack asc
-- ) as t2
-- on t2.trackid = tracks.id
-- SET
-- tracks.ext = Json_set(if(ext is null,JSON_OBJECT(),ext), '$.album_image_albumuuid',t2.albumuuid),
-- tracks.ImageURL = t2.album_image_url

