-- ==========================================================
-- Payments
-- ==========================================================

-- Payments without users
SELECT p.*
FROM payments p
LEFT JOIN users u
    ON p.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Payments without subscriptions
SELECT p.*
FROM payments p
LEFT JOIN user_subscriptions us
    ON p.subscription_id = us.subscription_id
WHERE us.subscription_id IS NULL
;

-- Negative Payment Amounts
SELECT *
FROM payments
WHERE amount < 0
;

-- Zero-value Payments
SELECT *
FROM payments
WHERE amount = 0
;

-- Invalid currency codes
SELECT
    currency,
    COUNT(*) AS payment_count
FROM payments
GROUP BY currency
ORDER BY payment_count DESC
;

-- Missing payment status
SELECT *
FROM payments
WHERE payment_status NOT IN
(
    'completed',
    'pending',
    'failed',
    'refunded'
)
;

-- Future Payment timestamps
SELECT *
FROM payments
WHERE payment_timestamp > CURRENT_TIMESTAMP
;

-- Payments before subscription start dates
SELECT
    p.payment_id,
    p.payment_timestamp,
    us.start_date
FROM payments p
JOIN user_subscriptions us
    ON p.subscription_id = us.subscription_id
WHERE p.payment_timestamp::DATE < us.start_date
;

-- Payments after subscription end dates
SELECT
    p.payment_id,
    p.payment_timestamp,
    us.end_date
FROM payments p
JOIN user_subscriptions us
    ON p.subscription_id = us.subscription_id
WHERE us.end_date IS NOT NULL
AND p.payment_timestamp::DATE > us.end_date
;

-- Duplicate Payments
SELECT
    user_id,
    subscription_id,
    payment_timestamp,
    amount,
    COUNT(*) AS duplicate_count
FROM payments
GROUP BY
    user_id,
    subscription_id,
    payment_timestamp,
    amount
HAVING COUNT(*) > 1
;

-- Payment method profiling
SELECT
    payment_method,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_method
ORDER BY payment_count DESC
;

-- Failed payments with completed subscriptions
SELECT
    p.payment_id,
    us.subscription_status
FROM payments p
JOIN user_subscriptions us
    ON p.subscription_id = us.subscription_id
WHERE p.payment_status = 'failed'
AND us.subscription_status = 'active'
;