-- ==========================================================
-- Pulse Music Analytics
-- Database Deployment

-- To execute: Open terminal and first run psql -U postgres -f database/setup/001_create_database.sql
-- Next, run psql -U postgres -d pulse_music -f database/setup/deploy_database.sql

-- ==========================================================

\echo ''
\echo '=========================================='
\echo 'Pulse Music Analytics Database Deployment'
\echo '=========================================='


-- ==========================================================
-- 1. Schemas
-- ==========================================================

\echo ''
\echo 'CREATING SCHEMAS...'
\echo ''

\ir 003_create_schemas.sql



-- ==========================================================
-- 2. Extensions
-- ==========================================================

\echo ''
\echo 'CREATING EXTENSIONS...'
\echo ''

\ir 002_create_extensions.sql

-- ==========================================================
-- 3. Source Database
-- ==========================================================

\echo ''
\echo 'Deploying source database...'

\ir ../source/deploy_source_database.sql


-- ==========================================================
-- 4. Analytics Database
-- ==========================================================

-- To be implemented later.


-- ==========================================================
-- Complete
-- ==========================================================

\echo ''
\echo '=========================================='
\echo 'Database Deployment Complete'
\echo '=========================================='
