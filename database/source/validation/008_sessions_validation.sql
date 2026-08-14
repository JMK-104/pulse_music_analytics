-- ==========================================================
-- Sessions
-- ==========================================================

-- Sessions with missing users
SELECT s.*
FROM source.sessions s
LEFT JOIN source.users u
    ON s.user_id = u.user_id
WHERE u.user_id IS NULL
;

-- Session start times in the future
SELECT *
FROM source.sessions
WHERE session_start_timestamp > CURRENT_TIMESTAMP
;

-- Session end before session start
SELECT *
FROM source.sessions
WHERE session_end_timestamp < session_start_timestamp
;

-- Extremely Long Sessions
SELECT *
FROM source.sessions
WHERE session_end_timestamp - session_start_timestamp 
    > INTERVAL '24 hours'
;

-- Sessions with no end timestamp
SELECT *
FROM source.sessions
WHERE session_end_timestamp IS NULL
;

-- Missing device informaiton
SELECT *
FROM source.sessions
WHERE device_type IS NULL
AND operating_system IS NULL
;

-- Sessions with inactive users
SELECT
    s.session_id,
    s.session_start_timestamp,
    u.user_id
FROM source.sessions s
JOIN source.users u
    ON s.user_id = u.user_id
WHERE u.is_active = FALSE
;

-- Excessive Session frequency
SELECT
    user_id,
    DATE(session_start_timestamp) AS session_date,
    COUNT(*) AS session_count
FROM source.sessions
GROUP BY
    user_id,
    DATE(session_start_timestamp)
HAVING COUNT(*) > 100
;
