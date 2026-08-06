-- ==========================================================
-- Albums
-- ==========================================================

-- Albums with no songs
SELECT al.*
FROM albums al
LEFT JOIN songs s
    ON al.album_id = s.album_id
WHERE s.album_id IS NULL
;

-- Albums referencing missing artists
SELECT al.*
FROM albums al
LEFT JOIN artists a
    ON al.artist_id = a.artist_id
WHERE a.artist_id IS NULL
;

-- Future Release Dates
SELECT *
FROM albums
WHERE release_date > CURRENT_DATE
;

-- Album release dates before the artist existed
SELECT
    al.album_id,
    al.album_title,
    al.release_date,
    a.created_at AS artist_created_at
FROM albums al
JOIN artists a
    ON al.artist_id = a.artist_id
WHERE al.release_date < a.created_at::DATE
;

-- Missing Album Title
SELECT *
FROM albums
WHERE TRIM(album_title) = ''
;

-- Duplicate ALbum Titles by Artist
SELECT
    artist_id,
    album_title,
    COUNT(*) AS duplicate_count
FROM albums
GROUP BY
    artist_id,
    album_title
HAVING COUNT(*) > 1
;

-- Albums inconssitent with song release date
SELECT
    al.album_title,
    s.song_title,
    al.release_date AS album_release_date,
    s.release_date AS song_release_date
FROM albums al
JOIN songs s
    ON al.album_id = s.album_id
WHERE s.release_date < al.release_date
;