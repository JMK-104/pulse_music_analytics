# Silver Layer Mapping

## Purpose

The Silver layer transforms raw operational data into standardized, validated, and trusted datasets suitable for dimensional modeling.

Unlike the Bronze layer, which preserves source data without modification, the Silver layer is responsible for improving data quality while maintaining the original business meaning of each record.

The Silver layer serves as the authoritative source for loading the Gold Layer dimensional warehouse.

---

# Silver Layer Design Principles

The Silver layer follows these core design principles.

## Data Standardization

Data is standardized to ensure consistent formatting across all business domains.

Typical standardization includes:

* Consistent text casing
* Standardized date and timestamp formats
* Uniform categorical values
* Consistent Boolean representations
* Trimmed whitespace

---

## Data Validation

Business rules are enforced before data progresses to the Gold layer.

Records failing critical validation rules are quarantined for review rather than loaded into downstream tables.

---

## Data Cleansing

Known data quality issues are corrected whenever possible.

Examples include:

* Removing duplicate records
* Correcting formatting inconsistencies
* Replacing invalid placeholder values
* Resolving inconsistent category names

---

## Business Integrity

The Silver layer preserves the meaning of business events.

No aggregations or dimensional modeling occur in this layer.

Each cleaned record continues to represent the same business event as its Bronze counterpart.

---

# Silver Layer Naming Convention

Silver tables follow the naming convention:

```sql
silver.<business_entity>
```

Example:

```text
bronze.listening_history
```

↓

```sql
silver.listening_history
```

---

# Bronze-to-Silver Mapping

| Bronze Table                     | Silver Table                     | Description                       |
| -------------------------------- | -------------------------------- | --------------------------------- |
| bronze.users                     | silver.users                     | Standardized user profiles        |
| bronze.user_subscriptions        | silver.user_subscriptions        | Cleaned subscription events       |
| bronze.artists                   | silver.artists                   | Standardized artist metadata      |
| bronze.albums                    | silver.albums                    | Standardized album metadata       |
| bronze.songs                     | silver.songs                     | Cleaned music catalog             |
| bronze.playlists                 | silver.playlists                 | Standardized playlists            |
| bronze.podcasts                  | silver.podcasts                  | Cleaned podcast metadata          |
| bronze.podcast_episodes          | silver.podcast_episodes          | Standardized episode metadata     |
| bronze.listening_history         | silver.listening_history         | Validated playback events         |
| bronze.podcast_listening_history | silver.podcast_listening_history | Validated podcast playback events |
| bronze.sessions                  | silver.sessions                  | Standardized session records      |
| bronze.payments                  | silver.payments                  | Validated payment transactions    |
| bronze.marketing_campaigns       | silver.marketing_campaigns       | Standardized campaign data        |

---

# Standard Data Cleansing Rules

The following cleansing rules are applied across all Silver tables where applicable.

| Rule                             | Example                               |
| -------------------------------- | ------------------------------------- |
| Trim leading/trailing whitespace | `" Premium "` → `"Premium"`           |
| Collapse multiple spaces         | `"Taylor   Swift"` → `"Taylor Swift"` |
| Standardize text casing          | `"premium"` → `"Premium"`             |
| Convert empty strings to NULL    | `""` → `NULL`                         |
| Normalize Boolean values         | `"Yes"`, `"Y"`, `"1"` → `TRUE`        |
| Standardize timestamps to UTC    | Local timestamps → UTC                |
| Remove non-printable characters  | Hidden control characters removed     |

---

# Duplicate Handling

Duplicate detection is performed using business keys rather than surrogate keys.

General process:

1. Identify duplicate business records.
2. Retain the most recent valid record.
3. Archive discarded duplicates for auditing.

Example:

| user_id | updated_at       | Action  |
| ------- | ---------------- | ------- |
| U1024   | 2026-05-01 09:15 | Discard |
| U1024   | 2026-05-03 14:20 | Retain  |

Duplicate handling varies by entity:

| Entity            | Business Key |
| ----------------- | ------------ |
| Users             | user_id      |
| Songs             | song_id      |
| Artists           | artist_id    |
| Albums            | album_id     |
| Playlists         | playlist_id  |
| Podcast Episodes  | episode_id   |
| Payments          | payment_id   |
| Listening History | playback_id  |

