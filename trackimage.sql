UPDATE tracks
Join(
Select * from (
SELECT
    CONCAT('https://aimg.vibbidi-vid.com/',albums.square_image_url) as album_image_url,
    albums.TotalTracks,
    itunes_album_tracks_release.AlbumUUID,
    tracks.id as trackid,
    SUBSTRING_INDEX(tracks.ImageURL,'/',-3) as image_url,
    ROW_NUMBER () over (
        PARTITION BY tracks.id
        ORDER BY
            albums.TotalTracks DESC
    ) AS `Rankovertrack`
FROM
    itunes_album_tracks_release
JOIN albums ON albums.UUID = itunes_album_tracks_release.AlbumUUID
AND albums.valid > 0
JOIN tracks ON tracks.Title = itunes_album_tracks_release.TrackName
AND itunes_album_tracks_release.TrackArtist = tracks.Artist
AND tracks.valid > 0
and tracks.id = '8B5897EA55894899B2ABE3F2732193CD'
) as t1
where 
t1.Rankovertrack = 1
and 
(t1.image_url <> t1.album_image_url or t1.image_url is null)
) as t2
on t2.trackid = tracks.id
SET
tracks.ext = Json_set(if(ext is null,JSON_OBJECT(),ext), '$.album_image_albumuuid',t2.albumuuid),
tracks.ImageURL = t2.album_image_url
