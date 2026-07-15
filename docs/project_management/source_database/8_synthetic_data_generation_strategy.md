# 8. Synthetic Data Generation Strategy

## 8.1 Purpose

This section defines the strategy for generating synthetic source data for the Pulse Music operational database.

The generated dataset must simulate a realistic audio-streaming business while remaining reproducible, internally coherent, and suitable for demonstrating data engineering and analytics workflows.

The generation process must produce data that is:

* Realistic in scale and distribution
* Relationally consistent
* Temporally coherent
* Suitable for business analysis
* Intentionally imperfect in controlled ways
* Reproducible across development environments

---

## 8.2 Generation Objectives

The synthetic dataset is designed to support analysis of:

* User growth and engagement
* Music consumption
* Podcast consumption
* Content performance
* Subscription behavior
* Churn and retention
* Revenue and payments
* Device and geographic usage
* Marketing performance

The generated data should produce meaningful patterns rather than uniformly random values.

---

## 8.3 Generation Architecture

Data generation will be implemented using Python scripts.

The generation process will follow source-table dependency order so that valid foreign key relationships can be created.

Recommended generation sequence:

```text
1. users
2. artists
3. albums
4. songs
5. playlists
6. podcasts
7. podcast_episodes
8. sessions
9. user_subscriptions
10. payments
11. listening_history
12. podcast_listening_history
13. marketing_campaigns
```

Parent entities must be generated before dependent child records.

---

## 8.4 Reproducibility

The data generation process must support reproducible execution.

A fixed random seed should be configurable:

```python
RANDOM_SEED = 42
```

Using a consistent seed allows:

* Repeatable development
* Predictable testing
* Easier debugging
* Consistent analytical results

The seed may be changed when a new dataset version is intentionally generated.

---

## 8.5 Dataset Scale

The target dataset volumes are:

| Table                       | Approximate Record Count |
| --------------------------- | ------------------------ |
| `users`                     | 50,000                   |
| `artists`                   | 5,000                    |
| `albums`                    | 15,000                   |
| `songs`                     | 200,000                  |
| `playlists`                 | 80,000                   |
| `podcasts`                  | 3,000                    |
| `podcast_episodes`          | 75,000                   |
| `sessions`                  | 2,000,000                |
| `listening_history`         | 25,000,000               |
| `podcast_listening_history` | 3,500,000                |
| `user_subscriptions`        | 120,000                  |
| `payments`                  | 450,000                  |
| `marketing_campaigns`       | 500                      |

Exact counts may vary where variable record generation produces more realistic distributions.

Development environments may use reduced-scale datasets while preserving the same generation logic.

---

## 8.6 Temporal Scope

The dataset should cover multiple years to support:

* Year-over-year analysis
* Monthly trends
* Cohort analysis
* Retention analysis
* Subscription lifecycle analysis
* Seasonality analysis

A recommended analytical period is approximately five years.

Dates must follow logical dependencies.

Examples include:

* User activity cannot normally occur before registration.
* Payments should normally occur during a valid subscription period.
* Song playback cannot occur before the song is available.
* Podcast playback cannot occur before episode release.
* Album release dates should align with associated song releases.
* Campaign performance should occur within the campaign period.

Controlled exceptions may be introduced as documented data-quality anomalies.

---

## 8.7 Distribution Strategy

Uniform random generation should be avoided where it would produce unrealistic business behavior.

The dataset should use weighted and skewed distributions.

### User Activity

A minority of users should generate a disproportionately large share of activity.

Example behavioral groups may include:

* Highly active users
* Regular users
* Casual users
* Dormant users

### Content Popularity

Song and podcast popularity should follow a long-tail distribution.

A small proportion of content should account for a large share of playback events.

### Geography

User distribution should be weighted across selected markets rather than evenly distributed across countries.

### Devices

Device usage should reflect plausible differences between:

* Mobile
* Desktop
* Web
* Tablet
* Smart TV
* Other supported devices

### Subscription Plans

Free-tier users should represent a substantial proportion of the user base, while paid plans should follow realistic adoption patterns.

---

## 8.8 Correlated Data Generation

Related attributes should be generated together where appropriate.

Examples include:

* City should correspond to country.
* Device type should influence operating system.
* Subscription plan should influence payment amount.
* Billing cycle should influence payment frequency.
* User activity level should influence session and playback volume.
* Content popularity should influence playback probability.
* Campaign channel should influence plausible click-through and conversion rates.

This prevents the dataset from appearing as a collection of independently randomized columns.

