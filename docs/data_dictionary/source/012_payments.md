# 8.12 payments

## Table Overview

| Property        | Value                            |
| --------------- | -------------------------------- |
| Table Name      | `payments`                       |
| Schema          | `public`                         |
| Table Type      | Transaction Data                 |
| Business Domain | Commerce                         |
| Primary Key     | `payment_id`                     |
| Source System   | Pulse Music Operational Database |

---

## Business Purpose

The `payments` table records financial transactions associated with Pulse Music subscriptions.

Each record represents an individual payment attempt and captures the related subscription, user, transaction amount, currency, payment method, transaction status, and processing timestamp.

The table supports revenue, payment success, payment failure, and subscription monetization analysis.

---

## Relationships

| Relationship                  | Type        |
| ----------------------------- | ----------- |
| user_subscriptions → payments | One-to-Many |
| users → payments              | One-to-Many |

The direct user reference supports operational lookup and auditing while the subscription reference identifies the subscription associated with the transaction.

---

## Columns

| Column              | Data Type     | Nullable | Description                                                 |
| ------------------- | ------------- | -------- | ----------------------------------------------------------- |
| `payment_id`        | UUID          | No       | Unique identifier for each payment transaction.             |
| `subscription_id`   | UUID          | No       | Identifier of the subscription associated with the payment. |
| `user_id`           | UUID          | No       | Identifier of the user associated with the payment.         |
| `payment_timestamp` | TIMESTAMP     | No       | Date and time the payment was processed (UTC).              |
| `amount`            | NUMERIC(10,2) | No       | Monetary value of the transaction.                          |
| `currency`          | VARCHAR(3)    | No       | Three-character transaction currency code.                  |
| `payment_method`    | VARCHAR(50)   | Yes      | Payment method used for the transaction.                    |
| `payment_status`    | VARCHAR(50)   | No       | Outcome or current status of the payment transaction.       |
| `created_at`        | TIMESTAMP     | No       | Record creation timestamp (UTC).                            |

---

## Constraints

| Constraint  | Description                                                                                                           |
| ----------- | --------------------------------------------------------------------------------------------------------------------- |
| Primary Key | `payment_id`                                                                                                          |
| Foreign Key | `subscription_id` references `user_subscriptions.subscription_id`                                                     |
| Foreign Key | `user_id` references `users.user_id`                                                                                  |
| Check       | `amount >= 0`                                                                                                         |
| NOT NULL    | `payment_id`, `subscription_id`, `user_id`, `payment_timestamp`, `amount`, `currency`, `payment_status`, `created_at` |

Cross-table validation ensures that the `user_id` associated with a payment matches the user associated with the referenced subscription.

---

## Indexes

| Index                          | Purpose                                         |
| ------------------------------ | ----------------------------------------------- |
| `pk_payments`                  | Primary key lookup                              |
| `idx_payments_subscription_id` | Subscription payment lookup                     |
| `idx_payments_user_id`         | User payment history lookup                     |
| `idx_payments_timestamp`       | Incremental extraction and time-based filtering |
| `idx_payments_status`          | Payment outcome filtering                       |

---

## Expected Volume

Approximately **450,000** records.

---

## Update Characteristics

| Operation | Frequency |
| --------- | --------- |
| INSERT    | Moderate  |
| UPDATE    | Low       |
| DELETE    | Rare      |

Payment records are generally treated as immutable financial events after their final status is established.

---

## Data Quality Notes

The synthetic dataset intentionally includes selected data quality issues to support ETL development and validation.

Examples include:

* Missing payment method values
* Inconsistent payment method capitalization
* Invalid currency codes
* Inconsistent payment status values
* Zero-value transactions
* Duplicate payment records
* Future-dated payment timestamps
* Payment timestamps occurring before the associated subscription start date
* User identifiers that do not match the referenced subscription in controlled test cases

Where operational constraints prevent selected anomalies, they may be introduced during raw source extraction.

---
