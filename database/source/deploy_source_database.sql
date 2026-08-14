-- ==========================================================
-- Source Database Deployment Script

-- Description: Builds the complete source database schema.

-- Execution Order:
--     1. Tables
--     2. Constraints
--     3. Indexes
--     4. Triggers
-- ==========================================================

\echo ''
\echo '=========================================='
\echo 'Deploying Pulse Music Source Database...'
\echo '=========================================='

\echo ''
\echo 'CREATING TABLES...'

\ir ddl/001_users.sql
\ir ddl/002_artists.sql
\ir ddl/003_albums.sql
\ir ddl/004_songs.sql
\ir ddl/005_playlists.sql
\ir ddl/006_podcasts.sql
\ir ddl/007_podcast_episodes.sql
\ir ddl/008_sessions.sql
\ir ddl/009_listening_history.sql
\ir ddl/010_podcast_listening_history.sql
\ir ddl/011_user_subscriptions.sql
\ir ddl/012_payments.sql
\ir ddl/013_marketing_campaigns.sql

\echo ''
\echo 'CREATING CONSTRAINTS...'

\ir constraints/001_foreign_keys.sql
\ir constraints/002_check_constraints.sql

\echo ''
\echo 'Checking Constraints...'
\echo 'Constraints Successfully Created'

\echo ''
\echo 'CREATING INDEXES...'


\ir indexes/001_indexes.sql
\echo 'Indexes Successfully Created'
\echo ''

\echo ''
\echo 'CREATING TRIGGERS...'
\echo ''
\echo 'Creating Trigger Function: update_updated_at_column()...'
\ir triggers/001_update_timestamp_function.sql
\echo 'Trigger Function Successfully Created'
\echo ''
\echo 'Creating Trigger: update_updated_at_column_trigger...'
\ir triggers/002_updated_at_triggers.sql
\echo 'Triggers Successfully Created'
\echo ''

\echo '==========================================='
\echo 'Source Database Deployment Complete'
\echo '==========================================='
