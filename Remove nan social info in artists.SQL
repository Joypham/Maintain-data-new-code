UPDATE artists
SET
info = Json_set(info,‘$.social_urls’,cast(REPLACE(info ->> ‘$.social_urls’,‘nan’,‘’) as Json))
where
info ->> ‘$.social_urls’ is not NULL
