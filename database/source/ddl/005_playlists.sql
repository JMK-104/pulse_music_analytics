--  The purpose of this sql script is to create the playlists table in the database.
CREATE TABLE playlists (
    playlist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    playlist_name VARCHAR(255) NOT NULL,
    playlist_description TEXT,
    playlist_type VARCHAR(50) NOT NULL,

    user_id UUID,

    is_public BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;