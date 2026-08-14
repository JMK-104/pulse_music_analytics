-- ================================================================================================
-- Purpose: Perform post-load data quality validation on the Pulse Music Analytics source database.

-- These queries do not modify data.

-- Each query returns records that should be reviewed.

-- A query returning zero rows indicates that the validation passed successfully.
-- ================================================================================================



-- ==========================================================
-- Users
-- ==========================================================

-- Future registration dates
SELECT *
FROM source.users
WHERE registration_date > CURRENT_DATE
;

-- Future Date of Birth
SELECT *
FROM source.users
WHERE date_of_birth > CURRENT_DATE
;

-- Unrealistic Ages
SELECT *
FROM source.users
WHERE date_of_birth < CURRENT_DATE - INTERVAL '120 years'
;

-- Inactive Users with Recent Registration
SELECT *
FROM source.users
WHERE is_active = FALSE
AND registration_date >= CURRENT_DATE - INTERVAL '7 days'
;

-- Duplicate Names
SELECT
    first_name,
    last_name,
    COUNT(*) AS duplicate_count
FROM source.users
GROUP BY
    first_name,
    last_name
HAVING COUNT(*) > 1
;

-- Missing Location Information
SELECT *
FROM source.users
WHERE country IS NULL
AND city IS NULL
;


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


-- ==========================================================
-- Albums
-- ==========================================================

-- Albums with no songs
SELECT al.*
FROM source.albums al
LEFT JOIN source.songs s
    ON al.album_id = s.album_id
WHERE s.album_id IS NULL
;

-- Albums referencing missing artists
SELECT al.*
FROM source.albums al
LEFT JOIN source.artists a
    ON al.artist_id = a.artist_id
WHERE a.artist_id IS NULL
;

-- Future Release Dates
SELECT *
FROM source.albums
WHERE release_date > CURRENT_DATE
;

-- Album release dates before the artist existed
SELECT
    al.album_id,
    al.album_title,
    al.release_date,
    a.created_at AS artist_created_at
FROM source.albums al
JOIN source.artists a
    ON al.artist_id = a.artist_id
WHERE al.release_date < a.created_at::DATE
;

-- Missing Album Title
SELECT *
FROM source.albums
WHERE TRIM(album_title) = ''
;

-- Duplicate ALbum Titles by Artist
SELECT
    artist_id,
    album_title,
    COUNT(*) AS duplicate_count
FROM source.albums
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
FROM source.albums al
JOIN source.songs s
    ON al.album_id = s.album_id
WHERE s.release_date < al.release_date
;


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


-- ==========================================================
-- Podcasts
-- ==========================================================

-- Podcasts with not episodes
SELECT p.*
FROM source.podcasts p
LEFT JOIN source.podcast_episodes pe
    ON p.podcast_id = pe.podcast_id
WHERE pe.podcast_id IS NULL
;

-- Podcasts with missing titles
SELECT *
FROM source.podcasts
WHERE TRIM(podcast_title) = ''
;

-- Podcasts with missing publishers
SELECT *
FROM source.podcasts
WHERE TRIM(publisher_name) = ''
;

-- Duplicate podcasts by title and publisher
SELECT
    podcast_title,
    publisher_name,
    COUNT(*) AS duplicate_count
FROM source.podcasts
GROUP BY
    podcast_title,
    publisher_name
HAVING COUNT(*) > 1
;

-- Missing Category or Language
SELECT *
FROM source.podcasts
WHERE category IS NULL
AND language IS NULL
;

-- Invalid Language values
SELECT
    language,
    COUNT(*) AS podcast_count
FROM source.podcasts
GROUP BY language
ORDER BY podcast_count DESC
;

-- Inactive Podcasts with recent episodes
SELECT DISTINCT
    p.podcast_id,
    p.podcast_title
FROM source.podcasts p
JOIN source.podcast_episodes pe
    ON p.podcast_id = pe.podcast_id
WHERE p.is_active = FALSE
AND pe.release_date >= CURRENT_DATE - INTERVAL '30 days'
;

-- Future Podcast creation metadada 
SELECT *
FROM source.podcasts
WHERE created_at > CURRENT_TIMESTAMP
;


