-- The purpose of this sql script is to add foreign key constraints to the tables in the database.

-- Albums
ALTER TABLE source.albums
ADD CONSTRAINT fk_albums_artists
FOREIGN KEY (artist_id)
REFERENCES source.artists(artist_id)
;

-- Songs
ALTER TABLE source.songs
ADD CONSTRAINT fk_songs_artists
FOREIGN KEY (artist_id)
REFERENCES source.artists(artist_id)
;
ALTER TABLE source.songs
ADD CONSTRAINT fk_songs_albums
FOREIGN KEY (album_id)
REFERENCES source.albums(album_id)
;

-- Playlists
ALTER TABLE source.playlists
ADD CONSTRAINT fk_playlists_users
FOREIGN KEY (user_id)
REFERENCES source.users(user_id)
;

-- Podcast Episodes
ALTER TABLE source.podcast_episodes
ADD CONSTRAINT fk_podcast_episodes_podcasts
FOREIGN KEY (podcast_id)
REFERENCES source.podcasts(podcast_id)
;

-- Sessions
ALTER TABLE source.sessions
ADD CONSTRAINT fk_sessions_users
FOREIGN KEY (user_id)
REFERENCES source.users(user_id)
;

-- Listening History
ALTER TABLE source.listening_history
ADD CONSTRAINT fk_listening_history_users
FOREIGN KEY (user_id)
REFERENCES source.users(user_id)
;
ALTER TABLE source.listening_history
ADD CONSTRAINT fk_listening_history_songs
FOREIGN KEY (song_id)
REFERENCES source.songs(song_id)
;
ALTER TABLE source.listening_history
ADD CONSTRAINT fk_listening_history_playlists
FOREIGN KEY (playlist_id)
REFERENCES source.playlists(playlist_id)
;

-- Podcast Listening History
ALTER TABLE source.podcast_listening_history
ADD CONSTRAINT fk_podcast_listening_history_users
FOREIGN KEY (user_id)
REFERENCES source.users(user_id)
;
ALTER TABLE source.podcast_listening_history
ADD CONSTRAINT fk_podcast_listening_history_podcast_episodes
FOREIGN KEY (episode_id)
REFERENCES source.podcast_episodes(episode_id)
;

-- Subscriptions
ALTER TABLE source.user_subscriptions
ADD CONSTRAINT fk_user_subscriptions_users
FOREIGN KEY (user_id)
REFERENCES source.users(user_id)
;

-- Payments
ALTER TABLE source.payments
ADD CONSTRAINT fk_payments_users
FOREIGN KEY (user_id)
REFERENCES source.users(user_id)
;
ALTER TABLE source.payments
ADD CONSTRAINT fk_payments_user_subscriptions
FOREIGN KEY (subscription_id)
REFERENCES source.user_subscriptions(subscription_id)
;