---

## 8.9 User Generation

Users should be generated with realistic variation in:

* Age
* Geography
* Registration date
* Activity level
* Account status

Registration volume should vary over time rather than remaining perfectly constant.

Selected periods may show higher acquisition rates associated with:

* Marketing campaigns
* Product growth
* Seasonal effects

A subset of users should become inactive over time.

---

## 8.10 Music Catalog Generation

The music catalog should model realistic hierarchical relationships:

```text
Artist
   ↓
Album
   ↓
Song
```

Artists should vary in:

* Number of albums
* Number of songs
* Genre
* Country
* Popularity

Some songs may exist without an album to represent standalone singles.

Song durations should follow plausible musical distributions rather than being uniformly random.

---

## 8.11 Podcast Catalog Generation

The podcast catalog should model:

```text
Podcast
   ↓
Podcast Episode
```

Podcasts should vary in:

* Category
* Language
* Country
* Episode count
* Publishing frequency
* Popularity

Episode duration should vary by podcast category and format where practical.

---

## 8.12 Engagement Event Generation

Playback events should be generated from weighted user and content behavior.

Event generation should account for:

* User activity level
* Content popularity
* Time of day
* Day of week
* Device preferences
* Content release dates
* User registration dates

Listening behavior should include:

* Completed plays
* Partial plays
* Skips
* Repeat listening

Podcast consumption should generally involve longer playback durations than music consumption.

---

## 8.13 Subscription Lifecycle Generation

Subscription histories should represent realistic lifecycle behavior.

Possible transitions include:

```text
Free → Premium

Premium → Cancelled

Cancelled → Reactivated

Monthly → Annual

Individual → Family
```

Not every user requires a paid subscription record.

Users may have multiple subscription records over time.

Subscription generation should support downstream analysis of:

* Conversion
* Churn
* Reactivation
* Plan migration
* Retention

---

## 8.14 Payment Generation

Payments should be generated from subscription activity.

Payment behavior should include:

* Successful payments
* Failed payments
* Retried payments
* Different payment methods
* Multiple currencies where applicable

Payment amounts should correspond to subscription plan and billing cycle under normal conditions.

A small number of controlled anomalies may intentionally violate expected relationships for ETL validation.

---

## 8.15 Marketing Campaign Generation

Campaigns should vary by:

* Channel
* Objective
* Duration
* Budget
* Spend
* Impressions
* Clicks
* Conversions

Performance metrics should normally follow plausible funnel relationships:

```text
Impressions ≥ Clicks ≥ Conversions
```

Different channels should exhibit different performance characteristics.

---

## 8.16 Intentional Data Quality Issues

Controlled data-quality issues will be introduced to demonstrate ETL cleansing and validation.

Potential anomaly categories include:

* Missing optional values
* Duplicate business entities
* Inconsistent capitalization
* Leading and trailing whitespace
* Invalid categorical labels
* Inconsistent geographic values
* Suspicious future dates
* Cross-record inconsistencies
* Invalid business relationships

Anomalies must remain limited enough that the dataset is analytically useful.

The majority of records should represent valid, realistic operational data.

---

## 8.17 Anomaly Injection Strategy

Data-quality issues should be introduced deliberately rather than emerging accidentally from poorly controlled generation logic.

Each anomaly type should have:

* A defined target table
* A defined target column or relationship
* An approximate injection rate
* A known expected ETL response

Where database constraints prevent invalid records from being stored, anomalies may be introduced into raw extraction files or the Bronze layer.

---

## 8.18 Performance and Memory Strategy

High-volume event tables should be generated in batches.

The generator should avoid holding the complete 25-million-row listening history dataset in memory.

Recommended techniques include:

* Batch generation
* Chunked file writing
* Bulk database loading
* Vectorized operations where practical

Large tables may initially be generated as CSV or another supported staging format before bulk loading into PostgreSQL.

---

## 8.19 Data Generation Validation

The generation process should validate:

* Expected row counts
* Primary key uniqueness
* Foreign key integrity
* Date relationships
* Distribution targets
* Null rates
* Duplicate rates
* Anomaly injection rates

Summary statistics should be produced after generation to confirm that the dataset matches its design objectives.

---

## 8.20 Synthetic Data Generation Summary

The Pulse Music synthetic data generation process is designed to produce a realistic, reproducible, and analytically meaningful operational dataset.

The strategy prioritizes correlated business behavior, realistic distributions, temporal consistency, and controlled data-quality imperfections over simple random generation.

---

