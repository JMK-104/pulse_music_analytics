-- ==========================================================
-- Podcast Episodes
-- ==========================================================

-- Episodes with missing podcasts
SELECT pe.*
FROM podcast_episodes pe
LEFT JOIN podcasts p
    ON pe.podcast_id = p.podcast_id
WHERE p.podcast_id IS NULL
;

-- Empty Episode Titles
SELECT *
FROM podcast_episodes
WHERE TRIM(episode_title) = ''
;

-- Future release dates
SELECT *
FROM podcast_episodes
WHERE release_date > CURRENT_DATE
;

-- Invalid Episode Durations
SELECT *
FROM podcast_episodes
WHERE duration_seconds < 10
;

-- Invalid Episode Numbers
SELECT *
FROM podcast_episodes
WHERE episode_number <= 0
;

-- Duplicate Episode Numbers withina podcast
SELECT
    podcast_id,
    episode_number,
    COUNT(*) AS episode_count
FROM podcast_episodes
WHERE episode_number IS NOT NULL
GROUP BY
    podcast_id,
    episode_number
HAVING COUNT(*) > 1
;

-- Episode release dates before podcast creation
SELECT
    pe.episode_title,
    pe.release_date,
    p.podcast_title,
    p.created_at::DATE AS podcast_created_date
FROM podcast_episodes pe
JOIN podcasts p
    ON pe.podcast_id = p.podcast_id
WHERE pe.release_date < p.created_at::DATE
;

-- Active Episodes belonging to inactive podcasts
SELECT
    pe.episode_id,
    pe.episode_title,
    p.podcast_title
FROM podcast_episodes pe
JOIN podcasts p
    ON pe.podcast_id = p.podcast_id
WHERE pe.is_active = TRUE
AND p.is_active = FALSE
;

-- Explicit Episode Flag Consistency
SELECT
    is_explicit,
    COUNT(*) AS episode_count
FROM podcast_episodes
GROUP BY is_explicit
;