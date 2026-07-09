# Gold Layer Mapping

## Purpose

The Gold layer contains the enterprise analytics warehouse for the Pulse Music Analytics Platform.

Its purpose is to transform standardized operational data from the Silver layer into a dimensional model optimized for business intelligence, reporting, dashboarding, and analytical workloads.

Unlike the Silver layer, the Gold layer applies business logic, generates surrogate keys, manages historical dimensions, and loads the Galaxy Schema used by downstream consumers.

The Gold layer represents the single source of truth for analytical reporting.

---

# Gold Layer Design Principles

The Gold layer follows the following principles.

## Dimensional Modeling

Data is organized into conformed dimension tables and business process fact tables using a Galaxy Schema.

This design:

* Simplifies analytical queries.
* Improves reporting performance.
* Supports consistent business metrics.
* Enables cross-functional analysis.

---

## Surrogate Keys

All dimension tables use warehouse-generated surrogate keys.

Business identifiers from the operational system are retained as alternate keys but are never used to join fact tables.

Benefits include:

* Stable warehouse relationships
* Historical tracking
* Support for Slowly Changing Dimensions
* Improved query performance

---

## Historical Accuracy

Historical reporting is preserved through Slowly Changing Dimension (SCD Type 2) processing where applicable.

Currently:

| Dimension                | SCD Type |
| ------------------------ | -------- |
| dim_user                 | Type 2   |
| All remaining dimensions | Type 1   |

---

## Referential Integrity

Every fact record must reference valid dimension records.

Fact records with unresolved foreign key relationships are rejected and routed to exception handling for investigation.

---

# Gold Layer Architecture

The Gold layer consists of two primary object types.

## Dimension Tables

Dimension tables provide descriptive business context.

Current dimensions:

* dim_date
* dim_time
* dim_device
* dim_plan
* dim_source
* dim_payment_method
* dim_campaign
* dim_artist
* dim_album
* dim_song
* dim_playlist
* dim_podcast
* dim_episode
* dim_user

---

## Fact Tables

Fact tables record measurable business events.

Current facts:

* fact_listening
* fact_session
* fact_subscription_event
* fact_payment
* fact_campaign_performance
* fact_podcast_play

---

# Dimension Loading Strategy

Dimensions are loaded before fact tables to ensure all surrogate keys are available during fact loading.

The loading process for each dimension follows these steps:

1. Read standardized records from the Silver layer.
2. Identify new business keys.
3. Generate surrogate keys.
4. Apply Slowly Changing Dimension logic where applicable.
5. Insert new records.
6. Update existing records when required.
7. Validate uniqueness and referential integrity.

---

# Surrogate Key Generation

Each dimension receives a warehouse-generated surrogate key.

Example:

| Business ID | Surrogate Key |
| ----------- | ------------: |
| SONG001245  |         10425 |
| SONG001246  |         10426 |
| SONG001247  |         10427 |

Business identifiers remain available for traceability but are not used as foreign keys within the warehouse.

---

## Surrogate Key Lookup Process

During fact loading, business identifiers are replaced with warehouse surrogate keys.

Example:

```text
Silver Listening Record

user_id = U10245
song_id = SONG001245

        │
        ▼

Lookup:

dim_user.user_id

Lookup:

dim_song.song_id

        │
        ▼

Retrieve:

user_key = 2354

song_key = 10425

        │
        ▼

Insert into fact_listening
```

---

# Dimension Load Order

Dimensions are loaded according to dependency relationships.

| Load Order | Dimension          | Reason                                   |
| ---------- | ------------------ | ---------------------------------------- |
| 1          | dim_date           | Independent reference dimension          |
| 2          | dim_time           | Independent reference dimension          |
| 3          | dim_device         | Independent reference dimension          |
| 4          | dim_plan           | Independent reference dimension          |
| 5          | dim_source         | Independent reference dimension          |
| 6          | dim_payment_method | Independent reference dimension          |
| 7          | dim_campaign       | Independent business dimension           |
| 8          | dim_artist         | Required before albums and songs         |
| 9          | dim_album          | Depends on dim_artist                    |
| 10         | dim_song           | Depends on dim_artist and dim_album      |
| 11         | dim_playlist       | Independent content dimension            |
| 12         | dim_podcast        | Required before episodes                 |
| 13         | dim_episode        | Depends on dim_podcast                   |
| 14         | dim_user           | Loaded last due to SCD Type 2 processing |

---

# Fact Load Order

Fact tables are loaded after all dimensions have successfully completed.

Recommended execution order:

| Load Order | Fact Table                | Reason                   |
| ---------- | ------------------------- | ------------------------ |
| 1          | fact_listening            | Primary business process |
| 2          | fact_session              | User activity analysis   |
| 3          | fact_subscription_event   | Subscription lifecycle   |
| 4          | fact_payment              | Revenue analysis         |
| 5          | fact_campaign_performance | Marketing analytics      |
| 6          | fact_podcast_play         | Podcast engagement       |

---

# Dimension Mapping (Silver → Gold)

| Silver Table               | Gold Dimension |
| -------------------------- | -------------- |
| silver.users               | dim_user       |
| silver.artists             | dim_artist     |
| silver.albums              | dim_album      |
| silver.songs               | dim_song       |
| silver.playlists           | dim_playlist   |
| silver.podcasts            | dim_podcast    |
| silver.podcast_episodes    | dim_episode    |
| silver.marketing_campaigns | dim_campaign   |

Reference dimensions (`dim_date`, `dim_time`, `dim_device`, `dim_plan`, `dim_source`, and `dim_payment_method`) are populated from standardized lookup values maintained within the ETL process or derived from validated Silver-layer data, depending on the dimension.

---

# Fact Mapping (Silver → Gold)

| Silver Table                     | Gold Fact Table           |
| -------------------------------- | ------------------------- |
| silver.listening_history         | fact_listening            |
| silver.sessions                  | fact_session              |
| silver.user_subscriptions        | fact_subscription_event   |
| silver.payments                  | fact_payment              |
| silver.marketing_campaigns       | fact_campaign_performance |
| silver.podcast_listening_history | fact_podcast_play         |

During loading, all business identifiers are replaced with their corresponding surrogate keys.

---

# Slowly Changing Dimension Processing

Only `dim_user` implements Slowly Changing Dimension Type 2 (SCD Type 2).

Tracked attributes include:

* Country
* City
* Gender
* Age Group

When a tracked attribute changes:

1. The current record is expired.
2. The `effective_end_date` is populated.
3. A new record is inserted with a new surrogate key.
4. The new record becomes the current version.

This approach preserves historical accuracy for all downstream fact tables.

---

# Post-Load Validation

Following each Gold layer load, validation checks are performed.

| Validation                               | Expected Result |
| ---------------------------------------- | --------------- |
| All surrogate keys generated             | Pass            |
| No duplicate business keys in dimensions | Pass            |
| Referential integrity satisfied          | Pass            |
| Fact records reference valid dimensions  | Pass            |
| SCD processing completed successfully    | Pass            |
| Record counts within expected thresholds | Pass            |

---

# Gold Layer Output

The Gold layer produces a fully populated Galaxy Schema that serves as the enterprise analytics warehouse.

The output of this stage is:

```text
Operational Source System
          │
          ▼
     Bronze Layer
          │
          ▼
      Silver Layer
          │
          ▼
       Gold Layer
          │
          ▼
Galaxy Schema Warehouse
          │
          ▼
Dashboards • Reports • Analytics
```

The Gold layer is the authoritative source for all analytical reporting and business intelligence within the Pulse Music Analytics Platform.
