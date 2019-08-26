Update datasources
Join (
SELECT
		t5.*, 
		row_number () over (
		PARTITION BY t5.artistid,
		t5.sourceuri
	ORDER BY
		t5.count_distict_youtubeurl_groupby_trackid desc, 
		t5.Resolution DESC,
		t5.CreatedAt DESC
	) AS rownum
FROM
	(
		SELECT
			t4.artistid,
			tracks.title,
			tracks.Artist,
			t4.count_distict_youtubeurl_groupby_trackid,
			datasources.*
		FROM
			(


				Select t3.artistid,t3.trackid,t3.count_distict_youtubeurl_groupby_trackid from (SELECT
    t2.*,
    COUNT( DISTINCT t2.id ) as count_distict_youtubeurl_groupby_trackid
FROM
    (
    SELECT
        t1.artistid,
        datasources.*
		
		
    FROM
        ( SELECT * FROM artist_track WHERE ArtistId IN ( 
'6A11A130617DA40598A1CDACEFC14D89'
) ) AS t1
        JOIN datasources ON datasources.TrackId = t1.trackid
        AND datasources.Valid > 0 

    GROUP BY
        datasources.TrackId,
        datasources.SourceURI 
    ) AS t2 
GROUP BY
    t2.trackid) as t3
			


) AS t4
		JOIN datasources ON datasources.TrackId = t4.trackid
		Join tracks on datasources.trackid = tracks.id and tracks. valid > 0
		AND datasources.FormatID = 'F5D2FE4A15FB405E988A7309FD3F9920'
		AND datasources.Valid > 0

	) AS t5
ORDER BY
	t5.artistid,
	t5.sourceuri,
	rownum ASC
) as t6
on t6.id = datasources.id and t6.rownum > 1
set datasources.DisplayStatus = 0
