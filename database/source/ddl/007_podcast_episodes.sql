-- The purpose of this sql script is to create the podcast_episodes table in the database.

CREATE TABLE podcast_episodes(
    episode_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    episode_title VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    duration_seconds INTEGER NOT NULL,
    episode_number INTEGER,
    is_explicit BOOLEAN NOT NULL DEFAULT FALSE,

    podcast_id UUID NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;