# 6.2 Dimension Table — `dim_time`

## Business Purpose

The `dim_time` table provides a standardized representation of time throughout the day. It enables analysis of listening, sessions, and podcast activity by hour, minute, or part of day without repeatedly calculating these values during reporting.

---

## Grain

**One row represents one minute of the day.**

Example:

| time_key | time  |
| -------- | ----- |
| 0000     | 00:00 |
| 0001     | 00:01 |
| 1435     | 14:35 |
| 2359     | 23:59 |

---

## Source

Generated during warehouse initialization.

This table is **not** loaded from the operational database.

---

## Primary Key

`time_key`

---

## Referenced By

* fact_listening
* fact_session
* fact_podcast_play

---

## Column Definitions

| Column      | Data Type   | Nullable |  PK |  FK | Default   | Description                            |
| ----------- | ----------- | :------: | :-: | :-: | --------- | -------------------------------------- |
| time_key    | INTEGER     |    No    |  ✓  |     | Generated | Surrogate key in HHMM format.          |
| time        | TIME        |    No    |     |     |           | Time represented by the row.           |
| hour        | SMALLINT    |    No    |     |     |           | Hour of day (0–23).                    |
| minute      | SMALLINT    |    No    |     |     |           | Minute of hour (0–59).                 |
| part_of_day | VARCHAR(20) |    No    |     |     | Derived   | Morning, Afternoon, Evening, or Night. |

---

## Business Rules

Part of day is defined as:

| Time Range  | Value     |
| ----------- | --------- |
| 05:00–11:59 | Morning   |
| 12:00–16:59 | Afternoon |
| 17:00–20:59 | Evening   |
| 21:00–04:59 | Night     |

---

## Data Quality Rules

| Rule                         | Expected Result |
| ---------------------------- | --------------- |
| Exactly 1,440 rows           | Pass            |
| No duplicate time_key values | Pass            |
| Every minute represented     | Pass            |
| Valid hour and minute values | Pass            |

---

## Estimated Size

Exactly **1,440 rows**.
