# 7. Indexing Strategy

## 7.1 Purpose

This section defines the indexing strategy for the Pulse Music operational database.

Indexes are used to support:

* Primary key lookups
* Foreign key joins
* Common operational access patterns
* Time-based filtering
* Incremental ETL extraction
* Efficient access to high-volume transactional data

The indexing strategy balances query performance against the storage and write overhead introduced by maintaining indexes.

---

## 7.2 Indexing Principles

The following principles govern index creation:

1. Primary key indexes are created automatically by PostgreSQL.
2. Frequently joined foreign key columns should generally be indexed.
3. High-volume transactional tables require selective indexing.
4. Time-based columns used for incremental ETL extraction should be indexed.
5. Composite indexes should reflect known access patterns and column order.
6. Low-selectivity columns should not automatically receive standalone indexes.
7. Redundant indexes should be avoided.
8. Indexes should be reviewed as query patterns evolve.

The objective is not to maximize the number of indexes, but to create indexes that support identifiable operational and analytical extraction requirements.

---

## 7.3 Primary Key Indexes

PostgreSQL automatically creates a unique B-tree index for every primary key.

| Table                       | Primary Key Index              |
| --------------------------- | ------------------------------ |
| `users`                     | `pk_users`                     |
| `artists`                   | `pk_artists`                   |
| `albums`                    | `pk_albums`                    |
| `songs`                     | `pk_songs`                     |
| `playlists`                 | `pk_playlists`                 |
| `podcasts`                  | `pk_podcasts`                  |
| `podcast_episodes`          | `pk_podcast_episodes`          |
| `sessions`                  | `pk_sessions`                  |
| `listening_history`         | `pk_listening_history`         |
| `podcast_listening_history` | `pk_podcast_listening_history` |
| `user_subscriptions`        | `pk_user_subscriptions`        |
| `payments`                  | `pk_payments`                  |
| `marketing_campaigns`       | `pk_marketing_campaigns`       |

No additional index is created on a primary key column unless a different index type or composite access pattern is explicitly required.

---

## 7.4 Foreign Key Indexes

PostgreSQL does not automatically create indexes on foreign key columns.

Foreign keys used frequently for joins, parent-child lookups, and referential operations should therefore be indexed explicitly.

| Table                       | Column            | Index                                      |
| --------------------------- | ----------------- | ------------------------------------------ |
| `albums`                    | `artist_id`       | `idx_albums_artist_id`                     |
| `songs`                     | `artist_id`       | `idx_songs_artist_id`                      |
| `songs`                     | `album_id`        | `idx_songs_album_id`                       |
| `playlists`                 | `user_id`         | `idx_playlists_user_id`                    |
| `podcast_episodes`          | `podcast_id`      | `idx_podcast_episodes_podcast_id`          |
| `sessions`                  | `user_id`         | `idx_sessions_user_id`                     |
| `listening_history`         | `user_id`         | `idx_listening_history_user_id`            |
| `listening_history`         | `song_id`         | `idx_listening_history_song_id`            |
| `listening_history`         | `playlist_id`     | `idx_listening_history_playlist_id`        |
| `podcast_listening_history` | `user_id`         | `idx_podcast_listening_history_user_id`    |
| `podcast_listening_history` | `episode_id`      | `idx_podcast_listening_history_episode_id` |
| `user_subscriptions`        | `user_id`         | `idx_user_subscriptions_user_id`           |
| `payments`                  | `subscription_id` | `idx_payments_subscription_id`             |
| `payments`                  | `user_id`         | `idx_payments_user_id`                     |

These indexes improve join performance and reduce the cost of checking dependent records during parent-table updates or deletes.

---

## 7.5 Time-Based and Incremental Extraction Indexes

The ETL pipeline extracts new and changed records incrementally wherever practical.

Columns used as extraction watermarks should be indexed when table volume and extraction frequency justify the additional maintenance cost.

### Transaction and Event Tables

