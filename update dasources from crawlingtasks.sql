Discription:
Code add thêm datasources.info.place (year, live...) cho các version chưa update. =>  Cần mannual đẩy từ crawlingtasks vào datasources


* Remix:
Update datasources
Join (
select * from (
SELECT
t1.*,
datasources.ArtistName as wrong_remix_artist,
datasources.id AS datasources_id,
Datasources.info ->>'$.display_at' as display_at,
Datasources.info ->>'$.year' as year,
datasources.CreatedAt
FROM
    (
        SELECT
    TrackId,
    TaskDetail ->> '$.year' as updated_year,
    TaskDetail ->> '$.youtube_url' as youtube_url,
--     TaskDetail ->> '$.concert_live_name' as concert_live_name,
    Json_unquote(TaskDetail->'$.remix_artist') as truename_remix_artist,
    ROW_NUMBER () over (PARTITION BY 
                trackid,                
                TaskDetail ->> '$.youtube_url',
                TaskDetail ->> '$.data_source_format_id'
            ORDER BY
                CreatedAt DESC
            ) AS `Rankovertrack`
        FROM
            crawlingtask_done
        WHERE
            actionid = 'F91244676ACD47BD9A9048CF2BA3FFC1'
        AND TaskDetail LIKE '%BB423826E6FA4839BBB4DA718F483D18%'
        and TaskDetail->'$.remix_artist' is not null
--         and
--         TaskDetail ->> '$.concert_live_name' is not null
--         and
--         TaskDetail ->> '$.year' is not null
        ORDER BY
            TaskDetail ->> '$.youtube_url'        
    ) AS t1
JOIN datasources ON datasources.trackid = t1.trackid
AND datasources.FormatID = 'BB423826E6FA4839BBB4DA718F483D18'
AND datasources.SourceURI = t1.youtube_url and datasources.valid > 0 
-- and datasources.id = 'D288A80B432D467CAAFAE44B707EACEC'

WHERE
    t1.Rankovertrack = 1
order by t1.trackid,t1.youtube_url
) as t2
where 
(t2.truename_remix_artist <> t2.wrong_remix_artist)
-- limit 2
) as t3 
on datasources.id = t3.datasources_id
set
datasources.ArtistName = t3.truename_remix_artist


* Cover: 
Update datasources
Join (
SELECT
t1.*, 
datasources.id AS datasources_id,
datasources.ArtistName as datasources_artistname

FROM
    (
        SELECT
            trackid,
            TaskDetail ->> '$.covered_artist_name' AS covered_artist_name,
            TaskDetail ->> '$.youtube_url' AS youtube_url,            
            ROW_NUMBER () over (
                PARTITION BY TaskDetail ->> '$.youtube_url',
                TaskDetail ->> '$.data_source_format_id'
            ORDER BY
                CreatedAt DESC
            ) AS `Rankovertrack`
        FROM
            crawlingtask_done
        WHERE
            actionid = 'F91244676ACD47BD9A9048CF2BA3FFC1'
        AND TaskDetail ->> '$.covered_artist_name' IS NOT NULL and TaskDetail ->> '$.covered_artist_name' <> ''
        AND TaskDetail ->> '$.data_source_format_id' = 'F5D2FE4A15FB405E988A7309FD3F9920'
        GROUP BY
            trackid,
            TaskDetail ->> '$.covered_artist_name',
            TaskDetail ->> '$.youtube_url'
        ORDER BY
            TaskDetail ->> '$.youtube_url'        
    ) AS t1
JOIN datasources ON datasources.trackid = t1.trackid
AND datasources.FormatID = 'F5D2FE4A15FB405E988A7309FD3F9920'
AND datasources.SourceURI = t1.youtube_url and datasources.ArtistName <> t1.covered_artist_name and datasources.valid > 0
WHERE
    t1.Rankovertrack = 1
order by t1.trackid,t1.covered_artist_name,t1.youtube_url
) as t2
on datasources.id = t2.datasources_id
set 
datasources.ArtistName = t2.covered_artist_name

*Live: 
Update datasources
Join (
SELECT
t1.*, 
datasources.id AS datasources_id,
Datasources.info ->>'$.display_at' as display_at,
Datasources.info ->>'$.year' as year

FROM
    (
        SELECT

    TrackId,
    TaskDetail ->> '$.year' as updated_year,
    TaskDetail ->> '$.youtube_url' as youtube_url,
    TaskDetail ->> '$.concert_live_name' as concert_live_name,
    ROW_NUMBER () over (PARTITION BY 
                trackid,                
                TaskDetail ->> '$.youtube_url',
                TaskDetail ->> '$.data_source_format_id'
            ORDER BY
                CreatedAt DESC
            ) AS `Rankovertrack`
        FROM
            crawlingtask_done
        WHERE
            actionid = 'F91244676ACD47BD9A9048CF2BA3FFC1'
        AND TaskDetail LIKE '%7F8B6CD82F28437888BD029EFDA1E57F%'
        and
        TaskDetail ->> '$.concert_live_name' is not null
        and
        TaskDetail ->> '$.year' is not null
    
        ORDER BY
            TaskDetail ->> '$.youtube_url'        
    ) AS t1
JOIN datasources ON datasources.trackid = t1.trackid
AND datasources.FormatID = '7F8B6CD82F28437888BD029EFDA1E57F'
AND datasources.SourceURI = t1.youtube_url and datasources.valid > 0
WHERE
    t1.Rankovertrack = 1
order by t1.trackid,t1.youtube_url
) as t2
on datasources.id = t2.datasources_id
set datasources.Info = JSON_SET(IFNULL(datasources.Info, JSON_OBJECT()),'$.year',t2.updated_year,'$.display_at',t2.concert_live_name)

