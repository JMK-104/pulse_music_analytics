-- The purpose of this sql script is to create the subscriptions table in the database.

CREATE TABLE user_subscriptions(
    subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    plan_name VARCHAR(100) NOT NULL,
    billing_cycle VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,

    user_id UUID NOT NULL,

    subscription_status VARCHAR(50) NOT NULL,
    auto_renew BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;