-- ==========================================================
-- Podcast Episodes
-- ==========================================================

-- Episodes with missing podcasts
SELECT pe.*
FROM source.podcast_episodes pe
LEFT JOIN source.podcasts p
    ON pe.podcast_id = p.podcast_id
WHERE p.podcast_id IS NULL
;

-- Empty Episode Titles
SELECT *
FROM source.podcast_episodes
WHERE TRIM(episode_title) = ''
;

-- Future release dates
SELECT *
FROM source.podcast_episodes
WHERE release_date > CURRENT_DATE
;

-- Invalid Episode Durations
SELECT *
FROM source.podcast_episodes
WHERE duration_seconds < 10
;

-- Invalid Episode Numbers
SELECT *
FROM source.podcast_episodes
WHERE episode_number <= 0
;

-- Duplicate Episode Numbers withina podcast
SELECT
    podcast_id,
    episode_number,
    COUNT(*) AS episode_count
FROM source.podcast_episodes
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
FROM source.podcast_episodes pe
JOIN source.podcasts p
    ON pe.podcast_id = p.podcast_id
WHERE pe.release_date < p.created_at::DATE
;

-- Active Episodes belonging to inactive podcasts
SELECT
    pe.episode_id,
    pe.episode_title,
    p.podcast_title
FROM source.podcast_episodes pe
JOIN source.podcasts p
    ON pe.podcast_id = p.podcast_id
WHERE pe.is_active = TRUE
AND p.is_active = FALSE
;

-- Explicit Episode Flag Consistency
SELECT
    is_explicit,
    COUNT(*) AS episode_count
FROM source.podcast_episodes
GROUP BY is_explicit
;


-- ==========================================================
-- Sessions
-- ==========================================================

-- Sessions with missing users
SELECT s.*
FROM source.sessions s
LEFT JOIN source.users u
    ON s.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Session start times in the future
SELECT *
FROM source.sessions
WHERE session_start_timestamp > CURRENT_TIMESTAMP
;

-- Session end before session start
SELECT *
FROM source.sessions
WHERE session_end_timestamp < session_start_timestamp
;

-- Extremely Long Sessions
SELECT *
FROM source.sessions
WHERE session_end_timestamp - session_start_timestamp 
    > INTERVAL '24 hours'
;

-- Sessions with no end timestamp
SELECT *
FROM source.sessions
WHERE session_end_timestamp IS NULL
;

-- Missing device informaiton
SELECT *
FROM source.sessions
WHERE device_type IS NULL
AND operating_system IS NULL
;

-- Sessions with inactive users
SELECT
    s.session_id,
    s.session_start_timestamp,
    u.user_id
FROM source.sessions s
JOIN source.users u
    ON s.user_id = u.user_id
WHERE u.is_active = FALSE
;

-- Excessive Session frequency
SELECT
    user_id,
    DATE(session_start_timestamp) AS session_date,
    COUNT(*) AS session_count
FROM source.sessions
GROUP BY
    user_id,
    DATE(session_start_timestamp)
HAVING COUNT(*) > 100
;


-- ==========================================================
-- Listening History
-- ==========================================================

-- Playback events without users
SELECT lh.*
FROM source.listening_history lh
LEFT JOIN source.users u
    ON lh.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Playback events without songs
SELECT lh.*
FROM source.listening_history lh
LEFT JOIN source.songs s
    ON lh.song_id = s.song_id
WHERE s.song_id IS NULL
;

-- Future Playback Timestamps
SELECT *
FROM source.listening_history
WHERE playback_timestamp > CURRENT_TIMESTAMP
;

-- Negative Listening durations
SELECT *
FROM source.listening_history
WHERE seconds_played < 0
;

-- Listening duration exceeding song length
SELECT
    lh.playback_id,
    lh.song_id,
    lh.seconds_played,
    s.duration_seconds
FROM source.listening_history lh
JOIN source.songs s
    ON lh.song_id = s.song_id
WHERE lh.seconds_played > s.duration_seconds
;

-- Completed Songs with insufficient listening
SELECT
    lh.*,
    s.duration_seconds
