-- ==========================================================
-- Users
-- ==========================================================

ALTER TABLE source.users
ADD CONSTRAINT chk_users_first_name_not_blank
CHECK (btrim(first_name) <> '')
;
ALTER TABLE source.users
ADD CONSTRAINT chk_users_last_name_not_blank
CHECK (btrim(last_name) <> '')
;
ALTER TABLE source.users
ADD CONSTRAINT chk_users_email_is_not_blank
CHECK (btrim(email) <> '')
;
ALTER TABLE source.users
ADD CONSTRAINT chk_users_registration_date
CHECK (registration_date <= CURRENT_DATE)
;
ALTER TABLE source.users
ADD CONSTRAINT chk_users_date_of_birth
CHECK (
    date_of_birth IS NULL
    OR date_of_birth <= CURRENT_DATE
)
;


-- ==========================================================
-- Artists
-- ==========================================================

ALTER TABLE source.artists
ADD CONSTRAINT chk_artists_name_not_blank
CHECK (btrim(artist_name) <> '')
;
ALTER TABLE source.artists
ADD CONSTRAINT chk_artists_country_is_not_blank
CHECK (
    country IS NULL
    OR btrim(country) <> ''
)
;
ALTER TABLE source.artists
ADD CONSTRAINT chk_artists_primary_genre_not_blank
CHECK (
    primary_genre IS NULL
    OR btrim(primary_genre) <> ''
)
;


-- ==========================================================
-- Albums
-- ==========================================================

ALTER TABLE source.albums
ADD CONSTRAINT chk_albums_album_title_not_blank
CHECK (btrim(album_title) <> '')
;
ALTER TABLE source.albums
ADD CONSTRAINT chk_albums_label_name_not_blank
CHECK (
    label_name IS NULL
    OR btrim(label_name) <> ''
)
;
ALTER TABLE source.albums
ADD CONSTRAINT chk_albums_album_type_is_not_blank
CHECK (
    album_type IS NULL
    OR btrim(album_type) <> ''
)
;
ALTER TABLE source.albums
ADD CONSTRAINT chk_albums_release_date
CHECK (
    release_date IS NULL
    OR release_date <= CURRENT_DATE
)
;


-- ==========================================================
-- Songs
-- ==========================================================

ALTER TABLE source.songs
ADD CONSTRAINT chk_songs_title_not_blank
CHECK (
    btrim(song_title) <> ''
)
;
ALTER TABLE source.songs
ADD CONSTRAINT chk_songs_genre_not_blank
CHECK (
    genre IS NULL
    OR btrim(genre) <> ''
)
;
ALTER TABLE source.songs
ADD CONSTRAINT chk_songs_duration_positive
CHECK (duration_seconds > 0)
;
ALTER TABLE source.songs
ADD CONSTRAINT chk_songs_release_date
CHECK (
    release_date IS NULL
    OR release_date <= CURRENT_DATE
);


-- ==========================================================
-- Playlists
-- ==========================================================

ALTER TABLE source.playlists
ADD CONSTRAINT chk_playlists_name_not_blank
CHECK (btrim(playlist_name) <> '')
;
ALTER TABLE source.playlists
ADD CONSTRAINT chk_playlists_description_not_blank
CHECK (
    playlist_description IS NULL
    OR btrim(playlist_description) <> ''
)
;
ALTER TABLE source.playlists
ADD CONSTRAINT chk_playlists_type_not_blank
CHECK (btrim(playlist_type) <> '')
;


-- ==========================================================
-- Podcasts
-- ==========================================================

ALTER TABLE source.podcasts
ADD CONSTRAINT chk_podcasts_title_not_blank
CHECK (btrim(podcast_title) <> '')
;
ALTER TABLE source.podcasts
ADD CONSTRAINT chk_podcasts_publisher_not_blank
CHECK (btrim(publisher_name) <> '')
;
ALTER TABLE source.podcasts
ADD CONSTRAINT chk_podcasts_category_not_blank
CHECK (
    category IS NULL
    OR btrim(category) <> ''
)
;
ALTER TABLE source.podcasts
ADD CONSTRAINT chk_podcasts_language_not_blank
CHECK (
    language IS NULL
    OR btrim(language) <> ''
)
;
ALTER TABLE source.podcasts
ADD CONSTRAINT chk_podcasts_country_not_blank
CHECK (
    country IS NULL
    OR btrim(country) <> ''
)
;


-- ==========================================================
-- Podcast Episodes
-- ==========================================================

ALTER TABLE source.podcast_episodes
ADD CONSTRAINT chk_podcast_episodes_title_not_blank
CHECK (btrim(episode_title) <> '')
;
ALTER TABLE source.podcast_episodes
ADD CONSTRAINT chk_podcast_episodes_release_date
CHECK (release_date <= CURRENT_DATE)
;
ALTER TABLE source.podcast_episodes
ADD CONSTRAINT chk_podcast_episodes_duration_positive
CHECK (duration_seconds > 0)
;
ALTER TABLE source.podcast_episodes
ADD CONSTRAINT chk_podcast_episodes_episode_number_positive
CHECK (
    episode_number IS NULL
    OR episode_number > 0
)
;


