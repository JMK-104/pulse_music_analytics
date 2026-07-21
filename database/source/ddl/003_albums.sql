-- The purpose of this SQL script is to create the "albums" table in the Pulse Music Source database.

CREATE TABLE albums (
    album_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    album_title VARCHAR(255) NOT NULL,
    release_date DATE,
    album_type VARCHAR(50),
    label_name VARCHAR(255),

    artist_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;