FROM source.listening_history lh
JOIN source.songs s
    ON lh.song_id = s.song_id
WHERE lh.completed = TRUE
AND lh.seconds_played < (s.duration_seconds * 0.9)
;

-- Skipped songs marked as completed
SELECT *
FROM source.listening_history
WHERE completed = TRUE
AND skipped = TRUE
;

-- Zero second playbacks
SELECT *
FROM source.listening_history
WHERE seconds_played = 0
;

-- Playlist references without playlist
SELECT lh.*
FROM source.listening_history lh
LEFT JOIN source.playlists p
    ON lh.playlist_id = p.playlist_id
WHERE lh.playlist_id IS NOT NULL
AND p.playlist_id IS NULL
;

-- Playback from inactive songs
SELECT
    lh.playback_id,
    s.song_title
FROM source.listening_history lh
JOIN source.songs s
    ON lh.song_id = s.song_id
WHERE s.is_active = FALSE
;

-- Extremely High listening frequency
SELECT
    user_id,
    DATE(playback_timestamp) AS playback_date,
    COUNT(*) AS playback_count
FROM source.listening_history
GROUP BY
    user_id,
    DATE(playback_timestamp)
HAVING COUNT(*) > 1000
;

-- Invalid Source Type
SELECT
    source_type,
    COUNT(*) AS playback_count
FROM source.listening_history
GROUP BY source_type
ORDER BY playback_count DESC
;


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


-- ==========================================================
-- User Subscriptions
-- ==========================================================

-- Subscriptions without users
SELECT us.*
FROM source.user_subscriptions us
LEFT JOIN source.users u
    ON us.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Invalid subscription dates
SELECT *
FROM source.user_subscriptions
WHERE end_date < start_date
;

-- Future Start dates
SELECT *
FROM source.user_subscriptions
WHERE start_date > CURRENT_DATE
;

-- Active Subscriptions with past end dates
SELECT *
FROM source.user_subscriptions
WHERE subscription_status = 'active'
AND end_date < CURRENT_DATE
;

-- Ended subcriptions still marked active
SELECT *
FROM source.user_subscriptions
WHERE subscription_status = 'expired'
AND end_date IS NULL
;

-- Invalid subscription statuses
SELECT *
FROM source.user_subscriptions
WHERE subscription_status NOT IN
(
    'active',
    'cancelled',
    'expired',
    'paused'
)
;

-- Invalid Billing Cycles
SELECT *
FROM source.user_subscriptions
WHERE billing_cycle NOT IN
(
    'Monthly',
    'Annual'
)
;

-- Invalid Plan Names
SELECT
    plan_name,
    COUNT(*) AS subscription_count
FROM source.user_subscriptions
GROUP BY plan_name
ORDER BY subscription_count DESC
;

-- Multiple Active Subscriptions per user
SELECT
    user_id,
    COUNT(*) AS active_subscription_count
FROM source.user_subscriptions
WHERE subscription_status = 'active'
GROUP BY user_id
HAVING COUNT(*) > 1
;

-- Overlapping subscription periods
SELECT
    a.user_id,
    a.subscription_id AS subscription_1,
    b.subscription_id AS subscription_2
FROM source.user_subscriptions a
JOIN source.user_subscriptions b
    ON a.user_id = b.user_id
    AND a.subscription_id <> b.subscription_id
WHERE a.start_date <= COALESCE(b.end_date, CURRENT_DATE)
AND b.start_date <= COALESCE(a.end_date, CURRENT_DATE)
;

-- Auto-renew consistency
SELECT *
FROM source.user_subscriptions
WHERE auto_renew = TRUE
AND end_date < CURRENT_DATE
;


-- ==========================================================
-- Payments
-- ==========================================================

-- Payments without users
SELECT p.*
FROM source.payments p
LEFT JOIN source.users u
    ON p.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Payments without subscriptions
SELECT p.*
FROM source.payments p
LEFT JOIN source.user_subscriptions us
    ON p.subscription_id = us.subscription_id
WHERE us.subscription_id IS NULL
;

-- Negative Payment Amounts
SELECT *
FROM source.payments
WHERE amount < 0
;

