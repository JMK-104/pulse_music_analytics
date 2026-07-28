-- The purpose of this sql script is to create the listening_history table in the database.

CREATE TABLE listening_history(
    playback_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    playback_timestamp TIMESTAMPTZ NOT NULL,
    seconds_played INTEGER NOT NULL,
    device_type VARCHAR(50),
    source_type VARCHAR(50) NOT NULL,

    user_id UUID NOT NULL,
    song_id UUID NOT NULL,
    playlist_id UUID,

    completed BOOLEAN NOT NULL DEFAULT FALSE,
    skipped BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;