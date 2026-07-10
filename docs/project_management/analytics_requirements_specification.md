# Analytics Requirements Specification (ARS)

**Scope:** Core Business KPIs

**System:** Pulse Analytics Warehouse

---

# Purpose

This document defines the standardized business metrics used across the Pulse Analytics platform.

Its goal is to ensure that all teams (Executive, Product, Marketing, Finance, Content) use consistent definitions when analyzing performance.

All downstream dashboards, SQL queries, and transformation logic must adhere strictly to these definitions.

---

# General Conventions

## Time Handling

* All timestamps are stored in **UTC**
* Business reporting uses:

  * Daily aggregation: calendar day (00:00–23:59 UTC)
  * Monthly aggregation: calendar month

---

## User Definitions

* **Active User:** A user with at least one recorded listening event in a given period.
* **New User:** A user whose signup_date falls within the reporting period.
* **Returning User:** An active user who signed up before the reporting period.

---

## Subscription Definitions

* A user is considered **Premium Active** if:

  * status = 'active'
  * plan ≠ 'Free'
  * no cancellation date before the reporting period

---

# Growth Metrics

---

## Daily Active Users (DAU)

**Definition:**
Number of unique users who have at least one listening event on a given day.

**Formula:**

```
DAU = COUNT(DISTINCT user_id)
FROM listening_history
WHERE DATE(timestamp) = selected_day
```

**Exclusions:**

* Test users (if present)
* Invalid user IDs (null or corrupted foreign keys)

---

## Monthly Active Users (MAU)

**Definition:**
Number of unique users with at least one listening event in a calendar month.

**Formula:**

```
MAU = COUNT(DISTINCT user_id)
FROM listening_history
WHERE month(timestamp) = selected_month
```

---

## New Users

**Definition:**
Users whose signup_date falls within the reporting period.

**Formula:**

```
COUNT(user_id)
FROM users
WHERE signup_date BETWEEN start_date AND end_date
```

---

## User Growth Rate

**Definition:**
Percentage change in MAU compared to previous month.

```
(MAU_current - MAU_previous) / MAU_previous * 100
```

---

# Engagement Metrics

---

## Total Listening Time

**Definition:**
Sum of seconds_played across all listening events.

```
SUM(seconds_played) / 3600 = Listening Hours
```

---

## Average Session Duration

**Definition:**
Average time between login_time and logout_time per session.

```
AVG(logout_time - login_time)
```

**Exclusions:**

* Sessions with negative duration
* Sessions longer than 12 hours (flagged as anomalies)

---

## Songs per Session

```
COUNT(listening events) / COUNT(sessions)
```

---

## Skip Rate

**Definition:**
Percentage of tracks where skipped = TRUE.

```
SUM(skipped = TRUE) / TOTAL plays
```

---

## Completion Rate

**Definition:**
Percentage of tracks where completed = TRUE.

```
SUM(completed = TRUE) / TOTAL plays
```

---

# Subscription Metrics

---

## Active Subscribers

**Definition:**
Users with an active non-Free subscription at end of period.

---

## Premium Conversion Rate

**Definition:**
Percentage of users who moved from Free → Paid plan.

```
Converted Users / Total Free Users
```

**Conversion Window:**

* Within 30 days of signup (default cohort definition)

---

## Monthly Churn Rate

**Definition:**
Percentage of subscribers who cancel within a given month.

```
Cancelled Users / Active Users at start of month
```

---

## Average Subscription Length

```
AVG(end_date - start_date)
```

Only includes completed subscriptions (excluding active ones).

---

# Revenue Metrics

---

## Monthly Recurring Revenue (MRR)

**Definition:**
Sum of active subscription revenue per month.

```
MRR = SUM(monthly_price of active subscriptions)
```

**Rules:**

* Only includes active subscriptions
* Family plans counted once per subscription (not per user)

---

## Annual Recurring Revenue (ARR)

```
ARR = MRR × 12
```

---

## Average Revenue Per User (ARPU)

```
Total Revenue / Total Active Users
```

---

## Customer Lifetime Value (LTV)

**Definition:**
Estimated revenue generated per user over their lifetime.

```
LTV = ARPU × Average Subscription Duration (months)
```

---

## Advertising Revenue

**Definition:**
Revenue generated from Free-tier listening activity.

```
Ad impressions × CPM rate (simulated)
```

Adjusted by:

* Country
* Device type
* Listening duration

---

## Total Revenue

```
Subscription Revenue + Advertising Revenue
```

---

# Marketing Metrics

---

## Customer Acquisition Cost (CAC)

```
Marketing Spend / New Paying Users
```

---

## Cost Per Install (CPI)

```
Marketing Spend / App Installs
```

---

## Return on Ad Spend (ROAS)

```
Revenue from campaign / Campaign spend
```

---

## Conversion Rate

```
Paid Signups / Total Signups
```

---

# Content Metrics

---

## Top Songs

Ranked by:

* Total plays
* Total listening time

---

## Artist Popularity Score

Composite metric:

```
(0.6 × total listening time)
+ (0.3 × number of unique listeners)
+ (0.1 × playlist adds)
```

---

## Genre Engagement Score

```
Total listening time per genre / total listening time
```

---

## Playlist Engagement

Includes:

* Followers
* Plays from playlist source
* Average completion rate of playlist tracks

---

## Podcast Completion Rate

```
Completed episodes / Total podcast plays
```

---

# Retention Metrics

---

## 7-Day Retention

Percentage of users active 7 days after signup.

---

## 30-Day Retention

Percentage of users active 30 days after signup.

---

## Cohort Retention

Users grouped by signup month:

```
Retention = Active users in month N / Cohort size
```

---

## Churn Definition

A user is considered churned if:

* No listening activity for 30 consecutive days
  AND
* No active subscription

---

# Data Quality Rules

These rules define what must be flagged during ETL.

## Invalid Records

Flag but do not immediately delete:

* Negative session duration
* Timestamp in future (> current_date)
* Missing user_id or song_id
* Subscription without payment record
* Payment without subscription
* Song duration = 0

---

## Duplicate Handling

* Listening events: duplicates allowed in raw layer, removed in analytics layer
* Users: duplicates must be deduplicated using latest signup record
* Payments: duplicates must be flagged and investigated

---

## Referential Integrity Rules

* Every listening event must reference a valid user_id
* Every song must reference a valid artist_id
* Every subscription must reference a valid user_id

Exceptions are logged as data quality incidents.

---

# Metric Hierarchy

To avoid confusion, metrics are grouped as:

## Level 1 (Executive KPIs)

* Revenue
* MAU
* MRR
* Churn Rate
* DAU

## Level 2 (Operational KPIs)

* Session duration
* Skip rate
* Conversion rate
* ARPU

## Level 3 (Diagnostic Metrics)

* Song completion rate
* Playlist engagement
* Campaign CTR
* Payment failure rate

---

# Metric Ownership

| Metric Area | Owner Team   |
| ----------- | ------------ |
| Growth  	| Product  	|
| Revenue 	| Finance  	|
| Engagement  | Product  	|
| Marketing   | Marketing	|
| Content 	| Content Team |
| Retention   | Data Team	|

---

# Final Notes

This ARS is the **single source of truth for metric definitions**.

All downstream components must conform to this specification:

* SQL transformations
* Data warehouse tables
* Power BI dashboards
* Ad hoc analysis

Any deviation must be explicitly documented and approved by the analytics team.
