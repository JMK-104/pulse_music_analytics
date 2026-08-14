-- ==========================================================
-- Podcast Listening History
-- ==========================================================

-- Playback events without users
SELECT plh.*
FROM source.podcast_listening_history plh
LEFT JOIN source.users u
    ON plh.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Playback events without episodes
SELECT plh.*
FROM source.podcast_listening_history plh
LEFT JOIN source.podcast_episodes pe
    ON plh.episode_id = pe.episode_id
WHERE pe.episode_id IS NULL
;

-- Future Playback Timestamps
SELECT *
FROM source.podcast_listening_history
WHERE playback_timestamp > CURRENT_TIMESTAMP
;

-- Negative Listening durations
SELECT *
FROM source.podcast_listening_history
WHERE seconds_played < 0
;

-- Playback duration exceeding episode length
SELECT
    plh.podcast_playback_id,
    plh.seconds_played,
    pe.duration_seconds
FROM source.podcast_listening_history plh
JOIN source.podcast_episodes pe
    ON plh.episode_id = pe.episode_id
WHERE plh.seconds_played > pe.duration_seconds
;

-- Completed Episodes with insufficient listening time
SELECT
    plh.*,
    pe.duration_seconds
FROM source.podcast_listening_history plh
JOIN source.podcast_episodes pe
    ON plh.episode_id = pe.episode_id
WHERE plh.completed = TRUE
AND plh.seconds_played < (pe.duration_seconds * 0.9)
;

-- Zero second podcast plays
SELECT *
FROM source.podcast_listening_history
WHERE seconds_played = 0
;

-- Invalid Source Types
SELECT
    source_type,
    COUNT(*) AS playback_count
FROM source.podcast_listening_history
GROUP BY source_type
ORDER BY playback_count DESC
;

-- Playback from inactive episodes
SELECT
    plh.podcast_playback_id,
    pe.episode_title
FROM source.podcast_listening_history plh
JOIN source.podcast_episodes pe
    ON plh.episode_id = pe.episode_id
WHERE pe.is_active = FALSE
;

-- Playback from inactive podcasts
SELECT
    plh.podcast_playback_id,
    p.podcast_title
FROM source.podcast_listening_history plh
JOIN source.podcast_episodes pe
    ON plh.episode_id = pe.episode_id
JOIN source.podcasts p
    ON pe.podcast_id = p.podcast_id
WHERE p.is_active = FALSE
;

-- Extremely high listening frequency
SELECT
    user_id,
    DATE(playback_timestamp) AS playback_date,
    COUNT(*) AS playback_count
FROM source.podcast_listening_history
GROUP BY
    user_id,
    DATE(playback_timestamp)
HAVING COUNT(*) > 200
;
