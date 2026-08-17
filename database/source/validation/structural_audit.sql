-- Verify that all 13 tables exist in the source schema
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'source'
  AND table_type = 'BASE TABLE'
ORDER BY table_name
;

-- Verify that all columns match documentation specifications
SELECT
    table_name,
    ordinal_position,
    column_name,
    data_type,
    character_maximum_length,
    numeric_precision,
    numeric_scale,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'source'
ORDER BY
    table_name,
    ordinal_position
;

-- Verify that every table has exactly one primary key
SELECT
    tc.table_name,
    kcu.column_name,
    tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
WHERE tc.table_schema = 'source'
  AND tc.constraint_type = 'PRIMARY KEY'
ORDER BY tc.table_name
;

-- Verify foreign key relationships
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column,
    tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name
    AND tc.table_schema = ccu.table_schema
WHERE tc.table_schema = 'source'
  AND tc.constraint_type = 'FOREIGN KEY'
ORDER BY
    tc.table_name,
    kcu.column_name
;

-- Verify constraints are correct
SELECT
    tc.table_name,
    tc.constraint_name,
    cc.check_clause
FROM information_schema.table_constraints tc
JOIN information_schema.check_constraints cc
    ON tc.constraint_name = cc.constraint_name
    AND tc.constraint_schema = cc.constraint_schema
WHERE tc.table_schema = 'source'
  AND tc.constraint_type = 'CHECK'
ORDER BY
    tc.table_name,
    tc.constraint_name
;

-- Verify that indexes are working correctly
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'source'
ORDER BY
    tablename,
    indexname
;

-- Verify that triggers are working properly
SELECT
    trigger_schema,
    event_object_table AS table_name,
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE trigger_schema = 'source'
ORDER BY
    event_object_table,
    trigger_name
;

-- Final Deployment Test
SELECT
    (
        SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'source'
          AND table_type = 'BASE TABLE'
    ) AS table_count,

    (
        SELECT COUNT(*)
        FROM information_schema.table_constraints
        WHERE table_schema = 'source'
          AND constraint_type = 'PRIMARY KEY'
    ) AS primary_key_count,

    (
        SELECT COUNT(*)
        FROM information_schema.table_constraints
        WHERE table_schema = 'source'
          AND constraint_type = 'FOREIGN KEY'
    ) AS foreign_key_count,

    (
        SELECT COUNT(*)
        FROM information_schema.table_constraints
        WHERE table_schema = 'source'
          AND constraint_type = 'CHECK'
    ) AS check_constraint_count,

    (
        SELECT COUNT(*)
        FROM pg_indexes
        WHERE schemaname = 'source'
    ) AS index_count,

    (
        SELECT COUNT(*)
        FROM information_schema.triggers
        WHERE trigger_schema = 'source'
    ) AS trigger_count
;

-- Final Deployment Test #2
SELECT
    CASE
        WHEN COUNT(*) = 13 THEN 'PASS'
        ELSE 'FAIL'
    END AS table_deployment_status,
    COUNT(*) AS actual_table_count,
    13 AS expected_table_count
FROM information_schema.tables
WHERE table_schema = 'source'
  AND table_type = 'BASE TABLE'
;