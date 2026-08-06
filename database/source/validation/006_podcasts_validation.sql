-- ==========================================================
-- Podcasts
-- ==========================================================

-- Podcasts with not episodes
SELECT p.*
FROM podcasts p
LEFT JOIN podcast_episodes pe
    ON p.podcast_id = pe.podcast_id
WHERE pe.podcast_id IS NULL
;

-- Podcasts with missing titles
SELECT *
FROM podcasts
WHERE TRIM(podcast_title) = ''
;

-- Podcasts with missing publishers
SELECT *
FROM podcasts
WHERE TRIM(publisher_name) = ''
;

-- Duplicate podcasts by title and publisher
SELECT
    podcast_title,
    publisher_name,
    COUNT(*) AS duplicate_count
FROM podcasts
GROUP BY
    podcast_title,
    publisher_name
HAVING COUNT(*) > 1
;

-- Missing Category or Language
SELECT *
FROM podcasts
WHERE category IS NULL
AND language IS NULL
;

-- Invalid Language values
SELECT
    language,
    COUNT(*) AS podcast_count
FROM podcasts
GROUP BY language
ORDER BY podcast_count DESC
;

-- Inactive Podcasts with recent episodes
SELECT DISTINCT
    p.podcast_id,
    p.podcast_title
FROM podcasts p
JOIN podcast_episodes pe
    ON p.podcast_id = pe.podcast_id
WHERE p.is_active = FALSE
AND pe.release_date >= CURRENT_DATE - INTERVAL '30 days'
;

-- Future Podcast creation metadada 
SELECT *
FROM podcasts
WHERE created_at > CURRENT_TIMESTAMP
;