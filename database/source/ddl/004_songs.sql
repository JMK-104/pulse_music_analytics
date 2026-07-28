-- The purpose of this sql script is to create the songs table in the database.

CREATE TABLE songs (
    song_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    song_title VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    duration_seconds INTEGER NOT NULL,
    release_date DATE,
    explicit BOOLEAN NOT NULL DEFAULT FALSE,
    
    artist_id UUID NOT NULL,
    album_id UUID,
    
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;