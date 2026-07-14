# Source Data Dictionary

# 8.1 users

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `users`                          |
| Schema          | `public`                         |
| Table Type      | Master Data                      |
| Business Domain | User Management                  |
| Primary Key     | `user_id`                        |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `users` table stores information about individuals registered on the Pulse Music platform.

Each record represents a unique user account and contains profile information, registration details, geographic information, subscription preferences, and audit timestamps.

The table serves as the parent entity for several transactional tables, including listening history, sessions, playlists, subscriptions, and payments.

---

## Relationships

| Relationship                      | Type        |
| --------------------------------- | ----------- |
| users → playlists                 | One-to-Many |
| users → sessions                  | One-to-Many |
| users → listening_history         | One-to-Many |
| users → podcast_listening_history | One-to-Many |
| users → user_subscriptions        | One-to-Many |

---

## Columns

| Column              | Data Type    | Nullable | Description                                      |
| ------------------- | ------------ | -------- | ------------------------------------------------ |
| `user_id`           | UUID         | No       | Unique identifier for each user.                 |
| `first_name`        | VARCHAR(100) | No       | User's first name.                               |
| `last_name`         | VARCHAR(100) | No       | User's last name.                                |
| `email`             | VARCHAR(255) | No       | User's email address.                            |
| `date_of_birth`     | DATE         | Yes      | User's date of birth.                            |
| `gender`            | VARCHAR(25)  | Yes      | Self-reported gender.                            |
| `country`           | VARCHAR(100) | Yes      | Country of residence.                            |
| `city`              | VARCHAR(100) | Yes      | City of residence.                               |
| `registration_date` | DATE         | No       | Date the account was created.                    |
| `is_active`         | BOOLEAN      | No       | Indicates whether the account is active.         |
| `created_at`        | TIMESTAMP    | No       | Record creation timestamp (UTC).                 |
| `updated_at`        | TIMESTAMP    | No       | Most recent record modification timestamp (UTC). |

---

## Constraints

| Constraint  | Description                                                                                                 |
| ----------- | ----------------------------------------------------------------------------------------------------------- |
| Primary Key | `user_id`                                                                                                   |
| Unique      | `email`                                                                                                     |
| NOT NULL    | `user_id`, `first_name`, `last_name`, `email`, `registration_date`, `is_active`, `created_at`, `updated_at` |

---

## Indexes

| Index                         | Purpose                        |
| ----------------------------- | ------------------------------ |
| `pk_users`                    | Primary key lookup             |
| `uq_users_email`              | Enforce unique email addresses |
| `idx_users_country`           | Geographic analysis            |
| `idx_users_registration_date` | Registration trend analysis    |

---

## Expected Volume

Approximately **50,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Moderate  |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing city values
* Inconsistent capitalization
* Leading and trailing whitespace
* Invalid country names
* Duplicate email addresses (limited test cases)
* Null gender values
* Future-dated `updated_at` timestamps in selected records

These anomalies are introduced in controlled quantities and are expected to be identified and addressed during Silver layer transformations.

---

# 8.2 artists

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `artists`                        |
| Schema          | `public`                         |
| Table Type      | Master Data                      |
| Business Domain | Music Catalog                    |
| Primary Key     | `artist_id`                      |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `artists` table stores information about music artists and performers whose content is available on the Pulse Music platform.

Each record represents a unique artist and contains descriptive information used to organize and manage the music catalog.

The table serves as a parent entity for albums and songs.

---

## Relationships

| Relationship     | Type        |
| ---------------- | ----------- |
| artists → albums | One-to-Many |
| artists → songs  | One-to-Many |

---

## Columns

| Column          | Data Type    | Nullable | Description                                                       |
| --------------- | ------------ | -------- | ----------------------------------------------------------------- |
| `artist_id`     | UUID         | No       | Unique identifier for each artist.                                |
| `artist_name`   | VARCHAR(255) | No       | Display name of the artist.                                       |
| `country`       | VARCHAR(100) | Yes      | Artist's country of origin.                                       |
| `primary_genre` | VARCHAR(100) | Yes      | Primary musical genre associated with the artist.                 |
| `is_active`     | BOOLEAN      | No       | Indicates whether the artist is currently active on the platform. |
| `created_at`    | TIMESTAMP    | No       | Record creation timestamp (UTC).                                  |
| `updated_at`    | TIMESTAMP    | No       | Most recent record modification timestamp (UTC).                  |

---

## Constraints

| Constraint  | Description                                                         |
| ----------- | ------------------------------------------------------------------- |
| Primary Key | `artist_id`                                                         |
| NOT NULL    | `artist_id`, `artist_name`, `is_active`, `created_at`, `updated_at` |

Artist names are not required to be unique because multiple artists may legitimately share the same display name.

---

## Indexes

| Index                       | Purpose                       |
| --------------------------- | ----------------------------- |
| `pk_artists`                | Primary key lookup            |
| `idx_artists_artist_name`   | Artist name search and lookup |
| `idx_artists_primary_genre` | Genre-based filtering         |
| `idx_artists_country`       | Geographic filtering          |

---

## Expected Volume

