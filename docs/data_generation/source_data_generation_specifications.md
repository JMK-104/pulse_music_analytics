# Pulse Music Analytics — Source Data Generation Specification

## 1. Purpose

This document defines the specifications and rules used to generate the synthetic source data for the Pulse Music Analytics platform.

The generated dataset is intended to simulate a realistic operational data environment for a digital music and podcast streaming platform. The data will subsequently be loaded into the PostgreSQL `source` schema and used as the input for downstream data engineering, analytics, and visualization processes.

The generation process should produce data that is:

- **Realistic** — values and distributions should resemble a real streaming platform.
- **Relationally consistent** — foreign-key relationships should be preserved.
- **Reproducible** — identical generator versions and random seeds should produce the same dataset.
- **Sufficiently large** — the dataset should support meaningful analytical workloads.
- **Purposefully imperfect** — selected source-system data quality issues should be represented without violating database constraints.

---

## 2. Generation Architecture

Source data will be generated programmatically using Python.

The generated data will initially be written to CSV files before being loaded into the PostgreSQL `source` schema.

```text
Python Generators
       │
       ▼
CSV Source Files
       │
       ▼
PostgreSQL Source Schema
       │
       ▼
Data Validation
       │
       ▼
ETL / Analytics Warehouse
```

Generated source files will be stored under:

```text
data/
└── source/
    └── raw/
```

Generation code will be stored under:

```text
data/
└── source/
    └── generators/
```

---

## 3. Reproducibility

The generation process will use a fixed random seed.

**Primary seed:**

```text
42
```

The seed should be defined centrally rather than independently within each generator.

This allows the complete source dataset to be regenerated consistently.

The generator should also use centralized configuration for:

- Row counts
- Date ranges
- Random seed
- Categorical distributions
- Data-quality rules

---

## 4. Source Dataset Scope

The initial target dataset will contain approximately **900,000 records** across 13 source tables.

| Table | Target Rows |
|---|---:|
| `users` | 25,000 |
| `artists` | 2,000 |
| `albums` | 5,000 |
| `songs` | 20,000 |
| `playlists` | 8,000 |
| `podcasts` | 1,000 |
| `podcast_episodes` | 15,000 |
| `sessions` | 75,000 |
| `listening_history` | 500,000 |
| `podcast_listening_history` | 150,000 |
| `user_subscriptions` | 30,000 |
| `payments` | 75,000 |
| `marketing_campaigns` | 100 |

These figures represent initial targets rather than strict requirements. They may be adjusted during implementation if generation or database performance indicates that a different scale would be more appropriate.

---

## 5. Generation Order

Because the source tables contain foreign-key relationships, data must be generated in dependency order.

### Reference and entity tables

```text
1. users
2. artists
3. albums
4. songs
5. playlists
6. podcasts
7. podcast_episodes
```

### Activity tables

```text
8. sessions
9. listening_history
10. podcast_listening_history
```

### Commercial tables

```text
11. user_subscriptions
12. payments
13. marketing_campaigns
```

This ordering ensures that referenced entities exist before dependent records are generated.

---

## 6. General Data Generation Principles

### 6.1 Identifiers

All primary identifiers will be generated as UUIDs.

Generated foreign keys must reference valid identifiers from their corresponding parent datasets.

No orphan foreign-key values should be generated.

---

### 6.2 Dates and Timestamps

Dates should fall within a coherent platform lifecycle.

The dataset should represent a platform that grows over time rather than one in which every date is uniformly random.

Dates should therefore be generated using distributions appropriate to the entity.

For example:

- User registrations should increase as the platform grows.
- Songs should generally be released before their playback events.
- Albums should generally be released before associated songs are streamed.
- Sessions should occur after user registration.
- Payments should occur during active subscription periods.

---

### 6.3 Categorical Data

Categorical values should come from controlled lists rather than arbitrary random strings.

Examples include:

