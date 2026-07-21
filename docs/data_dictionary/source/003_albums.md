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

