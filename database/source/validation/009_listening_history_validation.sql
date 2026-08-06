-- ==========================================================
-- Listening History
-- ==========================================================

-- Playback events without users
SELECT lh.*
FROM listening_history lh
LEFT JOIN users u
    ON lh.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Playback events without songs
SELECT lh.*
FROM listening_history lh
LEFT JOIN songs s
    ON lh.song_id = s.song_id
WHERE s.song_id IS NULL
;

-- Future Playback Timestamps
SELECT *
FROM listening_history
WHERE playback_timestamp > CURRENT_TIMESTAMP
;

-- Negative Listening durations
SELECT *
FROM listening_history
WHERE seconds_played < 0
;

-- Listening duration exceeding song length
SELECT
    lh.playback_id,
    lh.song_id,
    lh.seconds_played,
    s.duration_seconds
FROM listening_history lh
JOIN songs s
    ON lh.song_id = s.song_id
WHERE lh.seconds_played > s.duration_seconds
;

-- Completed Songs with insufficient listening
SELECT
    lh.*,
    s.duration_seconds
FROM listening_history lh
JOIN songs s
    ON lh.song_id = s.song_id
WHERE lh.completed = TRUE
AND lh.seconds_played < (s.duration_seconds * 0.9)
;

-- Skipped songs marked as completed
SELECT *
FROM listening_history
WHERE completed = TRUE
AND skipped = TRUE
;

-- Zero second playbacks
SELECT *
FROM listening_history
WHERE seconds_played = 0
;

-- Playlist references without playlist
SELECT lh.*
FROM listening_history lh
LEFT JOIN playlists p
    ON lh.playlist_id = p.playlist_id
WHERE lh.playlist_id IS NOT NULL
AND p.playlist_id IS NULL
;

-- Playback from inactive songs
SELECT
    lh.playback_id,
    s.song_title
FROM listening_history lh
JOIN songs s
    ON lh.song_id = s.song_id
WHERE s.is_active = FALSE
;

-- Extremely High listening frequency
SELECT
    user_id,
    DATE(playback_timestamp) AS playback_date,
    COUNT(*) AS playback_count
FROM listening_history
GROUP BY
    user_id,
    DATE(playback_timestamp)
HAVING COUNT(*) > 1000
;

-- Invalid Source Type
SELECT
    source_type,
    COUNT(*) AS playback_count
FROM listening_history
GROUP BY source_type
ORDER BY playback_count DESC
;