```text
genre
country
device_type
source_type
subscription_status
billing_cycle
payment_status
playlist_type
campaign channel
```

Where appropriate, categorical values should have non-uniform distributions.

For example, mobile devices should likely account for a larger proportion of listening activity than less common device types.

---

## 7. Relationship Integrity

Generated records must respect the source database relationships.

Examples:

```text
albums.artist_id
        ↓
artists.artist_id
```

```text
songs.artist_id
songs.album_id
        ↓
artists.artist_id
albums.album_id
```

```text
listening_history.user_id
listening_history.song_id
listening_history.playlist_id
        ↓
users.user_id
songs.song_id
playlists.playlist_id
```

```text
user_subscriptions.user_id
        ↓
users.user_id
```

```text
payments.subscription_id
payments.user_id
        ↓
user_subscriptions.subscription_id
users.user_id
```

The generator should therefore retain the identifiers generated for each parent entity so that dependent records can reference them.

---

## 8. Data Quality Strategy

The source data is intended to represent an operational system and therefore should not be perfectly clean.

However, data-quality issues must be introduced carefully.

### Acceptable source-system imperfections

Examples include:

- Missing optional values
- Duplicate business records
- Inconsistent categorical capitalization
- Minor textual inconsistencies
- Suspicious but technically valid values
- Statistical outliers

### Constraints that must not be intentionally violated

The generator should not produce records that violate fundamental database integrity rules, such as:

- Missing primary keys
- Invalid UUIDs
- Orphan foreign keys
- NULL values in mandatory columns
- Negative values where CHECK constraints prohibit them

This distinction allows the project to demonstrate data-quality handling during ETL without making the initial source database impossible to load.

---

## 9. Table-Level Generation Specifications

Each source table will have a dedicated subsection defining:

1. Target row count
2. Generation dependencies
3. Value distributions
4. Date ranges
5. Relationship rules
6. Data-quality scenarios
7. Special generation logic

The specifications will be developed in dependency order.

---

## 9.1 Users

#### Target volume

**25,000 users**

#### Dependencies

None.

`users` is a foundational entity and must therefore be generated first.

#### Key generation rules

##### `user_id`

Generate a unique UUID for every user.

##### `first_name` / `last_name`

Generate realistic human names using a controlled name dataset.

Names should not be generated as artificial strings such as:

```text
User12345
```

##### `email`

Generate a unique email address for each user.

The email should correspond logically to the generated name where practical.

Example:

```text
jane.smith@example.com
```

##### `date_of_birth`

Generate plausible dates of birth representing an adult-oriented streaming audience.

The distribution should not be uniform across all possible dates.

##### `gender`

Use a controlled categorical distribution.

Missing values may be introduced because this is an optional source attribute.

##### `country`

Generate users across a defined set of countries, with a deliberately uneven distribution representing the platform's primary markets.

##### `city`

Generate a plausible city associated with the user's country.

##### `registration_date`

Generate dates representing the growth of the platform over its operational period.

Registration volume should generally increase as the platform becomes more established.

##### `is_active`

Generate active/inactive status using a realistic distribution.

Recently registered users should generally have a higher probability of being active than long-inactive accounts.

##### `created_at`

Generate a timestamp associated with the user's registration/record creation.

##### `updated_at`

Generate timestamps at or after `created_at`.


## 9.2 Artists

### Target Volume
**2,000 artists**

### Dependencies
None. `artists` is a foundational entity.

### Generation Rules

- **`artist_id`** — Generate a unique UUID for every artist.
- **`artist_name`** — Generate realistic solo artists, bands, duos, and groups. Names must be unique within the dataset and may include punctuation or stylistic naming conventions.
- **`country`** — Assign countries from a controlled list with deliberately uneven market representation. Missing values may be introduced.
- **`primary_genre`** — Assign genres from a controlled, non-uniform list such as Pop, Hip-Hop, Rock, R&B, Electronic, Country, Jazz, Classical, Reggae, Latin, Afrobeats, Alternative, and Metal. Missing values may be introduced.
- **`is_active`** — Most artists should be active, with a smaller proportion inactive.
- **`created_at`** — Generate realistic record creation timestamps, generally before associated albums and songs.
- **`updated_at`** — Generate timestamps at or after `created_at`.

