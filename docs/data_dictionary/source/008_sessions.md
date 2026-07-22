# 8.8 sessions

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `sessions`                       |
| Schema          | `public`                         |
| Table Type      | Transaction Data                 |
| Business Domain | User Engagement                  |
| Primary Key     | `session_id`                     |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `sessions` table records application sessions generated when users interact with the Pulse Music platform.

Each record represents a distinct user session and captures when the session began and ended, the device used, and the user's location at the time of the session.

Session data supports analysis of user activity, engagement frequency, platform usage, and device behavior.

---

## Relationships

| Relationship     | Type        |
| ---------------- | ----------- |
| users → sessions | One-to-Many |

---

## Columns

| Column                    | Data Type    | Nullable | Description                                         |
| ------------------------- | ------------ | -------- | --------------------------------------------------- |
| `session_id`              | UUID         | No       | Unique identifier for each application session.     |
| `session_start_timestamp` | TIMESTAMP    | No       | Date and time the session began (UTC).              |
| `session_end_timestamp`   | TIMESTAMP    | Yes      | Date and time the session ended (UTC).              |
| `device_type`             | VARCHAR(50)  | Yes      | General category of device used during the session. |
| `operating_system`        | VARCHAR(100) | Yes      | Operating system used during the session.           |
| `country`                 | VARCHAR(100) | Yes      | Country from which the session originated.          |
| `user_id`                 | UUID         | No       | Identifier of the user associated with the session. |
| `created_at`              | TIMESTAMP    | No       | Record creation timestamp (UTC).                    |

---

## Constraints

| Constraint  | Description                                                                     |
| ----------- | ------------------------------------------------------------------------------- |
| Primary Key | `session_id`                                                                    |
| Foreign Key | `user_id` references `users.user_id`                                            |
| Check       | `session_end_timestamp >= session_start_timestamp` when an end timestamp exists |
| NOT NULL    | `session_id`, `user_id`, `session_start_timestamp`, `created_at`                |

A null `session_end_timestamp` may represent an active session or a session that ended without a recorded termination event.

---

## Indexes

| Index                          | Purpose                             |
| ------------------------------ | ----------------------------------- |
| `pk_sessions`                  | Primary key lookup                  |
| `idx_sessions_user_id`         | User activity lookup                |
| `idx_sessions_start_timestamp` | Time-based extraction and filtering |
| `idx_sessions_user_start`      | User session history lookup         |

---

## Expected Volume

Approximately **2,000,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Very High |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

Session records may initially be inserted without an end timestamp and subsequently updated when the session terminates.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing session end timestamps
* Missing device information
* Inconsistent device type capitalization
* Inconsistent operating system names
* Missing or invalid country values
* Duplicate session records in controlled test cases
* Future-dated session timestamps
* Session end timestamps preceding start timestamps in raw source extracts

Where database constraints prevent invalid chronological relationships from being stored directly, selected anomalies may be introduced during raw data extraction.

---

