SELECT t2.name, COUNT(*) from 
(
SELECT 
t1.*,
ROW_NUMBER () over (PARTITION BY t1.TrackId ORDER BY FormatID_priority ASC) AS `Rankovertrack`  
from 

(
SELECT tracks.Title,tracks.Artist,artists.UUID as artist_UUID,artists.`Name`,artist_track.TrackId,
datasources.FormatID,
datasources.Sourceuri,
if(datasources.FormatID = '74BA994CF2B54C40946EA62C3979DDA3','1','2') as FormatID_priority,
datasources.DisplayStatus
from artists
Join artist_track on artist_track.ArtistId = artists.UUID
Join tracks on tracks.id = artist_track.TrackId and tracks.Valid > 0
Join datasources on datasources.TrackId = tracks.Id and datasources.Valid > 0
and datasources.FormatID in ('74BA994CF2B54C40946EA62C3979DDA3','1A67A5F1E0D84FB9B48234AE65086375') and datasources.DisplayStatus = 1

where 
artists.name in 
(
"Cardi B"
)
and 
artists.Valid > 0
GROUP BY
tracks.Id,
datasources.FormatID,
datasources.SourceURI
ORDER BY TrackId
)
as t1
) as t2
WHERE t2.Rankovertrack = 1
GROUP BY t2.artist_UUID

ORDER BY 
t2.TrackID,
Rankovertrack ASC