### Relationship Rules

Artists are parent entities for albums and songs:

```text
artists.artist_id
       │
       ├──────────────► albums.artist_id
       │
       └──────────────► songs.artist_id
```

Every dependent record must reference an existing artist.

### Data Quality Scenarios

Potential imperfections include missing country or genre values, minor artist-name formatting inconsistencies, and artists with unusually large or small catalogs. These must not violate primary-key or foreign-key constraints.


## 9.3 Albums

### Target Volume
**5,000 albums**

### Dependencies
- `artists`

### Generation Rules

- **`album_id`** — Generate a unique UUID.
- **`artist_id`** — Select an existing artist. Catalog sizes should be non-uniform, with some artists accounting for many releases and many artists having only a few.
- **`album_title`** — Generate realistic, varied album titles.
- **`release_date`** — Generate plausible release dates across the platform's catalog history. New and older releases should both be represented.
- **`album_type`** — Use controlled categories: Album, EP, and Single. Albums should be most common.
- **`label_name`** — Select from realistic record-label names, including independent/self-release labels. Missing values are permitted.
- **`created_at`** — Generate timestamps corresponding to or following the release date.
- **`updated_at`** — Generate timestamps at or after `created_at`.

### Relationship Rules

Every album must reference an existing artist:

```text
artists.artist_id
       │
       ▼
albums.artist_id
```

An artist may have many albums; each album belongs to one primary artist in this source model.

### Data Quality Scenarios

Potential imperfections include missing label names, minor label-name formatting inconsistencies, unusually large artist catalogs, duplicate or highly similar titles across different artists, and unusual but valid release dates.

No orphan `artist_id` values should be generated.

### Temporal Rules

Album release dates should precede associated listening activity and should generally precede playback events involving songs from the album.


## 9.4 Songs

### Target Volume
**20,000 songs**

### Dependencies
- `artists`
- `albums`

### Generation Rules

- **`song_id`** — Generate a unique UUID.
- **`artist_id`** — Assign an existing artist using a non-uniform distribution reflecting artist popularity and catalog size.
- **`album_id`** — Assign an existing album where applicable. A controlled proportion may be standalone releases with NULL `album_id`.
- **`song_title`** — Generate varied, realistic song titles, including single-word, multi-word, punctuated, parenthetical, and repeated-word titles.
- **`genre`** — Assign from a controlled genre list. Genre should usually be compatible with the artist or album, while allowing occasional differences. Missing values are permitted.
- **`duration_seconds`** — Generate realistic positive song durations with a typical commercial-song range and some valid outliers.
- **`release_date`** — For album tracks, generally use a date on or after the album release date. Standalone songs may have independent release dates.
- **`explicit`** — Most songs should be non-explicit, with a meaningful minority marked explicit.
- **`is_active`** — Most songs should be active, with a smaller proportion inactive.
- **`created_at`** — Generate timestamps associated with catalog entry.
- **`updated_at`** — Generate timestamps at or after `created_at`.

### Relationship Rules

```text
artists.artist_id ───────► songs.artist_id
albums.album_id ─────────► songs.album_id
```

All non-null `album_id` values must reference existing albums. A song's primary artist should normally match the artist associated with its album.

### Data Quality Scenarios

Potential imperfections include missing genre values, standalone songs, unusual but valid durations, minor title-format inconsistencies, and unusual but valid metadata.

Do not generate negative durations, NULL mandatory fields, or invalid foreign keys.

### Temporal Rules

Songs must be released before associated listening events. Inactive songs may retain historical listening activity.