Approximately **5,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Low       |
| UPDATE    | Low       |
| DELETE    | Rare      |

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing country values
* Missing primary genre values
* Inconsistent genre capitalization
* Leading and trailing whitespace in artist names
* Country names represented using inconsistent formats
* Duplicate artist records in limited test cases
* Future-dated `updated_at` timestamps in selected records

These anomalies are introduced in controlled quantities and are expected to be identified and addressed during Silver layer transformations.

---

# 8.3 albums

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `albums`                         |
| Schema          | `public`                         |
| Table Type      | Master Data                      |
| Business Domain | Music Catalog                    |
| Primary Key     | `album_id`                       |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `albums` table stores metadata for music albums available on the Pulse Music platform.

Each record represents a distinct album or release associated with an artist. Album metadata supports music catalog organization and provides contextual information for individual songs.

The table acts as a parent entity for songs.

---

## Relationships

| Relationship     | Type        |
| ---------------- | ----------- |
| artists → albums | One-to-Many |
| albums → songs   | One-to-Many |

---

## Columns

| Column         | Data Type    | Nullable | Description                                                  |
| -------------- | ------------ | -------- | ------------------------------------------------------------ |
| `album_id`     | UUID         | No       | Unique identifier for each album.                            |
| `artist_id`    | UUID         | No       | Identifier of the artist associated with the album.          |
| `album_title`  | VARCHAR(255) | No       | Title of the album.                                          |
| `release_date` | DATE         | Yes      | Official release date of the album.                          |
| `album_type`   | VARCHAR(50)  | Yes      | Classification of the release, such as Album, EP, or Single. |
| `label_name`   | VARCHAR(255) | Yes      | Record label associated with the release.                    |
| `created_at`   | TIMESTAMP    | No       | Record creation timestamp (UTC).                             |
| `updated_at`   | TIMESTAMP    | No       | Most recent record modification timestamp (UTC).             |

---

## Constraints

| Constraint  | Description                                                        |
| ----------- | ------------------------------------------------------------------ |
| Primary Key | `album_id`                                                         |
| Foreign Key | `artist_id` references `artists.artist_id`                         |
| NOT NULL    | `album_id`, `artist_id`, `album_title`, `created_at`, `updated_at` |

---

## Indexes

| Index                     | Purpose                    |
| ------------------------- | -------------------------- |
| `pk_albums`               | Primary key lookup         |
| `idx_albums_artist_id`    | Artist relationship lookup |
| `idx_albums_album_title`  | Album title search         |
| `idx_albums_release_date` | Release date filtering     |

---

## Expected Volume

Approximately **15,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Low       |
| UPDATE    | Low       |
| DELETE    | Rare      |

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing release dates
* Missing record label values
* Inconsistent album type capitalization
* Leading and trailing whitespace in album titles
* Invalid album type values in limited test cases
* Future release dates in selected records
* Duplicate album records in controlled test cases

These anomalies are introduced in controlled quantities and are expected to be identified and addressed during Silver layer transformations.

---

# 8.4 songs

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `songs`                          |
| Schema          | `public`                         |
| Table Type      | Master Data                      |
| Business Domain | Music Catalog                    |
| Primary Key     | `song_id`                        |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `songs` table stores metadata for individual music tracks available for streaming on the Pulse Music platform.

Each record represents a unique song and identifies its primary artist, optional album association, musical characteristics, duration, and release information.

The table serves as the primary content reference for song playback events recorded in `listening_history`.

---

## Relationships

| Relationship              | Type        |
| ------------------------- | ----------- |
| artists → songs           | One-to-Many |
| albums → songs            | One-to-Many |
| songs → listening_history | One-to-Many |

The relationship between albums and songs is optional because standalone singles may exist without an associated album.

---

## Columns

| Column             | Data Type    | Nullable | Description                                                      |
| ------------------ | ------------ | -------- | ---------------------------------------------------------------- |
| `song_id`          | UUID         | No       | Unique identifier for each song.                                 |
| `artist_id`        | UUID         | No       | Identifier of the song's primary artist.                         |
| `album_id`         | UUID         | Yes      | Identifier of the associated album, where applicable.            |
| `song_title`       | VARCHAR(255) | No       | Title of the song.                                               |
| `genre`            | VARCHAR(100) | Yes      | Musical genre assigned to the song.                              |
| `duration_seconds` | INTEGER      | No       | Total song duration in seconds.                                  |
| `release_date`     | DATE         | Yes      | Official release date of the song.                               |
| `explicit`         | BOOLEAN      | No       | Indicates whether the song contains explicit content.            |
| `is_active`        | BOOLEAN      | No       | Indicates whether the song is currently available for streaming. |
| `created_at`       | TIMESTAMP    | No       | Record creation timestamp (UTC).                                 |
| `updated_at`       | TIMESTAMP    | No       | Most recent record modification timestamp (UTC).                 |

---

## Constraints

| Constraint  | Description                                                                                                   |
| ----------- | ------------------------------------------------------------------------------------------------------------- |
| Primary Key | `song_id`                                                                                                     |
| Foreign Key | `artist_id` references `artists.artist_id`                                                                    |
| Foreign Key | `album_id` references `albums.album_id`                                                                       |
| Check       | `duration_seconds > 0`                                                                                        |
| NOT NULL    | `song_id`, `artist_id`, `song_title`, `duration_seconds`, `explicit`, `is_active`, `created_at`, `updated_at` |