| Table                       | Extraction Column         | Index                                      |
| --------------------------- | ------------------------- | ------------------------------------------ |
| `sessions`                  | `session_start_timestamp` | `idx_sessions_start_timestamp`             |
| `listening_history`         | `playback_timestamp`      | `idx_listening_history_playback_timestamp` |
| `podcast_listening_history` | `playback_timestamp`      | `idx_podcast_listening_history_timestamp`  |
| `payments`                  | `payment_timestamp`       | `idx_payments_timestamp`                   |

### Mutable Master and Lifecycle Tables

Tables containing an `updated_at` column may use that column to identify newly inserted or modified records.

Potential extraction columns include:

* `users.updated_at`
* `artists.updated_at`
* `albums.updated_at`
* `songs.updated_at`
* `playlists.updated_at`
* `podcasts.updated_at`
* `podcast_episodes.updated_at`
* `user_subscriptions.updated_at`
* `marketing_campaigns.updated_at`

Indexes on these columns should be created where incremental extraction volume and frequency justify them.

For the initial implementation, these indexes may be added selectively rather than automatically to every table.

---

## 7.6 Composite Indexes

Composite indexes are used where queries commonly filter or order by multiple columns together.

Column order is determined by the expected access pattern.

### User Session History

```text
idx_sessions_user_start
(user_id, session_start_timestamp)
```

Supports queries retrieving a user's sessions over a specified period.

### User Music Listening History

```text
idx_listening_history_user_timestamp
(user_id, playback_timestamp)
```

Supports queries retrieving a user's song playback activity over time.

### User Podcast Listening History

```text
idx_podcast_listening_history_user_timestamp
(user_id, playback_timestamp)
```

Supports queries retrieving a user's podcast playback activity over time.

### User Subscription Status

```text
idx_user_subscriptions_user_status
(user_id, subscription_status)
```

Supports operational lookup of subscription records for a user by status.

Composite indexes should not be created solely because columns are frequently used independently. The combined access pattern must justify the additional index.

---

## 7.7 High-Volume Table Strategy

The largest source tables require particular attention because unnecessary indexes can significantly increase insert cost and storage consumption.

### listening_history

Expected volume:

```text
Approximately 25,000,000 rows
```

Recommended indexes:

* Primary key on `playback_id`
* Foreign key index on `user_id`
* Foreign key index on `song_id`
* Foreign key index on `playlist_id`
* Time-based index on `playback_timestamp`
* Composite index on `(user_id, playback_timestamp)`

Because the table is primarily append-only and receives a high volume of inserts, additional indexes should be added only when supported by a demonstrated query requirement.

---

### podcast_listening_history

Expected volume:

```text
Approximately 3,500,000 rows
```

Recommended indexes:

* Primary key on `podcast_playback_id`
* Foreign key index on `user_id`
* Foreign key index on `episode_id`
* Time-based index on `playback_timestamp`
* Composite index on `(user_id, playback_timestamp)`

The same selective indexing principle applied to music playback events is used for podcast playback events.

---

### sessions

Expected volume:

```text
Approximately 2,000,000 rows
```

Recommended indexes:

* Primary key on `session_id`
* Foreign key index on `user_id`
* Time-based index on `session_start_timestamp`
* Composite index on `(user_id, session_start_timestamp)`

Because session records may be updated after insertion to populate `session_end_timestamp`, unnecessary indexes on frequently updated columns should be avoided.

---

## 7.8 Low-Selectivity Columns

Columns containing a small number of distinct values are generally poor candidates for standalone B-tree indexes.

Examples include:

* Boolean fields
* `is_active`
* `is_public`
* `completed`
* `skipped`
* `auto_renew`
* Broad status categories

A query filtering for a value that matches a large proportion of the table may be more efficiently executed using a sequential scan.

Indexes on low-selectivity columns should therefore be created only when:

* The table is sufficiently large
* The indexed value is highly skewed
* A partial index provides a clear advantage
* Query analysis demonstrates a measurable benefit

---

## 7.9 Partial Indexes

Partial indexes may be considered for frequently accessed subsets of large tables.

