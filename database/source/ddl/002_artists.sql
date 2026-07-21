-- The purpose of this SQL script is to create the "artists" table in the Pulse Music Source database.

CREATE TABLE artists (
    artist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    artist_name VARCHAR(255) NOT NULL,
    country VARCHAR(100),
    primary_genre VARCHAR(100),
    
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;