---

## Indexes

| Index                  | Purpose                    |
| ---------------------- | -------------------------- |
| `pk_songs`             | Primary key lookup         |
| `idx_songs_artist_id`  | Artist relationship lookup |
| `idx_songs_album_id`   | Album relationship lookup  |
| `idx_songs_song_title` | Song title search          |
| `idx_songs_genre`      | Genre-based filtering      |

---

## Expected Volume

Approximately **200,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Low       |
| UPDATE    | Low       |
| DELETE    | Rare      |

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing genre values
* Inconsistent genre capitalization
* Leading and trailing whitespace in song titles
* Invalid genre labels
* Unrealistic or invalid durations in selected test records
* Future release dates
* Duplicate song records in controlled test cases
* Inconsistent artist and album associations in selected records

Where database constraints would prevent an intentionally invalid record from being stored directly, the anomaly may instead be introduced in the extracted raw data used by the ETL pipeline.

---

# 8.5 playlists

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `playlists`                      |
| Schema          | `public`                         |
| Table Type      | Master Data                      |
| Business Domain | Music Catalog                    |
| Primary Key     | `playlist_id`                    |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `playlists` table stores metadata for playlists available on the Pulse Music platform.

Each record represents either a user-created or platform-managed playlist. The table captures playlist ownership and descriptive information used to classify how playlists are created and managed.

The current source model stores playlist-level metadata only. Individual playlist membership is outside the scope of this project.

---

## Relationships

| Relationship      | Type        |
| ----------------- | ----------- |
| users → playlists | One-to-Many |

User ownership may be optional for platform-managed editorial playlists.

---

## Columns

| Column                 | Data Type    | Nullable | Description                                                                                 |
| ---------------------- | ------------ | -------- | ------------------------------------------------------------------------------------------- |
| `playlist_id`          | UUID         | No       | Unique identifier for each playlist.                                                        |
| `user_id`              | UUID         | Yes      | Identifier of the user who owns the playlist. Null for selected platform-managed playlists. |
| `playlist_name`        | VARCHAR(255) | No       | Display name of the playlist.                                                               |
| `playlist_description` | TEXT         | Yes      | Optional description of the playlist.                                                       |
| `playlist_type`        | VARCHAR(50)  | No       | Classification such as User, Editorial, or Algorithmic.                                     |
| `is_public`            | BOOLEAN      | No       | Indicates whether the playlist is publicly accessible.                                      |
| `created_at`           | TIMESTAMP    | No       | Record creation timestamp (UTC).                                                            |
| `updated_at`           | TIMESTAMP    | No       | Most recent record modification timestamp (UTC).                                            |

---

## Constraints

| Constraint  | Description                                                                              |
| ----------- | ---------------------------------------------------------------------------------------- |
| Primary Key | `playlist_id`                                                                            |
| Foreign Key | `user_id` references `users.user_id`                                                     |
| NOT NULL    | `playlist_id`, `playlist_name`, `playlist_type`, `is_public`, `created_at`, `updated_at` |

---

## Indexes

| Index                         | Purpose                   |
| ----------------------------- | ------------------------- |
| `pk_playlists`                | Primary key lookup        |
| `idx_playlists_user_id`       | User ownership lookup     |
| `idx_playlists_playlist_type` | Playlist type filtering   |
| `idx_playlists_is_public`     | Public playlist filtering |

---

## Expected Volume

Approximately **80,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Moderate  |
| UPDATE    | Moderate  |
| DELETE    | Low       |

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing playlist descriptions
* Leading and trailing whitespace in playlist names
* Inconsistent playlist type capitalization
* Invalid playlist type values in limited test cases
* Missing user identifiers where ownership should normally exist
* Duplicate playlist records in controlled test cases
* Inconsistent `is_public` values in selected test scenarios

These anomalies are introduced in controlled quantities and are expected to be identified and addressed during Silver layer transformations.

---

# 8.6 podcasts

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `podcasts`                       |
| Schema          | `public`                         |
| Table Type      | Master Data                      |
| Business Domain | Podcast Catalog                  |
| Primary Key     | `podcast_id`                     |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `podcasts` table stores metadata for podcast series available on the Pulse Music platform.

Each record represents a unique podcast and contains descriptive information used to organize, categorize, and manage the podcast catalog.

The table serves as the parent entity for individual podcast episodes.

---

## Relationships

| Relationship                | Type        |
| --------------------------- | ----------- |
| podcasts → podcast_episodes | One-to-Many |

---

## Columns

