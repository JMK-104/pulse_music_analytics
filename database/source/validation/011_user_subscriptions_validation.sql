-- ==========================================================
-- User Subscriptions
-- ==========================================================

-- Subscriptions without users
SELECT us.*
FROM user_subscriptions us
LEFT JOIN users u
    ON us.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Invalid subscription dates
SELECT *
FROM user_subscriptions
WHERE end_date < start_date
;

-- Future Start dates
SELECT *
FROM user_subscriptions
WHERE start_date > CURRENT_DATE
;

-- Active Subscriptions with past end dates
SELECT *
FROM user_subscriptions
WHERE subscription_status = 'active'
AND end_date < CURRENT_DATE
;

-- Ended subcriptions still marked active
SELECT *
FROM user_subscriptions
WHERE subscription_status = 'expired'
AND end_date IS NULL
;

-- Invalid subscription statuses
SELECT *
FROM user_subscriptions
WHERE subscription_status NOT IN
(
    'active',
    'cancelled',
    'expired',
    'paused'
)
;

-- Invalid Billing Cycles
SELECT *
FROM user_subscriptions
WHERE billing_cycle NOT IN
(
    'Monthly',
    'Annual'
)
;

-- Invalid Plan Names
SELECT
    plan_name,
    COUNT(*) AS subscription_count
FROM user_subscriptions
GROUP BY plan_name
ORDER BY subscription_count DESC
;

-- Multiple Active Subscriptions per user
SELECT
    user_id,
    COUNT(*) AS active_subscription_count
FROM user_subscriptions
WHERE subscription_status = 'active'
GROUP BY user_id
HAVING COUNT(*) > 1
;

-- Overlapping subscription periods
SELECT
    a.user_id,
    a.subscription_id AS subscription_1,
    b.subscription_id AS subscription_2
FROM user_subscriptions a
JOIN user_subscriptions b
    ON a.user_id = b.user_id
    AND a.subscription_id <> b.subscription_id
WHERE a.start_date <= COALESCE(b.end_date, CURRENT_DATE)
AND b.start_date <= COALESCE(a.end_date, CURRENT_DATE)
;

-- Auto-renew consistency
SELECT *
FROM user_subscriptions
WHERE auto_renew = TRUE
AND end_date < CURRENT_DATE
;