---

# Missing Data Handling

Missing values are handled according to business rules.

| Scenario                      | Action                              |
| ----------------------------- | ----------------------------------- |
| Optional attribute            | Leave as NULL                       |
| Required attribute missing    | Reject record                       |
| Missing categorical value     | Assign "Unknown" where appropriate  |
| Missing timestamp             | Reject record                       |
| Missing foreign key reference | Route to exception handling process |

Examples:

| Field          | Handling                         |
| -------------- | -------------------------------- |
| Album          | Nullable (singles are permitted) |
| Playlist       | Nullable                         |
| Payment Method | Required                         |
| User ID        | Required                         |
| Song ID        | Required                         |

---

# Domain Standardization

Business values are standardized before loading the Gold layer.

### Subscription Plans

| Incoming Value | Standardized Value |
| -------------- | ------------------ |
| premium        | Premium            |
| PREMIUM        | Premium            |
| Premium Plan   | Premium            |

---

### Playback Source

| Incoming Value | Standardized Value |
| -------------- | ------------------ |
| Search Bar     | Search             |
| Song Search    | Search             |
| Manual Search  | Search             |

---

### Device Type

| Incoming Value | Standardized Value |
| -------------- | ------------------ |
| Android Phone  | Smartphone         |
| Samsung Galaxy | Smartphone         |
| iPhone         | Smartphone         |

---

### Country Names

Country names are standardized using ISO-3166 naming conventions.

Example:

| Incoming Value | Standardized Value |
| -------------- | ------------------ |
| USA            | United States      |
| U.S.A.         | United States      |
| US             | United States      |

---

# Business Rule Validation

The following business validations are performed before Gold loading.

| Validation                                 | Action if Failed |
| ------------------------------------------ | ---------------- |
| Playback duration exceeds content duration | Reject record    |
| Payment amount is negative                 | Reject record    |
| Clicks exceed impressions                  | Reject record    |
| Conversions exceed clicks                  | Reject record    |
| Release year is in the future              | Reject record    |
| Session duration is negative               | Reject record    |
| Subscription event is invalid              | Reject record    |

---

# Derived Attributes

Several attributes are derived during Silver processing.

Examples include:

| Derived Attribute        | Logic                                   |
| ------------------------ | --------------------------------------- |
| age_group                | Derived from birth_year                 |
| session_length_minutes   | session_duration_seconds ÷ 60           |
| explicit_flag            | Derived from explicit content indicator |
| release_decade           | Derived from release_year               |
| playback_completion_rate | seconds_played ÷ content duration       |

Derived attributes improve analytical usability while avoiding repeated calculations in reporting tools.

---

# Exception Handling

Records failing business validation are redirected to exception tables for investigation.

Naming convention:

```sql
silver.exceptions_<table_name>
```

Example:

```sql
silver.exceptions_payments
```

Exception records include:

| Column              | Description                         |
| ------------------- | ----------------------------------- |
| exception_timestamp | Date and time the validation failed |
| source_table        | Originating Bronze table            |
| business_key        | Business identifier                 |
| validation_rule     | Rule violated                       |
| exception_reason    | Detailed explanation                |

---

# Silver Layer Quality Checks

Before data is promoted to the Gold layer, the following validations are performed.

| Check                               | Expected Result                        |
| ----------------------------------- | -------------------------------------- |
| Duplicate business keys             | None                                   |
| Invalid categorical values          | None                                   |
| Required fields populated           | 100%                                   |
| Referential integrity prerequisites | Satisfied                              |
| Timestamp format consistency        | Valid                                  |
| Numeric ranges                      | Within expected business limits        |
| Record counts                       | Within acceptable variance from Bronze |

---

# Silver Layer Output

The Silver layer produces standardized datasets that are suitable for dimensional modeling.

The output of this stage is:

```text
Raw Operational Data
        │
        ▼
Bronze Layer
        │
        ▼
Cleaned & Standardized Data
        │
        ▼
Silver Layer
        │
        ▼
Gold Layer Processing
```

The Silver layer represents the trusted operational dataset from which all dimension and fact tables are populated.
