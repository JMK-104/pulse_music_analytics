-- The purpose of this sql script is to create the podcasts table in the database.

CREATE TABLE podcasts(
    podcast_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    podcast_title VARCHAR(255) NOT NULL,
    publisher_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    language VARCHAR(50),
    country VARCHAR(100),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;