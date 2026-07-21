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

