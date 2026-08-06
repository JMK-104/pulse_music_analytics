-- ===============================================================================
-- Purpose: Attach the reusable update_updated_at_column() trigger function to 
-- all mutable source tables.
-- Event tables such as listening_history and payments are intentionally excluded 
-- because they are treated as append-only records.
-- ===============================================================================


-- Users
CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;

-- Artists
CREATE TRIGGER trg_artists_updated_at
BEFORE UPDATE ON artists
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;

-- Albums
CREATE TRIGGER trg_albums_updated_at
BEFORE UPDATE ON albums
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;

-- Songs
CREATE TRIGGER trg_songs_updated_at
BEFORE UPDATE ON songs
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;

-- Playlists
CREATE TRIGGER trg_playlists_updated_at
BEFORE UPDATE ON playlists
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;

-- Podcasts
CREATE TRIGGER trg_podcasts_updated_at
BEFORE UPDATE ON podcasts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;

-- Podcast Episodes
CREATE TRIGGER trg_podcast_episodes_updated_at
BEFORE UPDATE ON podcast_episodes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;

-- User Subscriptions
CREATE TRIGGER trg_user_subscriptions_updated_at
BEFORE UPDATE ON user_subscriptions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;

-- Marketing Campaigns
CREATE TRIGGER trg_marketing_campaigns_updated_at
BEFORE UPDATE ON marketing_campaigns
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column()
;


/*
Excluded Tables

• sessions
• listening_history
• podcast_listening_history
• payments
/*