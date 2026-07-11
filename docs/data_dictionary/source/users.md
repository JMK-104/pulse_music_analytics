# 8.1 users

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `users`                          |
| Schema          | `public`                         |
| Table Type      | Master Data                      |
| Business Domain | User Management                  |
| Primary Key     | `user_id`                        |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `users` table stores information about individuals registered on the Pulse Music platform.

Each record represents a unique user account and contains profile information, registration details, geographic information, subscription preferences, and audit timestamps.

The table serves as the parent entity for several transactional tables, including listening history, sessions, playlists, subscriptions, and payments.

---

## Relationships

| Relationship                      | Type        |
| --------------------------------- | ----------- |
| users → playlists                 | One-to-Many |
| users → sessions                  | One-to-Many |
| users → listening_history         | One-to-Many |
| users → podcast_listening_history | One-to-Many |
| users → user_subscriptions        | One-to-Many |

---

## Columns

| Column              | Data Type    | Nullable | Description                                      |
| ------------------- | ------------ | -------- | ------------------------------------------------ |
| `user_id`           | UUID         | No       | Unique identifier for each user.                 |
| `first_name`        | VARCHAR(100) | No       | User's first name.                               |
| `last_name`         | VARCHAR(100) | No       | User's last name.                                |
| `email`             | VARCHAR(255) | No       | User's email address.                            |
| `date_of_birth`     | DATE         | Yes      | User's date of birth.                            |
| `gender`            | VARCHAR(25)  | Yes      | Self-reported gender.                            |
| `country`           | VARCHAR(100) | Yes      | Country of residence.                            |
| `city`              | VARCHAR(100) | Yes      | City of residence.                               |
| `registration_date` | DATE         | No       | Date the account was created.                    |
| `is_active`         | BOOLEAN      | No       | Indicates whether the account is active.         |
| `created_at`        | TIMESTAMP    | No       | Record creation timestamp (UTC).                 |
| `updated_at`        | TIMESTAMP    | No       | Most recent record modification timestamp (UTC). |

---

## Constraints

| Constraint  | Description                                                                                                 |
| ----------- | ----------------------------------------------------------------------------------------------------------- |
| Primary Key | `user_id`                                                                                                   |
| Unique      | `email`                                                                                                     |
| NOT NULL    | `user_id`, `first_name`, `last_name`, `email`, `registration_date`, `is_active`, `created_at`, `updated_at` |

---

## Indexes

| Index                         | Purpose                        |
| ----------------------------- | ------------------------------ |
| `pk_users`                    | Primary key lookup             |
| `uq_users_email`              | Enforce unique email addresses |
| `idx_users_country`           | Geographic analysis            |
| `idx_users_registration_date` | Registration trend analysis    |

---

## Expected Volume

Approximately **50,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Moderate  |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing city values
* Inconsistent capitalization
* Leading and trailing whitespace
* Invalid country names
* Duplicate email addresses (limited test cases)
* Null gender values
* Future-dated `updated_at` timestamps in selected records

These anomalies are introduced in controlled quantities and are expected to be identified and addressed during Silver layer transformations.
