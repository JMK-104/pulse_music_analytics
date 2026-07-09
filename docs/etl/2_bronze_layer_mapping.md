# Bronze Layer Mapping

## Purpose

The Bronze layer serves as the initial landing zone for data extracted from the Pulse Music operational source system.

Its primary purpose is to preserve raw source data in its original format while providing a reliable foundation for downstream transformations.

The Bronze layer prioritizes:

* Data preservation
* Source system traceability
* Historical retention
* Pipeline recovery
* Auditability

No business logic, aggregations, or analytical transformations are performed at this stage.

---

# Bronze Layer Design Principles

The Bronze layer follows these design principles:

## Raw Data Preservation

Source data is stored as received from the operational system.

Examples:

* Original column names are preserved.
* Original values are retained.
* No records are deleted during ingestion.
* Data corrections are performed only in later layers.

---

## Append-Only Loading

Bronze tables use an append-oriented loading strategy.

Each ingestion cycle creates new records rather than modifying historical records.

This enables:

* Historical reconstruction
* Pipeline replay
* Source data auditing
* Error investigation

---

## Audit Metadata

Every Bronze table includes additional metadata columns to track ingestion history.

Standard audit columns:

| Column              | Data Type   | Description                                                        |
| ------------------- | ----------- | ------------------------------------------------------------------ |
| ingestion_timestamp | TIMESTAMP   | Timestamp when the record entered the Bronze layer.                |
| source_system       | VARCHAR(50) | Identifies the originating system.                                 |
| batch_id            | VARCHAR(50) | Identifies the ingestion batch.                                    |
| record_hash         | VARCHAR(64) | Hash value used for change detection and duplicate identification. |
| ingestion_date      | DATE        | Date the record was loaded.                                        |

---

# Bronze Layer Naming Convention

Bronze tables follow the naming convention:

```sql
bronze.<source_table_name>
```

Example:

Operational source:

```text
Users
```

Bronze table:

```sql
bronze.users
```

---

# Source-to-Bronze Mapping

The following operational tables are ingested into the Bronze layer.

---

## User Domain

| Source Table       | Bronze Table              | Load Type   | Description                        |
| ------------------ | ------------------------- | ----------- | ---------------------------------- |
| Users              | bronze.users              | Incremental | Raw user profile data              |
| User_Subscriptions | bronze.user_subscriptions | Incremental | Raw subscription lifecycle records |

---

## Music Content Domain

| Source Table | Bronze Table     | Load Type   | Description              |
| ------------ | ---------------- | ----------- | ------------------------ |
| Artists      | bronze.artists   | Incremental | Raw artist metadata      |
| Albums       | bronze.albums    | Incremental | Raw album metadata       |
| Songs        | bronze.songs     | Incremental | Raw song catalog         |
| Playlists    | bronze.playlists | Incremental | Raw playlist information |

---

## Podcast Domain

| Source Table     | Bronze Table            | Load Type   | Description                  |
| ---------------- | ----------------------- | ----------- | ---------------------------- |
| Podcasts         | bronze.podcasts         | Incremental | Raw podcast show metadata    |
| Podcast_Episodes | bronze.podcast_episodes | Incremental | Raw podcast episode metadata |

---

## Activity Domain

| Source Table              | Bronze Table                     | Load Type   | Description                 |
| ------------------------- | -------------------------------- | ----------- | --------------------------- |
| Listening_History         | bronze.listening_history         | Incremental | Raw music playback events   |
| Podcast_Listening_History | bronze.podcast_listening_history | Incremental | Raw podcast playback events |
| Sessions                  | bronze.sessions                  | Incremental | Raw user session activity   |

---

## Financial Domain

| Source Table | Bronze Table    | Load Type   | Description              |
| ------------ | --------------- | ----------- | ------------------------ |
| Payments     | bronze.payments | Incremental | Raw payment transactions |

---

## Marketing Domain

| Source Table        | Bronze Table               | Load Type    | Description              |
| ------------------- | -------------------------- | ------------ | ------------------------ |
| Marketing_Campaigns | bronze.marketing_campaigns | Full Refresh | Raw campaign information |

---

# Bronze Loading Strategy

## Initial Load

During the initial warehouse deployment:

1. Full extraction is performed from all operational tables.
2. Data is loaded into corresponding Bronze tables.
3. Audit metadata is generated.
4. Record counts are validated against source systems.

Example:

```text
Operational Users Table

100,000 records

        ↓

bronze.users

100,000 records
```

---

## Incremental Loads

After initial ingestion, most tables use incremental loading.

Incremental extraction identifies new or modified records using:

* Updated timestamps
* Transaction identifiers
* Event timestamps
* Source system change tracking fields

Example:

```sql
WHERE updated_at > last_successful_load_timestamp
```

---

# Bronze Transformation Rules

The Bronze layer performs only technical transformations.

Allowed operations:

| Operation              | Purpose                     |
| ---------------------- | --------------------------- |
| Data type preservation | Maintain source structure   |
| Metadata addition      | Track ingestion history     |
| File validation        | Ensure source completeness  |
| Schema validation      | Detect structural changes   |
| Record hashing         | Support duplicate detection |

---

The following transformations are prohibited:

| Transformation           | Reason                                  |
| ------------------------ | --------------------------------------- |
| Removing duplicates      | Required for historical analysis        |
| Changing business values | Original source data must remain intact |
| Joining tables           | Relationships are created downstream    |
| Aggregations             | Analytical logic belongs in Gold        |
| Null replacement         | Business rules belong in Silver         |

---

# Bronze Data Quality Checks

The following validations occur during ingestion.

| Check                     | Description                                            |
| ------------------------- | ------------------------------------------------------ |
| Schema validation         | Confirms incoming data structure matches expectations. |
| Record count validation   | Compares source and Bronze row counts.                 |
| Duplicate detection       | Identifies repeated source records.                    |
| Null monitoring           | Tracks unexpected missing values in critical fields.   |
| Data freshness validation | Confirms data arrives within expected time windows.    |

---

# Error Handling

Records failing ingestion validation are not loaded into Bronze tables.

Instead, they are redirected to an error quarantine location.

Example:

```text
Source Data

      │

      ▼

Schema Validation

      │

 ┌────┴────┐
 │         │
Valid    Invalid

 │         │

 ▼         ▼

Bronze   Error Queue
```

---

Error records contain:

| Column            | Description                  |
| ----------------- | ---------------------------- |
| error_timestamp   | Time the error occurred      |
| source_table      | Originating source           |
| record_identifier | Source record ID             |
| error_type        | Validation failure category  |
| error_message     | Detailed failure explanation |

---

# Bronze Layer Load Frequency

| Domain              | Frequency |
| ------------------- | --------- |
| Listening Events    | Hourly    |
| Podcast Events      | Hourly    |
| Sessions            | Hourly    |
| Payments            | Daily     |
| Subscription Events | Daily     |
| User Profiles       | Daily     |
| Content Metadata    | Daily     |
| Marketing Data      | Daily     |

---

# Bronze Layer Output

The Bronze layer provides a complete, auditable copy of operational data that serves as the source layer for Silver transformations.

The output of this stage is:

```text
Raw Operational Data

        ↓

bronze schema

        ↓

Silver Layer Processing
```

