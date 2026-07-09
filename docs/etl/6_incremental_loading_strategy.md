# Incremental Loading Strategy

## Purpose

The Incremental Loading Strategy defines how the Pulse Music Analytics Platform identifies, extracts, and processes only new or modified data during subsequent ETL executions.

Rather than reloading the entire warehouse on each pipeline run, incremental loading minimizes processing time, reduces resource consumption, and enables timely updates while preserving historical accuracy.

This strategy supports efficient warehouse maintenance as operational data volumes continue to grow.

---

# Incremental Loading Principles

The ETL pipelines follow these core principles.

## Process Only Changed Data

Each pipeline execution processes only records that have been created or modified since the previous successful load.

This reduces:

* Processing time
* Database load
* Network traffic
* Storage consumption

---

## Preserve Historical Records

Existing analytical history is never overwritten.

Instead:

* New business events are inserted.
* Historical dimension records are preserved where required.
* Fact tables remain append-only.

---

## Idempotent Processing

ETL processes are designed to be idempotent.

Running the same incremental load multiple times with identical source data produces the same warehouse state without introducing duplicate records.

---

## Restartability

If an ETL execution fails, processing resumes from the last successfully completed checkpoint rather than restarting the entire pipeline.

---

# Change Detection Strategy

Source systems expose timestamp columns used to identify new and modified records.

Typical source columns include:

| Source Table              | Change Detection Column |
| ------------------------- | ----------------------- |
| Users                     | updated_at              |
| Songs                     | updated_at              |
| Artists                   | updated_at              |
| Albums                    | updated_at              |
| Playlists                 | updated_at              |
| Podcasts                  | updated_at              |
| Podcast_Episodes          | updated_at              |
| Listening_History         | playback_timestamp      |
| Podcast_Listening_History | playback_timestamp      |
| Sessions                  | session_start_timestamp |
| Payments                  | payment_timestamp       |
| User_Subscriptions        | event_timestamp         |
| Marketing_Campaigns       | updated_at              |

Each ETL execution retrieves records whose change timestamp is greater than the previous successful load watermark.

---

# Watermark Management

The ETL process maintains a high-watermark for each source table.

The watermark represents the latest successfully processed timestamp.

Example:

| Table             | Last Watermark      |
| ----------------- | ------------------- |
| Users             | 2026-07-08 23:58:42 |
| Listening_History | 2026-07-08 23:59:59 |
| Payments          | 2026-07-08 21:30:17 |

Incremental extraction uses the watermark to identify eligible records.

Example query:

```sql
SELECT *
FROM Users
WHERE updated_at > :last_successful_watermark;
```

After a successful load, the watermark is updated to the latest processed timestamp.

---

# Dimension Incremental Loading

Dimension tables process new and modified business entities.

General workflow:

1. Extract changed records from the Silver layer.
2. Compare business keys against existing dimensions.
3. Insert new business entities.
4. Update existing records according to SCD rules.
5. Generate surrogate keys for new records.

Example:

```text
Silver Users

        │

Compare Business Key

        │

 ┌──────┴──────┐
 │             │
New         Existing

 │             │

 ▼             ▼

Insert      Compare Attributes

                │

          Changed?

           │     │

          No    Yes

           │     │

           ▼     ▼

        Ignore   Apply SCD Type 2
```

---

# Fact Incremental Loading

Fact tables are append-only.

Each new business event generates exactly one new fact record.

Examples include:

* Song playback
* Podcast playback
* Payment transaction
* Session
* Subscription event

Historical fact records are never updated unless correcting a verified operational error.

---

# Slowly Changing Dimension Processing

`dim_user` implements Slowly Changing Dimension Type 2.

When tracked attributes change:

* Existing record is expired.
* Effective end date is populated.
* Current flag is set to FALSE.
* New surrogate key is generated.
* Updated record is inserted.

This preserves historical reporting accuracy.

All remaining dimensions use SCD Type 1.

---

# Late-Arriving Data

Operational systems occasionally deliver records after their expected processing window.

Examples include:

* Delayed payment notifications
* Offline listening synchronization
* Mobile device connectivity issues

Late-arriving records are processed using their original business timestamps rather than their arrival time.

This ensures historical reporting remains accurate.

---

# Duplicate Prevention

Incremental loading includes duplicate detection before inserting records.

Duplicate checks use:

| Object           | Matching Key              |
| ---------------- | ------------------------- |
| Dimensions       | Business Key              |
| Fact Tables      | Business Event Identifier |
| Payments         | Payment ID                |
| Listening Events | Playback ID               |
| Sessions         | Session ID                |

Duplicate records are skipped and logged for audit purposes.

---

# Incremental Load Validation

Each incremental load is validated before being committed.

Validation includes:

| Validation                             | Expected Result |
| -------------------------------------- | --------------- |
| Watermark advanced                     | Yes             |
| Duplicate records inserted             | No              |
| Referential integrity maintained       | Yes             |
| Surrogate keys resolved                | Yes             |
| SCD processing completed               | Yes             |
| Record counts within expected variance | Yes             |

---

# Incremental Load Recovery

If an incremental load fails:

1. The current transaction is rolled back.
2. The previous watermark remains unchanged.
3. Failed records are logged.
4. The next execution resumes from the previous successful watermark.

This prevents data loss and duplicate processing.

---

# Incremental Loading Summary

The Incremental Loading Strategy enables the Pulse Music Analytics Platform to efficiently process continuously growing operational datasets while maintaining historical accuracy and analytical consistency.

By combining timestamp-based change detection, watermark management, append-only fact loading, and SCD Type 2 processing, the ETL pipeline minimizes unnecessary processing and provides a scalable foundation for long-term warehouse operation.
