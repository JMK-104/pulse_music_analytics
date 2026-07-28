-- The purpose of this sql script is to create the podcast_listening_history table in the database.

CREATE TABLE podcast_listening_history(
    podcast_playback_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    playback_timestamp TIMESTAMPTZ NOT NULL,
    seconds_played INTEGER NOT NULL,
    device_type VARCHAR(50),
    source_type VARCHAR(50) NOT NULL,

    user_id UUID NOT NULL,
    episode_id UUID NOT NULL,

    completed BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;