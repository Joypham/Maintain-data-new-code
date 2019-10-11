Update datasources
Join (
SELECT
	t5.*,
	row_number () over ( PARTITION BY t5.artistid, t5.sourceuri,t5.formatid  ORDER BY t5.count_distict_youtubeurl_groupby_trackid DESC, t5.Resolution DESC, t5.CreatedAt DESC ) AS rownum 
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
		SELECT
			t3.artistid,
			t3.trackid,
			t3.count_distict_youtubeurl_groupby_trackid 
		FROM
			(
			SELECT
				t2.*,
				COUNT( DISTINCT t2.id ) AS count_distict_youtubeurl_groupby_trackid 
			FROM
				(-- Lay all datasources cua Artist
				SELECT
					t1.artistid,
					datasources.* 
					FROM-- t1: lay all tracks cua Artist
					( SELECT * FROM artist_track WHERE ArtistId IN ( '2FF796DC62694470AB6427799E24A04A' ) ) AS t1
					JOIN datasources ON datasources.TrackId = t1.trackid 
					AND datasources.Valid > 0 
				GROUP BY
					datasources.TrackId,
					datasources.SourceURI 
				) AS t2 
			GROUP BY
				t2.trackid 
			) AS t3 
		) AS t4
		JOIN datasources ON datasources.TrackId = t4.trackid
		JOIN tracks ON datasources.trackid = tracks.id 
		AND tracks.valid > 0 
		AND datasources.FormatID <> ""
		AND datasources.Valid > 0 
	) AS t5 
ORDER BY
	t5.artistid,
	t5.sourceuri,
	rownum ASC
	) as t6
on t6.id = datasources.id and t6.rownum > 1
set datasources.DisplayStatus = 0
