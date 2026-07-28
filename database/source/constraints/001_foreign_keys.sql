-- Albums
ALTER TABLE albums
ADD CONSTRAINT fk_albums_artists
FOREIGN KEY (artist_id)
REFERENCES artists(artist_id)
;

-- Songs
ALTER TABLE songs
ADD CONSTRAINT fk_songs_artists
FOREIGN KEY (artist_id)
REFERENCES artists(artist_id)
;
ALTER TABLE songs
ADD CONSTRAINT fk_songs_albums
FOREIGN KEY (album_id)
REFERENCES albums(album_id)
;

-- Playlists
ALTER TABLE playlists
ADD CONSTRAINT fk_playlists_users
FOREIGN KEY (user_id)
REFERENCES users(user_id)
;

-- Podcast Episodes
ALTER TABLE podcast_episodes
ADD CONSTRAINT fk_podcast_episodes_podcasts
FOREIGN KEY (podcast_id)
REFERENCES podcasts(podcast_id)
;

-- Sessions
ALTER TABLE sessions
ADD CONSTRAINT fk_sessions_users
FOREIGN KEY (user_id)
REFERENCES users(user_id)
;

-- Listening History
ALTER TABLE listening_history
ADD CONSTRAINT fk_listening_history_users
FOREIGN KEY (user_id)
REFERENCES users(user_id)
;
ALTER TABLE listening_history
ADD CONSTRAINT fk_listening_history_songs
FOREIGN KEY (song_id)
REFERENCES songs(song_id)
;
ALTER TABLE listening_history
ADD CONSTRAINT fk_listening_history_playlists
FOREIGN KEY (playlist_id)
REFERENCES playlists(playlist_id)
;

-- Podcast Listening History
ALTER TABLE podcast_listening_history
ADD CONSTRAINT fk_podcast_listening_history_users
FOREIGN KEY (user_id)
REFERENCES users(user_id)
;
ALTER TABLE podcast_listening_history
ADD CONSTRAINT fk_podcast_listening_history_podcast_episodes
FOREIGN KEY (episode_id)
REFERENCES podcast_episodes(episode_id)
;

-- Subscriptions
ALTER TABLE user_subscriptions
ADD CONSTRAINT fk_user_subscriptions_users
FOREIGN KEY (user_id)
REFERENCES users(user_id)
;

-- Payments
ALTER TABLE payments
ADD CONSTRAINT fk_payments_users
FOREIGN KEY (user_id)
REFERENCES users(user_id)
;
ALTER TABLE payments
ADD CONSTRAINT fk_payments_user_subscriptions
FOREIGN KEY (subscription_id)
REFERENCES user_subscriptions(subscription_id)
;