# 8.11 user_subscriptions

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `user_subscriptions`             |
| Schema          | `public`                         |
| Table Type      | Transaction Data                 |
| Business Domain | User Management                  |
| Primary Key     | `subscription_id`                |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `user_subscriptions` table records the subscription lifecycle of Pulse Music users.

Each record represents a distinct subscription period and captures the user, subscription plan, billing cycle, subscription status, start date, and termination or renewal information.

A user may have multiple subscription records over time as they subscribe, cancel, renew, or change plans.

---

## Relationships

| Relationship                  | Type        |
| ----------------------------- | ----------- |
| users → user_subscriptions    | One-to-Many |
| user_subscriptions → payments | One-to-Many |

---

## Columns

| Column                | Data Type    | Nullable | Description                                                |
| --------------------- | ------------ | -------- | ---------------------------------------------------------- |
| `subscription_id`     | UUID         | No       | Unique identifier for each subscription record.            |
| `user_id`             | UUID         | No       | Identifier of the subscribed user.                         |
| `plan_name`           | VARCHAR(100) | No       | Name of the subscription plan.                             |
| `billing_cycle`       | VARCHAR(50)  | No       | Billing frequency, such as Monthly or Annual.              |
| `subscription_status` | VARCHAR(50)  | No       | Current status of the subscription record.                 |
| `start_date`          | DATE         | No       | Date the subscription period began.                        |
| `end_date`            | DATE         | Yes      | Date the subscription period ended or is scheduled to end. |
| `auto_renew`          | BOOLEAN      | No       | Indicates whether automatic renewal is enabled.            |
| `created_at`          | TIMESTAMP    | No       | Record creation timestamp (UTC).                           |
| `updated_at`          | TIMESTAMP    | No       | Most recent record modification timestamp (UTC).           |

---

## Constraints

| Constraint  | Description                                                                                                                               |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Primary Key | `subscription_id`                                                                                                                         |
| Foreign Key | `user_id` references `users.user_id`                                                                                                      |
| Check       | `end_date >= start_date` when an end date exists                                                                                          |
| NOT NULL    | `subscription_id`, `user_id`, `plan_name`, `billing_cycle`, `subscription_status`, `start_date`, `auto_renew`, `created_at`, `updated_at` |

---

## Indexes

| Index                                | Purpose                          |
| ------------------------------------ | -------------------------------- |
| `pk_user_subscriptions`              | Primary key lookup               |
| `idx_user_subscriptions_user_id`     | User subscription history lookup |
| `idx_user_subscriptions_status`      | Subscription status filtering    |
| `idx_user_subscriptions_start_date`  | Subscription trend analysis      |
| `idx_user_subscriptions_user_status` | Active subscription lookup       |

---

## Expected Volume

Approximately **120,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Moderate  |
| UPDATE    | Moderate  |
| DELETE    | Rare      |

Subscription records may be updated as lifecycle events occur.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Inconsistent plan name capitalization
* Invalid plan names in limited test cases
* Inconsistent billing cycle values
* Invalid subscription status values
* Missing end dates for terminated subscriptions
* Contradictory status and auto-renew combinations
* Overlapping subscription periods for selected users
* Duplicate subscription records
* Future-dated subscription events

Cross-record lifecycle anomalies, such as overlapping subscription periods, are validated during ETL processing.

---