For example, if operational queries frequently retrieve only active subscriptions, a partial index could be considered:

```sql
CREATE INDEX idx_user_subscriptions_active
ON user_subscriptions (user_id)
WHERE subscription_status = 'Active';
```

Partial indexes are not required for the initial implementation unless a clear query pattern justifies them.

They are documented as a potential optimization rather than a default requirement.

---

## 7.10 Text Search and Descriptive Columns

Descriptive columns such as names and titles may be searched operationally.

Examples include:

* `artists.artist_name`
* `albums.album_title`
* `songs.song_title`
* `podcasts.podcast_title`
* `podcast_episodes.episode_title`

Standard B-tree indexes may support exact-match and prefix-based lookup patterns.

However, advanced search requirements such as:

* Full-text search
* Fuzzy matching
* Typo tolerance
* Substring search

would require specialized PostgreSQL capabilities such as full-text search or trigram indexes.

These capabilities are outside the scope of the initial source database implementation.

---

## 7.11 Index Naming Standards

Indexes follow the naming convention:

```text
idx_<table>_<column>
```

For composite indexes:

```text
idx_<table>_<column1>_<column2>
```

Examples include:

```text
idx_songs_artist_id

idx_payments_timestamp

idx_listening_history_user_timestamp
```

Index names should be:

* Descriptive
* Consistent
* Unique within the schema
* Short enough to remain within PostgreSQL identifier limits

---

## 7.12 Redundant Index Prevention

Indexes should not duplicate functionality already provided by another index.

For example, a composite index on:

```text
(user_id, playback_timestamp)
```

can support queries filtering on `user_id` alone because `user_id` is the leading column.

Therefore, the need for both:

```text
idx_listening_history_user_id
```

and:

```text
idx_listening_history_user_timestamp
```

should be evaluated against actual workload requirements.

However, foreign key enforcement, index size, query patterns, and planner behavior may still justify retaining both indexes.

Potential redundancy should be evaluated using query execution plans rather than assumptions alone.

---

## 7.13 Index Performance Tradeoffs

Indexes improve read performance but introduce costs.

Each additional index requires:

* Additional disk storage
* Additional processing during inserts
* Additional processing during updates
* Additional processing during deletes
* Ongoing maintenance

These tradeoffs are particularly important for append-heavy tables such as:

* `listening_history`
* `podcast_listening_history`
* `sessions`

The operational database therefore favors a limited set of indexes tied to identifiable access and extraction patterns.

---

## 7.14 Index Monitoring and Maintenance

Index effectiveness should be evaluated using PostgreSQL monitoring and query analysis tools.

Relevant techniques include:

* `EXPLAIN`
* `EXPLAIN ANALYZE`
* PostgreSQL index usage statistics
* Table and index size monitoring
* Identification of unused indexes
* Identification of sequential scans on large tables

Routine PostgreSQL maintenance processes such as `VACUUM` and `ANALYZE` help maintain planner statistics and database performance.

Index definitions should be reviewed as:

* Data volume increases
* Query patterns change
* ETL extraction strategies evolve
* Performance bottlenecks are identified

---

## 7.15 Initial Implementation Strategy

The initial source database implementation will prioritize:

1. Primary key indexes created automatically by PostgreSQL.
2. Indexes on frequently joined foreign key columns.
3. Time-based indexes supporting incremental ETL extraction.
4. A limited number of composite indexes supporting known user-history access patterns.
5. Minimal indexing on high-write transactional tables.
6. Performance testing before introducing additional indexes.

This approach provides a practical starting point without prematurely optimizing for hypothetical workloads.

---

## 7.16 Indexing Strategy Summary

The Pulse Music operational database uses a selective indexing strategy designed to support entity lookups, relational joins, user activity retrieval, and incremental ETL extraction.

Particular attention is given to high-volume transactional tables, where excessive indexing could significantly reduce write performance.

Indexes are treated as workload-driven database objects rather than default additions to every searchable column. The initial implementation establishes a practical baseline that can be refined through query-plan analysis and observed performance.
