-- ==========================================================
-- Songs
-- ==========================================================

-- Songs with missing artists
SELECT s.*
FROM source.songs s
LEFT JOIN source.artists a
    ON s.artist_id = a.artist_id
WHERE a.artist_id IS NULL
;

-- Songs with missing albums
SELECT *
FROM source.songs
WHERE album_id IS NULL
;

-- Songs with invalid album relationships
SELECT
    s.song_id,
    s.song_title,
    s.artist_id,
    al.album_id,
    al.artist_id AS album_artist_id
FROM source.songs s
JOIN source.albums al
    ON s.album_id = al.album_id
WHERE s.artist_id <> al.artist_id
;

-- Empty Song titles
SELECT *
FROM source.songs
WHERE TRIM(song_title) = ''
;

-- Unrealistic Song durations
SELECT *
FROM source.songs
WHERE duration_seconds < 10
;
SELECT *
FROM source.songs
WHERE duration_seconds > 3600
;

-- Future Release Dates
SELECT *
FROM source.songs
WHERE release_date > CURRENT_DATE
;

-- Songs released before their album
SELECT
    s.song_title,
    s.release_date AS song_release_date,
    al.album_title,
    al.release_date AS album_release_date
FROM source.songs s
JOIN source.albums al
    ON s.album_id = al.album_id
WHERE s.release_date < al.release_date
;

-- Active songs belonging to inactive artists
SELECT
    s.song_id,
    s.song_title,
    a.artist_name
FROM source.songs s
JOIN source.artists a
    ON s.artist_id = a.artist_id
WHERE s.is_active = TRUE
AND a.is_active = FALSE
;

-- Duplicate song by artist
SELECT
    artist_id,
    song_title,
    COUNT(*) AS duplicate_count
FROM source.songs
GROUP BY
    artist_id,
    song_title
HAVING COUNT(*) > 1
;

-- Listening events for inactive songs
SELECT DISTINCT
    s.song_id,
    s.song_title
FROM source.songs s
JOIN source.listening_history lh
    ON s.song_id = lh.song_id
WHERE s.is_active = FALSE
;