| Column           | Data Type    | Nullable | Description                                                           |
| ---------------- | ------------ | -------- | --------------------------------------------------------------------- |
| `podcast_id`     | UUID         | No       | Unique identifier for each podcast.                                   |
| `podcast_title`  | VARCHAR(255) | No       | Display title of the podcast.                                         |
| `publisher_name` | VARCHAR(255) | No       | Name of the podcast publisher or creator.                             |
| `category`       | VARCHAR(100) | Yes      | Primary content category assigned to the podcast.                     |
| `language`       | VARCHAR(50)  | Yes      | Primary language of the podcast.                                      |
| `country`        | VARCHAR(100) | Yes      | Country associated with the podcast or publisher.                     |
| `is_active`      | BOOLEAN      | No       | Indicates whether the podcast is currently available on the platform. |
| `created_at`     | TIMESTAMP    | No       | Record creation timestamp (UTC).                                      |
| `updated_at`     | TIMESTAMP    | No       | Most recent record modification timestamp (UTC).                      |

---

## Constraints

| Constraint  | Description                                                                              |
| ----------- | ---------------------------------------------------------------------------------------- |
| Primary Key | `podcast_id`                                                                             |
| NOT NULL    | `podcast_id`, `podcast_title`, `publisher_name`, `is_active`, `created_at`, `updated_at` |

Podcast titles are not required to be unique because different publishers may use identical or similar titles.

---

## Indexes

| Index                         | Purpose                  |
| ----------------------------- | ------------------------ |
| `pk_podcasts`                 | Primary key lookup       |
| `idx_podcasts_podcast_title`  | Podcast title search     |
| `idx_podcasts_publisher_name` | Publisher-based lookup   |
| `idx_podcasts_category`       | Category-based filtering |

---

## Expected Volume

Approximately **3,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Low       |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing category values
* Missing language values
* Missing country values
* Inconsistent category capitalization
* Inconsistent language representations
* Leading and trailing whitespace in podcast titles
* Invalid category values in limited test cases
* Duplicate podcast records in controlled test cases

These anomalies are introduced in controlled quantities and are expected to be identified and addressed during Silver layer transformations.

---

# 8.7 podcast_episodes

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `podcast_episodes`               |
| Schema          | `public`                         |
| Table Type      | Master Data                      |
| Business Domain | Podcast Catalog                  |
| Primary Key     | `episode_id`                     |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `podcast_episodes` table stores metadata for individual podcast episodes available on the Pulse Music platform.

Each record represents a unique episode belonging to a podcast series and contains information about its title, publication date, duration, and availability.

The table serves as the primary content reference for podcast playback events recorded in `podcast_listening_history`.

---

## Relationships

| Relationship                                 | Type        |
| -------------------------------------------- | ----------- |
| podcasts → podcast_episodes                  | One-to-Many |
| podcast_episodes → podcast_listening_history | One-to-Many |

---

## Columns

| Column             | Data Type    | Nullable | Description                                                         |
| ------------------ | ------------ | -------- | ------------------------------------------------------------------- |
| `episode_id`       | UUID         | No       | Unique identifier for each podcast episode.                         |
| `podcast_id`       | UUID         | No       | Identifier of the podcast to which the episode belongs.             |
| `episode_title`    | VARCHAR(255) | No       | Display title of the episode.                                       |
| `release_date`     | DATE         | No       | Date on which the episode was published.                            |
| `duration_seconds` | INTEGER      | No       | Total episode duration in seconds.                                  |
| `episode_number`   | INTEGER      | Yes      | Episode sequence number where provided by the publisher.            |
| `is_explicit`      | BOOLEAN      | No       | Indicates whether the episode contains explicit content.            |
| `is_active`        | BOOLEAN      | No       | Indicates whether the episode is currently available for streaming. |
| `created_at`       | TIMESTAMP    | No       | Record creation timestamp (UTC).                                    |
| `updated_at`       | TIMESTAMP    | No       | Most recent record modification timestamp (UTC).                    |

---

## Constraints

| Constraint  | Description                                                                                                                             |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Primary Key | `episode_id`                                                                                                                            |
| Foreign Key | `podcast_id` references `podcasts.podcast_id`                                                                                           |
| Check       | `duration_seconds > 0`                                                                                                                  |
| Check       | `episode_number > 0` when populated                                                                                                     |
| NOT NULL    | `episode_id`, `podcast_id`, `episode_title`, `release_date`, `duration_seconds`, `is_explicit`, `is_active`, `created_at`, `updated_at` |

---

## Indexes

| Index                                | Purpose                     |
| ------------------------------------ | --------------------------- |
| `pk_podcast_episodes`                | Primary key lookup          |
| `idx_podcast_episodes_podcast_id`    | Podcast relationship lookup |
| `idx_podcast_episodes_release_date`  | Release date filtering      |
| `idx_podcast_episodes_episode_title` | Episode title search        |

---

## Expected Volume

Approximately **75,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Moderate  |
| UPDATE    | Low       |
| DELETE    | Rare      |

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing episode numbers
* Leading and trailing whitespace in episode titles
* Future release dates in selected records
* Unrealistic episode durations in controlled test cases
* Duplicate episode records
* Inconsistent explicit-content indicators in raw source extracts
* Incorrect episode numbering sequences

Where operational constraints prevent invalid values from being stored directly, selected anomalies may be introduced during raw data extraction for ETL testing.

---

# 8.8 sessions

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `sessions`                       |
| Schema          | `public`                         |
| Table Type      | Transaction Data                 |
| Business Domain | User Engagement                  |
| Primary Key     | `session_id`                     |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `sessions` table records application sessions generated when users interact with the Pulse Music platform.