-- ==========================================================
-- Sessions
-- ==========================================================

ALTER TABLE source.sessions
ADD CONSTRAINT chk_sessions_device_type_not_blank
CHECK (
    device_type IS NULL
    OR btrim(device_type) <> ''
)
;
ALTER TABLE source.sessions
ADD CONSTRAINT chk_sessions_operating_system_not_blank
CHECK (
    operating_system IS NULL
    OR btrim(operating_system) <> ''
)
;
ALTER TABLE source.sessions
ADD CONSTRAINT chk_sessions_country_not_blank
CHECK (
    country IS NULL
    OR btrim(country) <> ''
)
;
ALTER TABLE source.sessions
ADD CONSTRAINT chk_sessions_end_after_start
CHECK (
    session_end_timestamp IS NULL
    OR session_end_timestamp >= session_start_timestamp
)
;
ALTER TABLE source.sessions
ADD CONSTRAINT chk_sessions_created_at
CHECK (
    created_at >= session_start_timestamp
)
;


-- ==========================================================
-- Listening History
-- ==========================================================

ALTER TABLE source.listening_history
ADD CONSTRAINT chk_listening_history_seconds_played_positive
CHECK (seconds_played > 0)
;
ALTER TABLE source.listening_history
ADD CONSTRAINT chk_listening_history_device_type_not_blank
CHECK (
    device_type IS NULL
    OR btrim(device_type) <> ''
)
;
ALTER TABLE source.listening_history
ADD CONSTRAINT chk_listening_history_source_type_not_blank
CHECK (btrim(source_type) <> '')
;
ALTER TABLE source.listening_history
ADD CONSTRAINT chk_listening_history_not_completed_and_skipped
CHECK (
    NOT (completed = TRUE AND skipped = TRUE)
)
;


-- ==========================================================
-- Podcast Listening History
-- ==========================================================

ALTER TABLE source.podcast_listening_history
ADD CONSTRAINT chk_podcast_listening_history_seconds_played_positive
CHECK (seconds_played > 0)
;
ALTER TABLE source.podcast_listening_history
ADD CONSTRAINT chk_podcast_listening_history_device_type_not_blank
CHECK (
    device_type IS NULL
    OR btrim(device_type) <> ''
)
;
ALTER TABLE source.podcast_listening_history
ADD CONSTRAINT chk_podcast_listening_history_source_type_not_blank
CHECK (btrim(source_type) <> '')
;


-- ==========================================================
-- Subscriptions
-- ==========================================================

ALTER TABLE source.user_subscriptions
ADD CONSTRAINT chk_user_subscriptions_plan_name_not_blank
CHECK (btrim(plan_name) <> '')
;
ALTER TABLE source.user_subscriptions
ADD CONSTRAINT chk_user_subscriptions_billing_cycle_not_blank
CHECK (btrim(billing_cycle) <> '')
;
ALTER TABLE source.user_subscriptions
ADD CONSTRAINT chk_user_subscriptions_status_not_blank
CHECK (btrim(subscription_status) <> '')
;
ALTER TABLE source.user_subscriptions
ADD CONSTRAINT chk_user_subscriptions_end_after_start
CHECK (
    end_date IS NULL
    OR end_date >= start_date
)
;


-- ==========================================================
-- Payments
-- ==========================================================

ALTER TABLE source.payments
ADD CONSTRAINT chk_payments_amount_positive
CHECK (amount > 0)
;
ALTER TABLE source.payments
ADD CONSTRAINT chk_payments_currency_not_blank
CHECK (btrim(currency) <> '')
;
ALTER TABLE source.payments
ADD CONSTRAINT chk_payments_payment_status_not_blank
CHECK (btrim(payment_status) <> '')
;
ALTER TABLE source.payments
ADD CONSTRAINT chk_payments_payment_method_not_blank
CHECK (
    payment_method IS NULL
    OR btrim(payment_method) <> ''
)
;


-- ==========================================================
-- Marketing Campaigns
-- ==========================================================

ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_name_not_blank
CHECK (btrim(campaign_name) <> '')
;
ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_channel_not_blank
CHECK (btrim(channel) <> '')
;
ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_objective_not_blank
CHECK (
    campaign_objective IS NULL
    OR btrim(campaign_objective) <> ''
)
;
ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_end_after_start
CHECK (
    end_date IS NULL
    OR end_date >= start_date
)
;
ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_budget_positive
CHECK (budget > 0)
;
ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_spend_non_negative
CHECK (spend >= 0)
;
ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_impressions_non_negative
CHECK (
    impressions IS NULL
    OR impressions >= 0
)
;
ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_clicks_non_negative
CHECK (
    clicks IS NULL
    OR clicks >= 0
)
;
ALTER TABLE source.marketing_campaigns
ADD CONSTRAINT chk_marketing_campaigns_conversions_non_negative
CHECK (
    conversions IS NULL
    OR conversions >= 0
)
;
