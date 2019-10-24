* Match new artist_album

INSERT INTO artist_album (albumid,artistid,valid)
SELECT AlbumId,ArtistId_joy, 1 as valid from (

Select albums.uuid,albums.Id as AlbumId, albums.Valid,albums.Title,artist_album.ArtistId,itunes_album_tracks_release.Artist,artists.id as ArtistId_joy from albums
left join artist_album on artist_album.albumid = albums.Id
join itunes_album_tracks_release on itunes_album_tracks_release.AlbumUUID = albums.UUID
join artists on artists.`Name` = itunes_album_tracks_release.Artist and artists.Valid > 0

where 
artist_album.ArtistId is null
AND
albums.Valid = 1
group by
albums.UUID
 ) as t1
-- where 
-- AlbumId = 306771967486546
group by albumid


* Remove wrong artist albums

SELECT
	albums.UUID AS albumuuid,
	albums.Id AS album_id,
	albums.Title AS album_title,
	artists.`Name` AS artist_name,
	artists.id AS artist_id,
	itunes_album_tracks_release.Artist as artist_album_itune
FROM
	albums
JOIN artist_album ON albums.id = artist_album.AlbumId
JOIN artists ON artists.Id = artist_album.ArtistId
AND artists.Valid > 0
JOIN itunes_album_tracks_release ON itunes_album_tracks_release.AlbumUUID = albums.UUID
and artists.`Name` <> itunes_album_tracks_release.Artist
WHERE
	albums.valid = 1
-- and albums.id = '56472540716429'
-- and
-- artists.id = '352744755425905'
group by
albums.UUID