## 9.5 Playlists

### Target Volume
**8,000 playlists**

### Dependencies
- `users`

### Generation Rules

- **`playlist_id`** — Generate a unique UUID.
- **`playlist_name`** — Generate realistic names reflecting user-created, editorial, and algorithmic playlists, including moods, activities, genres, seasons, personalized mixes, and curated titles.
- **`playlist_description`** — Generate optional descriptions. NULL values are expected, particularly for some user and algorithmic playlists.
- **`playlist_type`** — Use controlled categories: User, Editorial, and Algorithmic. User playlists should be the largest category.
- **`user_id`** — User playlists must reference an existing user. Editorial and Algorithmic playlists must have NULL `user_id`.
- **`is_public`** — Generate both public and private user playlists. Editorial and algorithmic playlists should generally be public.
- **`created_at`** — Generate realistic creation timestamps. User playlists must be created on or after the owner's registration date.
- **`updated_at`** — Generate timestamps at or after `created_at`.

### Relationship Rules

```text
users.user_id
     │
     ▼
playlists.user_id
```

Only user-owned playlists reference users.

The intended logical relationship is:

```text
playlist_type = 'User'
        ↓
user_id IS NOT NULL
```

```text
playlist_type IN ('Editorial', 'Algorithmic')
        ↓
user_id IS NULL
```

### Data Quality Scenarios

Potential imperfections include missing descriptions, similar or duplicate playlist names across users, capitalization differences, unusually large or small playlists, and private user playlists.

The generator should not intentionally violate the relationship between `playlist_type` and `user_id`.

### Temporal Rules

For user-owned playlists:

```text
playlist.created_at >= users.registration_date
```

A user cannot create a playlist before registering.



## 9.6 Podcasts

### Target Volume
**1,000 podcasts**

### Dependencies
None. `podcasts` is a foundational entity within the podcast portion of the source model.

### Generation Rules
- **`podcast_id`** — Generate a unique UUID for every podcast.
- **`podcast_title`** — Generate realistic, unique podcast titles with varied naming patterns.
- **`publisher_name`** — Generate realistic publisher, media-company, or creator names.
- **`category`** — Use controlled categories such as News, Comedy, Society & Culture, Sports, Business, Technology, True Crime, and Education.
- **`language`** — Use a controlled language list, with English prominent and other languages represented.
- **`country`** — Assign a country associated with the podcast or publisher. Missing values are permitted.
- **`is_active`** — Most podcasts should be active, with a smaller proportion inactive.
- **`created_at`** — Generate realistic record-creation timestamps.
- **`updated_at`** — Generate timestamps at or after `created_at`.

### Relationship Rules
Podcasts are parent entities for episodes:

```text
podcasts.podcast_id
       │
       ▼
podcast_episodes.podcast_id
```

Every episode must reference an existing podcast.

### Data Quality Scenarios
Potential imperfections include missing category or country values, publisher-name formatting inconsistencies, unusually large or small episode catalogs, and similar titles across different podcasts. Mandatory fields and primary-key integrity must not be violated.


## 9.7 Podcast Episodes

### Target Volume
**15,000 podcast episodes**

### Dependencies
- `podcasts`

### Generation Rules
- **`episode_id`** — Generate a unique UUID.
- **`episode_title`** — Generate realistic episode titles with varied lengths and naming patterns.
- **`release_date`** — Generate dates consistent with the associated podcast's publishing history.
- **`duration_seconds`** — Generate realistic positive durations, generally longer than music tracks while allowing shorter and longer formats.
- **`episode_number`** — Generate sequence numbers where applicable. A controlled proportion may be NULL.
- **`is_explicit`** — Most episodes should be non-explicit, with a meaningful minority marked explicit.
- **`podcast_id`** — Assign an existing podcast.
- **`is_active`** — Most episodes should be active, with a smaller proportion inactive.
- **`created_at`** — Generate timestamps associated with the episode entering the platform.
- **`updated_at`** — Generate timestamps at or after `created_at`.

