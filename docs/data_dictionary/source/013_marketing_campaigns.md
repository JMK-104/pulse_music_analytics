# 8.13 marketing_campaigns

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `marketing_campaigns`            |
| Schema          | `public`                         |
| Table Type      | Configuration Data               |
| Business Domain | Marketing                        |
| Primary Key     | `campaign_id`                    |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `marketing_campaigns` table stores information about marketing campaigns conducted to acquire, engage, or retain Pulse Music users.

Each record represents a campaign and captures its channel, objective, schedule, budget, and high-level performance metrics.

The table provides the source data required for marketing performance, acquisition efficiency, and return-on-investment analysis.

---

## Relationships

The `marketing_campaigns` table is independent within the current operational model and does not enforce direct foreign key relationships with other source tables.

Campaign attribution and analytical relationships are established during downstream warehouse transformations where applicable.

---

## Columns

| Column               | Data Type     | Nullable | Description                                      |
| -------------------- | ------------- | -------- | ------------------------------------------------ |
| `campaign_id`        | UUID          | No       | Unique identifier for each marketing campaign.   |
| `campaign_name`      | VARCHAR(255)  | No       | Business name of the campaign.                   |
| `channel`            | VARCHAR(100)  | No       | Marketing channel used to deliver the campaign.  |
| `campaign_objective` | VARCHAR(100)  | Yes      | Primary business objective of the campaign.      |
| `start_date`         | DATE          | No       | Date the campaign began.                         |
| `end_date`           | DATE          | Yes      | Date the campaign ended or is scheduled to end.  |
| `budget`             | NUMERIC(12,2) | No       | Total allocated campaign budget.                 |
| `spend`              | NUMERIC(12,2) | No       | Actual campaign expenditure.                     |
| `impressions`        | INTEGER       | Yes      | Number of campaign impressions generated.        |
| `clicks`             | INTEGER       | Yes      | Number of campaign clicks generated.             |
| `conversions`        | INTEGER       | Yes      | Number of attributed campaign conversions.       |
| `created_at`         | TIMESTAMP     | No       | Record creation timestamp (UTC).                 |
| `updated_at`         | TIMESTAMP     | No       | Most recent record modification timestamp (UTC). |

---

## Constraints

| Constraint  | Description                                                                                            |
| ----------- | ------------------------------------------------------------------------------------------------------ |
| Primary Key | `campaign_id`                                                                                          |
| Check       | `end_date >= start_date` when an end date exists                                                       |
| Check       | `budget >= 0`                                                                                          |
| Check       | `spend >= 0`                                                                                           |
| Check       | `impressions >= 0` when populated                                                                      |
| Check       | `clicks >= 0` when populated                                                                           |
| Check       | `conversions >= 0` when populated                                                                      |
| NOT NULL    | `campaign_id`, `campaign_name`, `channel`, `start_date`, `budget`, `spend`, `created_at`, `updated_at` |

Logical validation rules such as `clicks <= impressions` and `conversions <= clicks` are evaluated during ETL processing.

---

## Indexes

| Index                                | Purpose                      |
| ------------------------------------ | ---------------------------- |
| `pk_marketing_campaigns`             | Primary key lookup           |
| `idx_marketing_campaigns_channel`    | Channel-based filtering      |
| `idx_marketing_campaigns_start_date` | Campaign timeline analysis   |
| `idx_marketing_campaigns_objective`  | Campaign objective filtering |

---

## Expected Volume

Approximately **500** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Low       |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

Campaign performance metrics may be updated throughout the campaign lifecycle.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing campaign objective values
* Inconsistent channel capitalization
* Invalid marketing channel values
* Duplicate campaign records
* Future-dated campaign periods
* Campaign spend exceeding budget
* Click counts exceeding impression counts
* Conversion counts exceeding click counts
* Missing performance metrics
* Leading and trailing whitespace in campaign names

These anomalies are introduced in controlled quantities and are expected to be identified and addressed during Silver layer transformations.