Each record represents a distinct user session and captures when the session began and ended, the device used, and the user's location at the time of the session.

Session data supports analysis of user activity, engagement frequency, platform usage, and device behavior.

---

## Relationships

| Relationship     | Type        |
| ---------------- | ----------- |
| users → sessions | One-to-Many |

---

## Columns

| Column                    | Data Type    | Nullable | Description                                         |
| ------------------------- | ------------ | -------- | --------------------------------------------------- |
| `session_id`              | UUID         | No       | Unique identifier for each application session.     |
| `user_id`                 | UUID         | No       | Identifier of the user associated with the session. |
| `session_start_timestamp` | TIMESTAMP    | No       | Date and time the session began (UTC).              |
| `session_end_timestamp`   | TIMESTAMP    | Yes      | Date and time the session ended (UTC).              |
| `device_type`             | VARCHAR(50)  | Yes      | General category of device used during the session. |
| `operating_system`        | VARCHAR(100) | Yes      | Operating system used during the session.           |
| `country`                 | VARCHAR(100) | Yes      | Country from which the session originated.          |
| `created_at`              | TIMESTAMP    | No       | Record creation timestamp (UTC).                    |

---

## Constraints

| Constraint  | Description                                                                     |
| ----------- | ------------------------------------------------------------------------------- |
| Primary Key | `session_id`                                                                    |
| Foreign Key | `user_id` references `users.user_id`                                            |
| Check       | `session_end_timestamp >= session_start_timestamp` when an end timestamp exists |
| NOT NULL    | `session_id`, `user_id`, `session_start_timestamp`, `created_at`                |

A null `session_end_timestamp` may represent an active session or a session that ended without a recorded termination event.

---

## Indexes

| Index                          | Purpose                             |
| ------------------------------ | ----------------------------------- |
| `pk_sessions`                  | Primary key lookup                  |
| `idx_sessions_user_id`         | User activity lookup                |
| `idx_sessions_start_timestamp` | Time-based extraction and filtering |
| `idx_sessions_user_start`      | User session history lookup         |

---

## Expected Volume

Approximately **2,000,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Very High |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

Session records may initially be inserted without an end timestamp and subsequently updated when the session terminates.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing session end timestamps
* Missing device information
* Inconsistent device type capitalization
* Inconsistent operating system names
* Missing or invalid country values
* Duplicate session records in controlled test cases
* Future-dated session timestamps
* Session end timestamps preceding start timestamps in raw source extracts

Where database constraints prevent invalid chronological relationships from being stored directly, selected anomalies may be introduced during raw data extraction.

---

# 8.9 listening_history

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `listening_history`              |
| Schema          | `public`                         |
| Table Type      | Transaction Data                 |
| Business Domain | User Engagement                  |
| Primary Key     | `playback_id`                    |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `listening_history` table records individual song playback events generated by users of the Pulse Music platform.

Each record represents a single playback event and captures the user, song, playback timing, listening duration, device context, playback source, and completion behavior.

The table is one of the highest-volume transactional tables in the source system and serves as the primary source for music engagement analysis.

---

## Relationships

| Relationship                  | Type        |
| ----------------------------- | ----------- |
| users → listening_history     | One-to-Many |
| songs → listening_history     | One-to-Many |
| playlists → listening_history | One-to-Many |

The playlist relationship is optional because many listening events originate from sources other than playlists.

---

## Columns

| Column               | Data Type   | Nullable | Description                                                          |
| -------------------- | ----------- | -------- | -------------------------------------------------------------------- |
| `playback_id`        | UUID        | No       | Unique identifier for each song playback event.                      |
| `user_id`            | UUID        | No       | Identifier of the user who generated the playback event.             |
| `song_id`            | UUID        | No       | Identifier of the song played.                                       |
| `playlist_id`        | UUID        | Yes      | Identifier of the originating playlist, where applicable.            |
| `playback_timestamp` | TIMESTAMP   | No       | Date and time the playback began (UTC).                              |
| `seconds_played`     | INTEGER     | No       | Number of seconds the user listened to the song.                     |
| `device_type`        | VARCHAR(50) | Yes      | Device category used for playback.                                   |
| `source_type`        | VARCHAR(50) | No       | Source from which playback was initiated.                            |
| `completed`          | BOOLEAN     | No       | Indicates whether the playback met the defined completion threshold. |
| `skipped`            | BOOLEAN     | No       | Indicates whether the user skipped the song.                         |
| `created_at`         | TIMESTAMP   | No       | Record creation timestamp (UTC).                                     |

---

## Constraints

| Constraint  | Description                                                                                                                      |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Primary Key | `playback_id`                                                                                                                    |
| Foreign Key | `user_id` references `users.user_id`                                                                                             |
| Foreign Key | `song_id` references `songs.song_id`                                                                                             |
| Foreign Key | `playlist_id` references `playlists.playlist_id`                                                                                 |
| Check       | `seconds_played >= 0`                                                                                                            |
| NOT NULL    | `playback_id`, `user_id`, `song_id`, `playback_timestamp`, `seconds_played`, `source_type`, `completed`, `skipped`, `created_at` |

