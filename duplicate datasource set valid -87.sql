Update datasources
Join (
SELECT * from (
SELECT datasources.id,datasources.TrackId,datasources.FormatID,datasources.SourceURI,t1.joy_count,
ROW_NUMBER () over (PARTITION BY datasources.TrackID, datasources.FormatID, datasources.SourceURI ORDER BY 
datasources.Resolution DESC, datasources.updatedat DESC, datasources.createdat DESC) AS `Rankovertrack`,
datasources.CreatedAt,datasources.updatedat
from (Select id, TrackId,FormatID,SourceURI,COUNT(DISTINCT Id) as joy_count, CreatedAt,UpdatedAt
from datasources
WHERE 
Valid > 0
AND FormatID <> ''
GROUP BY FormatID, TrackId, SourceURI
HAVING COUNT(DISTINCT Id) > 1) as t1
Join datasources on datasources.TrackId = t1.TrackId 
and datasources.FormatID = t1.FormatID and datasources.SourceURI = t1.SourceURI
) as t1
WHERE
t1.Rankovertrack > 1
) as t2
on t2.id = datasources.id
set valid = -87
