-- The purpose of this sql script is to create a table for marketing campaigns in a PostgreSQL database.

CREATE TABLE marketing_campaigns (
    campaign_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    campaign_name VARCHAR(255) NOT NULL,
    channel VARCHAR(100) NOT NULL,
    campaign_objective VARCHAR(100),
    start_date DATE NOT NULL,
    end_date DATE,
    budget NUMERIC(12, 2) NOT NULL,
    spend NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    impressions INTEGER,
    clicks INTEGER,
    conversions INTEGER,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;