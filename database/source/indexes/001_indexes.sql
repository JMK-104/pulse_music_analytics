-- =============================================================
-- Foreign Key Indexes
-- Purpose: Improve join performance and support relational lookups
-- =============================================================

-- Albums
CREATE INDEX idx_albums_artist_id
ON source.albums(artist_id)
;

-- Songs
CREATE INDEX idx_songs_artist_id
ON source.songs(artist_id)
;
CREATE INDEX idx_songs_album_id
ON source.songs(album_id)
;

-- Playlists
CREATE INDEX idx_playlists_user_id
ON source.playlists(user_id)
;

-- Podcast Episodes
CREATE INDEX idx_podcast_episodes_podcast_id
ON source.podcast_episodes(podcast_id)
;

-- Sessions
CREATE INDEX idx_sessions_user_id
ON source.sessions(user_id)
;

-- Listening History
CREATE INDEX idx_listening_history_user_id
ON source.listening_history(user_id)
;
CREATE INDEX idx_listening_history_song_id
ON source.listening_history(song_id)
;
CREATE INDEX idx_listening_history_playlist_id
ON source.listening_history(playlist_id)
;

-- Podcast Listening History
CREATE INDEX idx_podcast_listening_history_user_id
ON source.podcast_listening_history(user_id)
;
CREATE INDEX idx_podcast_listening_history_episode_id
ON source.podcast_listening_history(episode_id)
;

-- Subscriptions
CREATE INDEX idx_user_subscriptions_user_id
ON source.user_subscriptions(user_id)
;

-- Payments
CREATE INDEX idx_payments_user_id
ON source.payments(user_id)
;
CREATE INDEX idx_payments_subscription_id
ON source.payments(subscription_id)
;


-- =============================================================
-- Time-Based Indexes
-- Purpose: Improve date range filtering and analytical queries
-- =============================================================

-- Listening History
CREATE INDEX idx_listening_history_playback_timestamp
ON source.listening_history(playback_timestamp)
;

-- Podcast Listening History
CREATE INDEX idx_podcast_listening_history_playback_timestamp
ON source.podcast_listening_history(playback_timestamp)
;

-- Sessions
CREATE INDEX idx_sessions_start_timestamp
ON source.sessions(session_start_timestamp)
;

-- Payments
CREATE INDEX idx_payments_payment_timestamp
ON source.payments(payment_timestamp)
;

-- Marketing Campaigns
CREATE INDEX idx_marketing_campaigns_start_date
ON source.marketing_campaigns(start_date)
;


-- =============================================================
-- Composite Indexes
-- Purpose: Optimize common analytical query patterns.
-- =============================================================

-- Listening History: User Activity Over Time
CREATE INDEX idx_listening_history_user_timestamp
ON source.listening_history(
    user_id,
    playback_timestamp
)
;

-- Listening History: Song Popularity Analysis
CREATE INDEX idx_listening_history_song_timestamp
ON source.listening_history(
    song_id,
    playback_timestamp
)
;

-- Podcast Listening History: User Engagement
CREATE INDEX idx_podcast_listening_history_user_timestamp
ON source.podcast_listening_history(
    user_id,
    playback_timestamp
)
;

-- Podcast Listening History: Episode Performance
CREATE INDEX idx_podcast_listening_history_episode_timestamp
ON source.podcast_listening_history(
    episode_id,
    playback_timestamp
)
;

-- Payments: Subscription Revenue Analysis
CREATE INDEX idx_payments_subscription_timestamp
ON source.payments(
    subscription_id,
    payment_timestamp
)
;

-- User Subscriptions: Current Subscription Lookup
CREATE INDEX idx_user_subscriptions_user_status
ON source.user_subscriptions(
    user_id,
    subscription_status
)
;

-- Marketing Campaigns: Campaign Reporting
CREATE INDEX idx_marketing_campaigns_channel_start_date
ON source.marketing_campaigns(
    channel,
    start_date
)
;
