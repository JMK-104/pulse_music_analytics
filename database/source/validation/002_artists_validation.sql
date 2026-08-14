-- ==========================================================
-- Artists
-- ==========================================================

-- Artists with no songs
SELECT a.*
FROM source.artists a
LEFT JOIN source.songs s
    ON a.artist_id = s.artist_id
WHERE s.artist_id IS NULL
;

-- Artists with not albums
SELECT a.*
FROM source.artists a
LEFT JOIN source.albums al
    ON a.artist_id = al.artist_id
WHERE al.artist_id IS NULL
;

-- Inactive artists with active songs
SELECT DISTINCT
    a.artist_id,
    a.artist_name
FROM source.artists a
JOIN source.songs s
    ON a.artist_id = s.artist_id
WHERE a.is_active = FALSE
  AND s.is_active = TRUE
;

-- Duplicate Artist Names
SELECT
    artist_name,
    COUNT(*) AS duplicate_count
FROM source.artists
GROUP BY artist_name
HAVING COUNT(*) > 1
;

-- Missing Country and Genre
SELECT *
FROM source.artists
WHERE country IS NULL
  AND primary_genre IS NULL
;

-- Artists with Unusually large catalogues
SELECT
    a.artist_name,
    COUNT(s.song_id) AS song_count
FROM source.artists a
JOIN source.songs s
    ON a.artist_id = s.artist_id
GROUP BY
    a.artist_id,
    a.artist_name
HAVING COUNT(s.song_id) > 500
;
