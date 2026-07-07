# 6.1 Dimension Table — `dim_date`

## Business Purpose

The `dim_date` table is a conformed dimension that provides descriptive calendar attributes for every date represented in the analytics warehouse.

Rather than storing date components (month, quarter, weekday, etc.) repeatedly in fact tables, each fact references a single `date_key`. This enables consistent time-based analysis across all business processes.

This dimension is shared by all fact tables.

---

## Grain

**One row represents one calendar date.**

Example:

| date_key | full_date  |
| -------- | ---------- |
| 20250101 | 2025-01-01 |
| 20250102 | 2025-01-02 |
| 20250103 | 2025-01-03 |

---

## Source

Generated during warehouse initialization.

This table is **not** loaded from the operational database.

---

## Primary Key

`date_key`

---

## Referenced By

* fact_listening
* fact_session
* fact_subscription_event
* fact_payment
* fact_campaign_performance
* fact_podcast_play

---

## Column Definitions

| Column       | Data Type   | Nullable |  PK |  FK | Default   | Description                                        |
| ------------ | ----------- | :------: | :-: | :-: | --------- | -------------------------------------------------- |
| date_key     | INTEGER     |    No    |  ✓  |     | Generated | Surrogate key in YYYYMMDD format (e.g., 20250131). |
| full_date    | DATE        |    No    |     |     |           | Calendar date.                                     |
| day          | SMALLINT    |    No    |     |     |           | Day of month (1–31).                               |
| month        | SMALLINT    |    No    |     |     |           | Month number (1–12).                               |
| month_name   | VARCHAR(15) |    No    |     |     |           | January, February, etc.                            |
| quarter      | SMALLINT    |    No    |     |     |           | Quarter of year (1–4).                             |
| year         | SMALLINT    |    No    |     |     |           | Calendar year.                                     |
| week_of_year | SMALLINT    |    No    |     |     |           | ISO week number.                                   |
| day_of_week  | VARCHAR(15) |    No    |     |     |           | Monday through Sunday.                             |
| is_weekend   | BOOLEAN     |    No    |     |     | FALSE     | TRUE if Saturday or Sunday.                        |
| is_holiday   | BOOLEAN     |    No    |     |     | FALSE     | TRUE if designated as a public holiday.            |

---

## Business Rules

* Every calendar date must appear exactly once.
* `date_key` must uniquely identify each date.
* `quarter` is derived from the month.
* `week_of_year` follows the ISO-8601 standard.
* `is_weekend` is TRUE only for Saturdays and Sundays.
* `is_holiday` is determined during table generation and remains static unless the calendar is regenerated.

---

## Data Quality Rules

| Rule                                             | Expected Result |
| ------------------------------------------------ | --------------- |
| No duplicate date_key values                     | Pass            |
| No duplicate full_date values                    | Pass            |
| Every month between project start and end exists | Pass            |
| Every date has a valid weekday                   | Pass            |
| Quarter matches month                            | Pass            |

---

## Estimated Size

Approximately **731 rows**, covering January 1, 2024 through December 31, 2025.