### Relationship Rules
Every episode must belong to an existing podcast:

```text
podcasts.podcast_id
       │
       ▼
podcast_episodes.podcast_id
```

### Temporal Rules
Episode release dates should generally follow podcast creation and precede corresponding playback activity. Where episode numbering is available, numbers should generally increase with release date.

### Data Quality Scenarios
Potential imperfections include missing episode numbers, unusual but valid durations, title-format inconsistencies, gaps in numbering, and inactive episodes retaining historical playback activity.



## 9.8 Sessions

### Target Volume
**75,000 sessions**

### Dependencies
- `users`

### Generation Rules
- **`session_id`** — Generate a unique UUID.
- **`session_start_timestamp`** — Generate a timestamp on or after the user's registration date.
- **`session_end_timestamp`** — Generate an end timestamp for most sessions; a controlled proportion may be NULL.
- **`device_type`** — Use controlled categories such as Mobile, Desktop, Tablet, Smart TV, and Web.
- **`operating_system`** — Generate operating systems consistent with the device category where practical.
- **`country`** — Generally correspond to the user's country, while allowing differences representing travel, VPN use, or source-system inconsistencies.
- **`user_id`** — Assign an existing user.
- **`created_at`** — Generate a record-creation timestamp.

### Relationship Rules
Every session must reference an existing user:

```text
users.user_id
     │
     ▼
sessions.user_id
```

### Temporal Rules
Sessions must occur on or after registration. For completed sessions:

```text
session_end_timestamp >= session_start_timestamp
```

Session durations should follow a realistic distribution.

### Data Quality Scenarios
Potential imperfections include missing end timestamps, country differences, unusual device/OS combinations, unusually short or long sessions, and repeated sessions within short periods.


## 9.9 Listening History

### Target Volume
**500,000 playback events**

### Dependencies
- `users`
- `songs`
- `playlists`

### Generation Rules
- **`playback_id`** — Generate a unique UUID.
- **`playback_timestamp`** — Generate timestamps throughout the platform's operational period.
- **`seconds_played`** — Generate non-negative durations, generally no greater than the associated song duration.
- **`device_type`** — Use controlled device categories such as Mobile, Desktop, Tablet, Smart TV, and Web.
- **`source_type`** — Use controlled sources such as Search, Playlist, Album, Artist, Library, Recommendation, Radio, and Autoplay.
- **`user_id`** — Assign an existing user.
- **`song_id`** — Assign an existing song.
- **`playlist_id`** — Assign an existing playlist when applicable; otherwise NULL.
- **`completed`** — Derive primarily from `seconds_played` and song duration using the project's completion threshold.
- **`skipped`** — Generate from listening behavior; skipped events should generally have shorter durations.
- **`created_at`** — Generate a record-creation timestamp consistent with the playback event.

### Relationship Rules
Every playback must reference an existing user and song:

```text
users.user_id
     │
     ▼
listening_history.user_id
```

```text
songs.song_id
     │
     ▼
listening_history.song_id
```

When `playlist_id` is populated:

```text
playlists.playlist_id
       │
       ▼
listening_history.playlist_id
```

### Temporal Rules
Playback must occur after user registration and song release. If a playlist is referenced, it should exist before the playback event. Historical playback of subsequently inactive songs is allowed.

### Behavioral Distributions
Listening activity should include highly active, moderately active, and low-activity users; popular and long-tail songs; predominantly mobile playback; varied source types; and different skip rates by context.

### Data Quality Scenarios
Potential imperfections include duplicate or near-duplicate events, unusually short durations, valid duration outliers, device inconsistencies, playback of songs that later became inactive, and absent playlist attribution. Mandatory fields and foreign-key constraints must remain valid.


## 9.10 Podcast Listening History

### Target Volume
**150,000 playback events**

