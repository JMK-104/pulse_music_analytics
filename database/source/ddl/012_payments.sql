-- The purpose of this sql script is to create a payments table in the database to store payment information related to subscriptions and users.

CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    payment_timestamp TIMESTAMPTZ NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    payment_method VARCHAR(50),

    subscription_id UUID NOT NULL,
    user_id UUID NOT NULL,

    payment_status VARCHAR(50) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;