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