### Dependencies
- `users`
- `podcast_episodes`

### Generation Rules

- **`podcast_playback_id`** — Generate a unique UUID.
- **`playback_timestamp`** — Generate timestamps throughout the platform's operational period.
- **`seconds_played`** — Generate non-negative durations, generally no greater than the associated episode duration.
- **`device_type`** — Use controlled categories such as Mobile, Desktop, Tablet, Smart TV, and Web.
- **`source_type`** — Use controlled sources such as Search, Podcast Page, Library, Recommendation, Playlist, and Autoplay.
- **`user_id`** — Assign an existing user.
- **`episode_id`** — Assign an existing podcast episode.
- **`completed`** — Derive from listening duration relative to episode duration using the project's completion threshold.
- **`created_at`** — Generate a timestamp consistent with the playback event.

### Relationship Rules

Every playback must reference an existing user and episode.

```text
users.user_id
     │
     ▼
podcast_listening_history.user_id

podcast_episodes.episode_id
       │
       ▼
podcast_listening_history.episode_id
```

### Temporal Rules

Playback must occur after user registration and episode release. Historical playback of episodes that later became inactive is allowed.

### Behavioral Distributions

Include highly active, moderate, and low-activity listeners; popular and long-tail episodes; predominantly mobile consumption; varied source types; and realistic completion rates.

### Data Quality Scenarios

Potential imperfections include duplicate or near-duplicate events, unusually short durations, valid duration outliers, device inconsistencies, and playback of subsequently inactive episodes. Mandatory fields and foreign keys must remain valid.



## 9.11 User Subscriptions

### Target Volume
**30,000 subscription records**

### Dependencies
- `users`

### Generation Rules

- **`subscription_id`** — Generate a unique UUID.
- **`plan_name`** — Use controlled plans such as Free, Premium, Family, and Student according to the project's business model.
- **`billing_cycle`** — Use controlled values such as Monthly and Annual.
- **`start_date`** — Generate on or after the user's registration date.
- **`end_date`** — Generate for ended or scheduled-to-end subscriptions. Active subscriptions may have NULL end dates.
- **`user_id`** — Assign an existing user.
- **`subscription_status`** — Use controlled statuses such as Active, Cancelled, Expired, and Paused.
- **`auto_renew`** — Generate based on plan and subscription status.
- **`created_at`** — Generate a record-creation timestamp.
- **`updated_at`** — Generate a timestamp at or after `created_at`.

### Relationship Rules

Every subscription must reference an existing user.

```text
users.user_id
     │
     ▼
user_subscriptions.user_id
```

A user may have multiple historical subscription records.

### Temporal Rules

Subscriptions must begin on or after registration. Where present:

```text
end_date >= start_date
```

Successive subscriptions should have logically consistent periods.

### Behavioral Distributions

Include users with no paid subscription where appropriate, monthly and annual subscribers, cancellations, expirations, renewals, and a smaller population with multiple historical subscription records.

### Data Quality Scenarios

Potential imperfections include missing end dates for active subscriptions, multiple historical records, status transitions, and minor categorical inconsistencies. Invalid users and invalid date ranges must not be generated.


## 9.12 Payments

### Target Volume
**75,000 payment transactions**

### Dependencies
- `users`
- `user_subscriptions`

### Generation Rules

- **`payment_id`** — Generate a unique UUID.
- **`payment_timestamp`** — Generate a timestamp associated with the subscription billing period.
- **`amount`** — Generate monetary values based on plan and billing cycle.
- **`currency`** — Use three-character currency codes from a controlled list reflecting platform markets.
- **`payment_method`** — Use controlled values such as Card, Mobile Money, Bank Transfer, and Digital Wallet where appropriate.
- **`subscription_id`** — Assign an existing subscription.
- **`user_id`** — Assign the user associated with that subscription.
- **`payment_status`** — Use controlled statuses such as Completed, Failed, Refunded, and Pending.
- **`created_at`** — Generate a timestamp consistent with the payment event.

