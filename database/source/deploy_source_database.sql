-- ==========================================================
-- Source Database Deployment Script

-- Description: Builds the complete source database schema.

-- Execution Order:
--     1. Tables
--     2. Constraints
--     3. Indexes
--     4. Trigger Functions
--     5. Triggers
-- ==========================================================

\echo ''
\echo '=========================================='
\echo 'Deploying Pulse Music Source Database...'
\echo '=========================================='

\echo ''
\echo 'Creating tables...'

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


\echo '==========================================='
\echo 'Source Database Deployment Complete'
\echo '==========================================='