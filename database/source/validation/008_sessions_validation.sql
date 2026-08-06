-- ==========================================================
-- Sessions
-- ==========================================================

-- Sessions with missing users
SELECT s.*
FROM sessions s
LEFT JOIN users u
    ON s.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Session start times in the future
SELECT *
FROM sessions
WHERE session_start_timestamp > CURRENT_TIMESTAMP
;

-- Session end before session start
SELECT *
FROM sessions
WHERE session_end_timestamp < session_start_timestamp
;

-- Extremely Long Sessions
SELECT *
FROM sessions
WHERE session_end_timestamp - session_start_timestamp 
    > INTERVAL '24 hours'
;

-- Sessions with no end timestamp
SELECT *
FROM sessions
WHERE session_end_timestamp IS NULL
;

-- Missing device informaiton
SELECT *
FROM sessions
WHERE device_type IS NULL
AND operating_system IS NULL
;

-- Sessions with inactive users
SELECT
    s.session_id,
    s.session_start_timestamp,
    u.user_id
FROM sessions s
JOIN users u
    ON s.user_id = u.user_id
WHERE u.is_active = FALSE
;

-- Excessive Session frequency
SELECT
    user_id,
    DATE(session_start_timestamp) AS session_date,
    COUNT(*) AS session_count
FROM sessions
GROUP BY
    user_id,
    DATE(session_start_timestamp)
HAVING COUNT(*) > 100
;