### Relationship Rules

Every payment must reference an existing subscription and user.

```text
user_subscriptions.subscription_id
             │
             ▼
payments.subscription_id

users.user_id
     │
     ▼
payments.user_id
```

The payment's `user_id` must match the owner of the referenced subscription.

### Temporal Rules

Payment timestamps should generally fall within or near the subscription period and should not precede the subscription start date.

Recurring subscriptions should generate payments at approximately monthly or annual intervals according to the billing cycle.

### Behavioral Distributions

Include predominantly successful payments, a smaller number of failed payments, occasional refunds, geography-dependent payment methods, plan-consistent amounts, and repeated payments for recurring subscriptions.

### Data Quality Scenarios

Potential imperfections include failed, refunded, and pending transactions; minor timestamp irregularities; currency variation; and repeated billing attempts. Invalid subscription or user references must not be generated.



## 9.13 Marketing Campaigns

### Target Volume
**100 campaigns**

### Dependencies
None.

### Generation Rules

- **`campaign_id`** — Generate a unique UUID.
- **`campaign_name`** — Generate realistic, unique business campaign names.
- **`channel`** — Use controlled channels such as Social Media, Email, Search, Display, Influencer, Affiliate, and In-App.
- **`campaign_objective`** — Use controlled objectives such as Acquisition, Retention, Engagement, Conversion, and Brand Awareness. Missing values are permitted.
- **`start_date`** — Generate dates across the platform's marketing history.
- **`end_date`** — Generate for completed campaigns; ongoing campaigns may have NULL.
- **`budget`** — Generate positive monetary budgets appropriate to campaign scale.
- **`spend`** — Generate actual expenditure, normally at or below budget.
- **`impressions`** — Generate non-negative impression counts where available.
- **`clicks`** — Generate non-negative click counts where available.
- **`conversions`** — Generate non-negative conversion counts where available.
- **`created_at`** — Generate record-creation timestamps.
- **`updated_at`** — Generate timestamps at or after `created_at`.

### Relationship Rules

Marketing campaigns have no foreign-key dependencies in the current source model and can be generated independently.

### Metric Relationships

Where metrics are populated, maintain a plausible marketing funnel:

```text
conversions <= clicks <= impressions
```

Also ensure:

```text
budget >= 0
spend >= 0
```

Spend should normally remain at or below budget.

### Behavioral Distributions

Campaigns should vary by channel, objective, budget, spend, reach, click-through rate, and conversion rate.

Include a small number of unusually successful or unsuccessful campaigns to create useful analytical variation.

### Data Quality Scenarios

Potential imperfections include missing objectives, missing performance metrics where tracking was unavailable, unusual performance, and minor campaign-name or channel formatting inconsistencies. Ongoing campaigns may have NULL end dates.

Mandatory fields and numeric constraints must remain valid.

---

## 10. Planned Table Specifications

The remaining tables will be documented using the same structure:

```text
9.1 users
9.2 artists
9.3 albums
9.4 songs
9.5 playlists
9.6 podcasts
9.7 podcast_episodes
9.8 sessions
9.9 listening_history
9.10 podcast_listening_history
9.11 user_subscriptions
9.12 payments
9.13 marketing_campaigns
```

This gives us a clear blueprint before implementation begins.

---

## 11. Output Files

The completed generation process should produce:

```text
data/
└── source/
    └── raw/
        ├── users.csv
        ├── artists.csv
        ├── albums.csv
        ├── songs.csv
        ├── playlists.csv
        ├── podcasts.csv
        ├── podcast_episodes.csv
        ├── sessions.csv
        ├── listening_history.csv
        ├── podcast_listening_history.csv
        ├── user_subscriptions.csv
        ├── payments.csv
        └── marketing_campaigns.csv
```

Each generated file should correspond directly to a table in the PostgreSQL `source` schema.
