# Pulse Music Analytics Platform

## Physical Data Dictionary

**Author:** Justin Kakuyo

**Last Updated:** July 7, 2026

---

# 1. Purpose

This document defines the physical structure of the Pulse Music Analytics Platform data warehouse.

It serves as the authoritative reference for all dimension and fact tables in the Gold Layer of the warehouse and provides the metadata required to implement the schema, build ETL pipelines, validate incoming data, and support downstream analytics.

The data dictionary should be read alongside the following project documentation:

* Product Requirements Document (PRD)
* Analytics Requirements Specification (ARS)
* Entity Relationship Diagram (ERD)
* ETL Mapping Specification (to be created)
* Data Quality Rules (to be created)

---

# 2. Warehouse Architecture

The Pulse Music Analytics Platform follows a Medallion Architecture consisting of three logical layers:

* **Bronze Layer** – Raw operational data copied from the source system.
* **Silver Layer** – Cleaned and standardized data after validation and transformation.
* **Gold Layer** – Curated dimensional model (Galaxy Schema) optimized for reporting and analytics.

This document describes the **Gold Layer only**.

---

# 3. Naming Standards

The following naming conventions are used throughout the warehouse.

## Tables

Dimension tables begin with:

`dim_`

Example:

* dim_user
* dim_song
* dim_date

Fact tables begin with:

`fact_`

Example:

* fact_listening
* fact_payment
* fact_session

---

## Primary Keys

Every table contains a surrogate primary key named:

`<table>_key`

Examples:

* user_key
* song_key
* payment_key

---

## Foreign Keys

Foreign keys retain the name of the referenced surrogate key.

Example:

* user_key
* plan_key
* date_key

---

## Business Keys

Identifiers originating from the operational database retain the suffix `_id`.

Examples:

* user_id
* song_id
* campaign_id

Business keys are never used for joins inside the warehouse.

---

## Boolean Columns

Boolean fields use one of the following suffixes:

* `_flag`
* `is_`

Examples:

* completed_flag
* skipped_flag
* successful_flag
* is_weekend

---

## Date and Time Columns

Dimension keys:

* date_key
* time_key

Actual dates:

* signup_date
* release_date

Timestamps should only exist in Bronze and Silver layers. The Gold layer references dates and times through conformed dimensions.

---

# 4. Standard Data Types

The following standards apply throughout the warehouse.

| Purpose             | Standard Type |
| ------------------- | ------------- |
| Surrogate Keys      | INTEGER       |
| Business IDs        | VARCHAR(20)   |
| Names               | VARCHAR(255)  |
| Country             | VARCHAR(100)  |
| City                | VARCHAR(100)  |
| Category Values     | VARCHAR(50)   |
| Descriptive Text    | VARCHAR(255)  |
| Boolean Flags       | BOOLEAN       |
| Monetary Values     | NUMERIC(10,2) |
| Counts              | INTEGER       |
| Durations (seconds) | INTEGER       |
| Dates               | DATE          |
| Time                | TIME          |

These standards ensure consistency across all warehouse objects.

---

# 5. Nullability Standards

Unless otherwise stated:

* Primary keys are NOT NULL.
* Foreign keys are NOT NULL unless explicitly optional.
* Descriptive attributes should be NOT NULL whenever possible.
* Nullable columns must have a documented business reason.

---

# 6. Dimension Tables

The following sections document every dimension table used in the Gold Layer.

1. dim_date
2. dim_time
3. dim_user
4. dim_device
5. dim_artist
6. dim_album
7. dim_song
8. dim_playlist
9. dim_plan
10. dim_campaign
11. dim_payment_method
12. dim_source
13. dim_podcast
14. dim_episode

Each dimension section will include:

* Business Purpose
* Grain
* Source Tables
* Primary Key
* Column Definitions
* Business Rules
* Data Quality Notes

---

# 7. Fact Tables

The following sections document every fact table.

1. fact_listening
2. fact_session
3. fact_subscription_event
4. fact_payment
5. fact_campaign_performance
6. fact_podcast_play

Each fact table section will include:

* Business Purpose
* Grain
* Source Tables
* Primary Key
* Foreign Keys
* Measures
* Column Definitions
* Business Rules
* Data Quality Notes

---

# 8. Revision History

| Version | Date         | Description               |
| ------- | ------------ | ------------------------- |
| 1.0     | July 7, 2026 | Initial document created. |
