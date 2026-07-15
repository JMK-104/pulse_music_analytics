# 3. Database Configuration

## 3.1 Purpose

This section defines the technical configuration standards for the Pulse Music operational database.

These standards establish a consistent implementation approach for database creation, object naming, data storage, and key management, ensuring maintainability, scalability, and compatibility with the downstream analytics platform.

---

## 3.2 Database Information

| Property           | Value                                         |
| ------------------ | --------------------------------------------- |
| Database Name      | `pulse_music_operational`                     |
| Database Engine    | PostgreSQL                                    |
| Database Type      | Relational Database Management System (RDBMS) |
| Processing Model   | Online Transaction Processing (OLTP)          |
| Primary Purpose    | Operational transaction processing            |
| Character Encoding | UTF-8                                         |
| Time Zone          | UTC                                           |

---

## 3.3 Schema Configuration

The operational database uses a single application schema.

| Schema   | Purpose                                |
| -------- | -------------------------------------- |
| `public` | Stores all operational business tables |

The Bronze, Silver, and Gold schemas are part of the analytics warehouse and are not included within the operational database.

---

## 3.4 Object Naming Conventions

To ensure consistency throughout the database, the following naming standards are applied.

### Tables

* Singular nouns
* Lowercase
* Snake case

Examples:

```text
user
artist
album
song
playlist
payment
```

---

### Columns

* Lowercase
* Snake case
* Descriptive business names

Examples:

```text
user_id
artist_name
subscription_plan
playback_timestamp
payment_amount
```

---

### Primary Keys

Primary key columns follow the convention:

```text
<table_name>_id
```

Examples:

```text
user_id
artist_id
album_id
song_id
payment_id
```

---

### Foreign Keys

Foreign keys use the same business identifier as the referenced primary key.

Example:

```text
song.artist_id
```

references

```text
artist.artist_id
```

---

### Constraints

Constraint names follow a consistent naming pattern.

| Constraint Type | Convention                      |
| --------------- | ------------------------------- |
| Primary Key     | `pk_<table>`                    |
| Foreign Key     | `fk_<table>_<referenced_table>` |
| Unique          | `uq_<table>_<column>`           |
| Check           | `chk_<table>_<column>`          |

Examples:

```text
pk_song

fk_song_artist

uq_user_email

chk_payment_amount
```

---

### Indexes

Indexes follow the convention:

```text
idx_<table>_<column>
```

Examples:

```text
idx_song_title

idx_user_country

idx_payment_timestamp
```

---

## 3.5 Identifier Strategy

The operational database uses natural business identifiers as primary keys.

Examples include:

* User ID
* Artist ID
* Album ID
* Song ID
* Playlist ID
* Session ID
* Payment ID

These identifiers originate within the operational system and are preserved throughout the ETL process.

The analytics warehouse generates surrogate keys independently for all dimension tables.

---

## 3.6 Data Type Standards

The following PostgreSQL data types are used throughout the operational database.

| Data Category | PostgreSQL Type   |
| ------------- | ----------------- |
| Identifier    | UUID              |
| Short Text    | VARCHAR(n)        |
| Long Text     | TEXT              |
| Integer       | INTEGER           |
| Decimal       | NUMERIC(p,s)      |
| Boolean       | BOOLEAN           |
| Date          | DATE              |
| Timestamp     | TIMESTAMP         |
| Duration      | INTEGER (seconds) |

Selecting consistent data types improves interoperability and simplifies ETL transformations.

---

## 3.7 Date and Time Standards

All timestamps are stored using Coordinated Universal Time (UTC).

Standard timestamp columns include:

* created_at
* updated_at
* playback_timestamp
* session_start_timestamp
* payment_timestamp

Using UTC ensures consistent time-based analysis across multiple geographic regions.

---

## 3.8 Nullability Standards

Columns are classified according to business requirements.

| Category                        | Rule                                           |
| ------------------------------- | ---------------------------------------------- |
| Required business attributes    | `NOT NULL`                                     |
| Optional descriptive attributes | Nullable                                       |
| Foreign keys                    | `NOT NULL` unless the relationship is optional |
| Audit timestamps                | `NOT NULL`                                     |

Examples:

| Column               | Nullable                            |
| -------------------- | ----------------------------------- |
| user_id              | No                                  |
| email                | No                                  |
| playlist_description | Yes                                 |
| album_id             | Yes (to support standalone singles) |

---

## 3.9 Audit Columns

Operational tables include standard audit columns where applicable.

| Column     | Purpose                            |
| ---------- | ---------------------------------- |
| created_at | Record creation timestamp          |
| updated_at | Most recent modification timestamp |

These columns support incremental ETL processing and operational auditing.

---

## 3.10 Configuration Summary

The database configuration standards defined in this section establish a consistent implementation framework for the Pulse Music operational database.

By standardizing naming conventions, identifier strategies, data types, timestamp handling, and schema organization, the operational database provides a stable and maintainable foundation for downstream ETL processing and analytics.
