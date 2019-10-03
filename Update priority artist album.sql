Update artist_album
set Priority = 2
WHERE
AlbumId in (
select * from (Select id from albums
where 
UUID in (
select * from (Select DISTINCT(album_track.AlbumId) from album_track
where AlbumPriority = 2) as t1
)) as t2
)
