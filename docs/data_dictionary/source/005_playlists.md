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
| `playlist_name`        | VARCHAR(255) | No       | Display name of the playlist.                                                               |
| `playlist_description` | TEXT         | Yes      | Optional description of the playlist.                                                       |
| `playlist_type`        | VARCHAR(50)  | No       | Classification such as User, Editorial, or Algorithmic.                                     |
| `user_id`              | UUID         | Yes      | Identifier of the user who owns the playlist. Null for selected platform-managed playlists. |
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

