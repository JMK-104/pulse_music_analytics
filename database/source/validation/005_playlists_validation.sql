-- ==========================================================
-- Playlists
-- ==========================================================

-- User Playlists without owners
SELECT *
FROM source.playlists
WHERE playlist_type = 'User'
AND user_id IS NULL
;

-- Platform Playlists with owners
SELECT *
FROM source.playlists
WHERE playlist_type IN ('Editorial', 'Algorithmic')
AND user_id IS NOT NULL
;

-- Invalid Playlist types
SELECT *
FROM source.playlists
WHERE playlist_type NOT IN
(
    'User',
    'Editorial',
    'Algorithmic'
)
;

-- Empty Playlist Names
SELECT *
FROM source.playlists
WHERE TRIM(playlist_name) = ''
;

-- Extremely Long Playlists
SELECT *
FROM source.playlists
WHERE LENGTH(playlist_name) > 200
;

-- Public playsts without owners
SELECT *
FROM source.playlists
WHERE is_public = TRUE
AND playlist_type = 'User'
AND user_id IS NULL
;

-- Recently created inactive playlists
SELECT *
FROM source.playlists
WHERE is_public = FALSE
AND created_at >= CURRENT_TIMESTAMP - INTERVAL '7 days'
;
