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
| `episode_title`    | VARCHAR(255) | No       | Display title of the episode.                                       |
| `release_date`     | DATE         | No       | Date on which the episode was published.                            |
| `duration_seconds` | INTEGER      | No       | Total episode duration in seconds.                                  |
| `episode_number`   | INTEGER      | Yes      | Episode sequence number where provided by the publisher.            |
| `is_explicit`      | BOOLEAN      | No       | Indicates whether the episode contains explicit content.            |
| `podcast_id`       | UUID         | No       | Identifier of the podcast to which the episode belongs.             |
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