Validation ensuring that `seconds_played` does not materially exceed the associated song duration is performed during ETL processing because the rule requires comparison with the `songs` table.

---

## Indexes

| Index                                      | Purpose                                         |
| ------------------------------------------ | ----------------------------------------------- |
| `pk_listening_history`                     | Primary key lookup                              |
| `idx_listening_history_user_id`            | User listening history lookup                   |
| `idx_listening_history_song_id`            | Song playback lookup                            |
| `idx_listening_history_playlist_id`        | Playlist-originated playback lookup             |
| `idx_listening_history_playback_timestamp` | Incremental extraction and time-based filtering |
| `idx_listening_history_user_timestamp`     | User listening activity over time               |

---

## Expected Volume

Approximately **25,000,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Very High |
| UPDATE    | Very Low  |
| DELETE    | Rare      |

Listening events are primarily append-only after creation.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing device information
* Inconsistent device type capitalization
* Invalid or inconsistent playback source values
* Duplicate playback events in controlled test cases
* Future-dated playback timestamps
* Playback durations exceeding the associated song duration
* Contradictory `completed` and `skipped` indicators
* Missing playlist identifiers for selected playlist-originated events
* Orphaned identifiers in raw source extracts used for ETL testing

Where database constraints prevent an intentionally invalid record from being stored directly, the anomaly may instead be introduced during raw source extraction.

---

# 8.10 podcast_listening_history

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `podcast_listening_history`      |
| Schema          | `public`                         |
| Table Type      | Transaction Data                 |
| Business Domain | User Engagement                  |
| Primary Key     | `podcast_playback_id`            |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `podcast_listening_history` table records individual podcast episode playback events generated by users of the Pulse Music platform.

Each record represents a single podcast playback event and captures the user, episode, playback timing, listening duration, device context, and completion behavior.

The table serves as the primary source for podcast engagement and consumption analysis.

---

## Relationships

| Relationship                                 | Type        |
| -------------------------------------------- | ----------- |
| users → podcast_listening_history            | One-to-Many |
| podcast_episodes → podcast_listening_history | One-to-Many |

---

## Columns

| Column                | Data Type   | Nullable | Description                                                          |
| --------------------- | ----------- | -------- | -------------------------------------------------------------------- |
| `podcast_playback_id` | UUID        | No       | Unique identifier for each podcast playback event.                   |
| `user_id`             | UUID        | No       | Identifier of the user who generated the playback event.             |
| `episode_id`          | UUID        | No       | Identifier of the podcast episode played.                            |
| `playback_timestamp`  | TIMESTAMP   | No       | Date and time the playback began (UTC).                              |
| `seconds_played`      | INTEGER     | No       | Number of seconds the user listened to the episode.                  |
| `device_type`         | VARCHAR(50) | Yes      | Device category used for playback.                                   |
| `source_type`         | VARCHAR(50) | No       | Source from which playback was initiated.                            |
| `completed`           | BOOLEAN     | No       | Indicates whether the playback met the defined completion threshold. |
| `created_at`          | TIMESTAMP   | No       | Record creation timestamp (UTC).                                     |

---

## Constraints

| Constraint  | Description                                                                                                                      |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Primary Key | `podcast_playback_id`                                                                                                            |
| Foreign Key | `user_id` references `users.user_id`                                                                                             |
| Foreign Key | `episode_id` references `podcast_episodes.episode_id`                                                                            |
| Check       | `seconds_played >= 0`                                                                                                            |
| NOT NULL    | `podcast_playback_id`, `user_id`, `episode_id`, `playback_timestamp`, `seconds_played`, `source_type`, `completed`, `created_at` |

Validation ensuring that `seconds_played` does not materially exceed the associated episode duration is performed during ETL processing.

---

## Indexes

| Index                                          | Purpose                                         |
| ---------------------------------------------- | ----------------------------------------------- |
| `pk_podcast_listening_history`                 | Primary key lookup                              |
| `idx_podcast_listening_history_user_id`        | User podcast activity lookup                    |
| `idx_podcast_listening_history_episode_id`     | Episode playback lookup                         |
| `idx_podcast_listening_history_timestamp`      | Incremental extraction and time-based filtering |
| `idx_podcast_listening_history_user_timestamp` | User podcast activity over time                 |

---

## Expected Volume

Approximately **3,500,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Very High |
| UPDATE    | Very Low  |
| DELETE    | Rare      |

Podcast playback events are primarily append-only after creation.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing device information
* Inconsistent device type capitalization
* Invalid or inconsistent playback source values
* Duplicate playback events
* Future-dated playback timestamps
* Playback durations exceeding episode duration
* Incorrect completion indicators
* Orphaned identifiers in raw source extracts used for ETL testing

Where operational constraints prevent invalid records from being stored directly, selected anomalies may be introduced during raw source extraction.

---

# 8.11 user_subscriptions

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `user_subscriptions`             |
| Schema          | `public`                         |
| Table Type      | Transaction Data                 |
| Business Domain | User Management                  |
| Primary Key     | `subscription_id`                |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `user_subscriptions` table records the subscription lifecycle of Pulse Music users.

