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