-- Zero-value Payments
SELECT *
FROM source.payments
WHERE amount = 0
;

-- Invalid currency codes
SELECT
    currency,
    COUNT(*) AS payment_count
FROM source.payments
GROUP BY currency
ORDER BY payment_count DESC
;

-- Missing payment status
SELECT *
FROM source.payments
WHERE payment_status NOT IN
(
    'completed',
    'pending',
    'failed',
    'refunded'
)
;

-- Future Payment timestamps
SELECT *
FROM source.payments
WHERE payment_timestamp > CURRENT_TIMESTAMP
;

-- Payments before subscription start dates
SELECT
    p.payment_id,
    p.payment_timestamp,
    us.start_date
FROM source.payments p
JOIN user_subscriptions us
    ON p.subscription_id = us.subscription_id
WHERE p.payment_timestamp::DATE < us.start_date
;

-- Payments after subscription end dates
SELECT
    p.payment_id,
    p.payment_timestamp,
    us.end_date
FROM source.payments p
JOIN source.user_subscriptions us
    ON p.subscription_id = us.subscription_id
WHERE us.end_date IS NOT NULL
AND p.payment_timestamp::DATE > us.end_date
;

-- Duplicate Payments
SELECT
    user_id,
    subscription_id,
    payment_timestamp,
    amount,
    COUNT(*) AS duplicate_count
FROM source.payments
GROUP BY
    user_id,
    subscription_id,
    payment_timestamp,
    amount
HAVING COUNT(*) > 1
;

-- Payment method profiling
SELECT
    payment_method,
    COUNT(*) AS payment_count
FROM source.payments
GROUP BY payment_method
ORDER BY payment_count DESC
;

-- Failed payments with completed subscriptions
SELECT
    p.payment_id,
    us.subscription_status
FROM source.payments p
JOIN source.user_subscriptions us
    ON p.subscription_id = us.subscription_id
WHERE p.payment_status = 'failed'
AND us.subscription_status = 'active'
;


-- ==========================================================
-- Marketing Campaigns
-- ==========================================================

-- Empty Campaign Names
SELECT *
FROM source.marketing_campaigns
WHERE TRIM(campaign_name) = ''
;

-- Future Campaign Start Dates
SELECT *
FROM source.marketing_campaigns
WHERE start_date > CURRENT_DATE
;

-- End dates before start dates
SELECT *
FROM source.marketing_campaigns
WHERE end_date < start_date
;

-- Negative campaign budgets
SELECT *
FROM source.marketing_campaigns
WHERE budget < 0
;

-- Negative campaign spend
SELECT *
FROM source.marketing_campaigns
WHERE spend < 0
;

-- Spend exceeds budget
SELECT *
FROM source.marketing_campaigns
WHERE spend > budget
;

-- Negative Marketing metrics
SELECT *
FROM source.marketing_campaigns
WHERE impressions < 0
   OR clicks < 0
   OR conversions < 0
;

-- Clicks greater then impressions
SELECT *
FROM source.marketing_campaigns
WHERE clicks > impressions
;

-- Conversions greater than clicks
SELECT *
FROM source.marketing_campaigns
WHERE conversions > clicks
;

-- Missing campaign objectives
SELECT *
FROM source.marketing_campaigns
WHERE campaign_objective IS NULL
;

-- Invalid Channel Values
SELECT
    channel,
    COUNT(*) AS campaign_count
FROM source.marketing_campaigns
GROUP BY channel
ORDER BY campaign_count DESC
;

-- Duplicate Campaigns
SELECT
    campaign_name,
    channel,
    start_date,
    COUNT(*) AS duplicate_count
FROM source.marketing_campaigns
GROUP BY
    campaign_name,
    channel,
    start_date
HAVING COUNT(*) > 1
;

-- Campaign efficiency anomalies
SELECT
    campaign_id,
    campaign_name,
    clicks::DECIMAL / NULLIF(impressions,0) AS click_through_rate
FROM source.marketing_campaigns
;

-- Campaigns with spend but no activity
SELECT *
FROM source.marketing_campaigns
WHERE spend > 0
AND (
    impressions IS NULL
    OR impressions = 0
)
;