Each record represents a distinct subscription period and captures the user, subscription plan, billing cycle, subscription status, start date, and termination or renewal information.

A user may have multiple subscription records over time as they subscribe, cancel, renew, or change plans.

---

## Relationships

| Relationship                  | Type        |
| ----------------------------- | ----------- |
| users → user_subscriptions    | One-to-Many |
| user_subscriptions → payments | One-to-Many |

---

## Columns

| Column                | Data Type    | Nullable | Description                                                |
| --------------------- | ------------ | -------- | ---------------------------------------------------------- |
| `subscription_id`     | UUID         | No       | Unique identifier for each subscription record.            |
| `user_id`             | UUID         | No       | Identifier of the subscribed user.                         |
| `plan_name`           | VARCHAR(100) | No       | Name of the subscription plan.                             |
| `billing_cycle`       | VARCHAR(50)  | No       | Billing frequency, such as Monthly or Annual.              |
| `subscription_status` | VARCHAR(50)  | No       | Current status of the subscription record.                 |
| `start_date`          | DATE         | No       | Date the subscription period began.                        |
| `end_date`            | DATE         | Yes      | Date the subscription period ended or is scheduled to end. |
| `auto_renew`          | BOOLEAN      | No       | Indicates whether automatic renewal is enabled.            |
| `created_at`          | TIMESTAMP    | No       | Record creation timestamp (UTC).                           |
| `updated_at`          | TIMESTAMP    | No       | Most recent record modification timestamp (UTC).           |

---

## Constraints

| Constraint  | Description                                                                                                                               |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Primary Key | `subscription_id`                                                                                                                         |
| Foreign Key | `user_id` references `users.user_id`                                                                                                      |
| Check       | `end_date >= start_date` when an end date exists                                                                                          |
| NOT NULL    | `subscription_id`, `user_id`, `plan_name`, `billing_cycle`, `subscription_status`, `start_date`, `auto_renew`, `created_at`, `updated_at` |

---

## Indexes

| Index                                | Purpose                          |
| ------------------------------------ | -------------------------------- |
| `pk_user_subscriptions`              | Primary key lookup               |
| `idx_user_subscriptions_user_id`     | User subscription history lookup |
| `idx_user_subscriptions_status`      | Subscription status filtering    |
| `idx_user_subscriptions_start_date`  | Subscription trend analysis      |
| `idx_user_subscriptions_user_status` | Active subscription lookup       |

---

## Expected Volume

Approximately **120,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Moderate  |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

Subscription records may be updated as lifecycle events occur.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Inconsistent plan name capitalization
* Invalid plan names in limited test cases
* Inconsistent billing cycle values
* Invalid subscription status values
* Missing end dates for terminated subscriptions
* Contradictory status and auto-renew combinations
* Overlapping subscription periods for selected users
* Duplicate subscription records
* Future-dated subscription events

Cross-record lifecycle anomalies, such as overlapping subscription periods, are validated during ETL processing.

---

# 8.12 payments

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `payments`                       |
| Schema          | `public`                         |
| Table Type      | Transaction Data                 |
| Business Domain | Commerce                         |
| Primary Key     | `payment_id`                     |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `payments` table records financial transactions associated with Pulse Music subscriptions.

Each record represents an individual payment attempt and captures the related subscription, user, transaction amount, currency, payment method, transaction status, and processing timestamp.

The table supports revenue, payment success, payment failure, and subscription monetization analysis.

---

## Relationships

| Relationship                  | Type        |
| ----------------------------- | ----------- |
| user_subscriptions → payments | One-to-Many |
| users → payments              | One-to-Many |

The direct user reference supports operational lookup and auditing while the subscription reference identifies the subscription associated with the transaction.

---

## Columns

| Column              | Data Type     | Nullable | Description                                                 |
| ------------------- | ------------- | -------- | ----------------------------------------------------------- |
| `payment_id`        | UUID          | No       | Unique identifier for each payment transaction.             |
| `subscription_id`   | UUID          | No       | Identifier of the subscription associated with the payment. |
| `user_id`           | UUID          | No       | Identifier of the user associated with the payment.         |
| `payment_timestamp` | TIMESTAMP     | No       | Date and time the payment was processed (UTC).              |
| `amount`            | NUMERIC(10,2) | No       | Monetary value of the transaction.                          |
| `currency`          | VARCHAR(3)    | No       | Three-character transaction currency code.                  |
| `payment_method`    | VARCHAR(50)   | Yes      | Payment method used for the transaction.                    |
| `payment_status`    | VARCHAR(50)   | No       | Outcome or current status of the payment transaction.       |
| `created_at`        | TIMESTAMP     | No       | Record creation timestamp (UTC).                            |

---

## Constraints

| Constraint  | Description                                                                                                           |
| ----------- | --------------------------------------------------------------------------------------------------------------------- |
| Primary Key | `payment_id`                                                                                                          |
| Foreign Key | `subscription_id` references `user_subscriptions.subscription_id`                                                     |
| Foreign Key | `user_id` references `users.user_id`                                                                                  |
| Check       | `amount >= 0`                                                                                                         |
| NOT NULL    | `payment_id`, `subscription_id`, `user_id`, `payment_timestamp`, `amount`, `currency`, `payment_status`, `created_at` |

