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

