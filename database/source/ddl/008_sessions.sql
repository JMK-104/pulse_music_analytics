-- The purpose of this sql script is to create the sessions table in the database.

CREATE TABLE sessions (
    session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    session_start_timestamp TIMESTAMPTZ NOT NULL,
    session_end_timestamp TIMESTAMPTZ,
    device_type VARCHAR(50),
    operating_system VARCHAR(100),
    country VARCHAR(100),

    user_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;