Cross-table validation ensures that the `user_id` associated with a payment matches the user associated with the referenced subscription.

---

## Indexes

| Index                          | Purpose                                         |
| ------------------------------ | ----------------------------------------------- |
| `pk_payments`                  | Primary key lookup                              |
| `idx_payments_subscription_id` | Subscription payment lookup                     |
| `idx_payments_user_id`         | User payment history lookup                     |
| `idx_payments_timestamp`       | Incremental extraction and time-based filtering |
| `idx_payments_status`          | Payment outcome filtering                       |

---

## Expected Volume

Approximately **450,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Moderate  |
| UPDATE    | Low       |
| DELETE    | Rare      |

Payment records are generally treated as immutable financial events after their final status is established.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing payment method values
* Inconsistent payment method capitalization
* Invalid currency codes
* Inconsistent payment status values
* Zero-value transactions
* Duplicate payment records
* Future-dated payment timestamps
* Payment timestamps occurring before the associated subscription start date
* User identifiers that do not match the referenced subscription in controlled test cases

Where operational constraints prevent selected anomalies, they may be introduced during raw source extraction.

---

# 8.13 marketing_campaigns

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `marketing_campaigns`            |
| Schema          | `public`                         |
| Table Type      | Configuration Data               |
| Business Domain | Marketing                        |
| Primary Key     | `campaign_id`                    |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `marketing_campaigns` table stores information about marketing campaigns conducted to acquire, engage, or retain Pulse Music users.

Each record represents a campaign and captures its channel, objective, schedule, budget, and high-level performance metrics.

The table provides the source data required for marketing performance, acquisition efficiency, and return-on-investment analysis.

---

## Relationships

The `marketing_campaigns` table is independent within the current operational model and does not enforce direct foreign key relationships with other source tables.

Campaign attribution and analytical relationships are established during downstream warehouse transformations where applicable.

---

## Columns

| Column               | Data Type     | Nullable | Description                                      |
| -------------------- | ------------- | -------- | ------------------------------------------------ |
| `campaign_id`        | UUID          | No       | Unique identifier for each marketing campaign.   |
| `campaign_name`      | VARCHAR(255)  | No       | Business name of the campaign.                   |
| `channel`            | VARCHAR(100)  | No       | Marketing channel used to deliver the campaign.  |
| `campaign_objective` | VARCHAR(100)  | Yes      | Primary business objective of the campaign.      |
| `start_date`         | DATE          | No       | Date the campaign began.                         |
| `end_date`           | DATE          | Yes      | Date the campaign ended or is scheduled to end.  |
| `budget`             | NUMERIC(12,2) | No       | Total allocated campaign budget.                 |
| `spend`              | NUMERIC(12,2) | No       | Actual campaign expenditure.                     |
| `impressions`        | INTEGER       | Yes      | Number of campaign impressions generated.        |
| `clicks`             | INTEGER       | Yes      | Number of campaign clicks generated.             |
| `conversions`        | INTEGER       | Yes      | Number of attributed campaign conversions.       |
| `created_at`         | TIMESTAMP     | No       | Record creation timestamp (UTC).                 |
| `updated_at`         | TIMESTAMP     | No       | Most recent record modification timestamp (UTC). |

---

## Constraints

| Constraint  | Description                                                                                            |
| ----------- | ------------------------------------------------------------------------------------------------------ |
| Primary Key | `campaign_id`                                                                                          |
| Check       | `end_date >= start_date` when an end date exists                                                       |
| Check       | `budget >= 0`                                                                                          |
| Check       | `spend >= 0`                                                                                           |
| Check       | `impressions >= 0` when populated                                                                      |
| Check       | `clicks >= 0` when populated                                                                           |
| Check       | `conversions >= 0` when populated                                                                      |
| NOT NULL    | `campaign_id`, `campaign_name`, `channel`, `start_date`, `budget`, `spend`, `created_at`, `updated_at` |

Logical validation rules such as `clicks <= impressions` and `conversions <= clicks` are evaluated during ETL processing.

---

## Indexes

| Index                                | Purpose                      |
| ------------------------------------ | ---------------------------- |
| `pk_marketing_campaigns`             | Primary key lookup           |
| `idx_marketing_campaigns_channel`    | Channel-based filtering      |
| `idx_marketing_campaigns_start_date` | Campaign timeline analysis   |
| `idx_marketing_campaigns_objective`  | Campaign objective filtering |

---

## Expected Volume

Approximately **500** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Low       |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

Campaign performance metrics may be updated throughout the campaign lifecycle.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing campaign objective values
* Inconsistent channel capitalization
* Invalid marketing channel values
* Duplicate campaign records
* Future-dated campaign periods
* Campaign spend exceeding budget
* Click counts exceeding impression counts
* Conversion counts exceeding click counts
* Missing performance metrics
* Leading and trailing whitespace in campaign names

These anomalies are introduced in controlled quantities and are expected to be identified and addressed during Silver layer transformations.

