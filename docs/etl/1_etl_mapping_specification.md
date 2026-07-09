# ETL Mapping Specification

**Project:** Pulse Music Analytics Platform
**Author:** Justin Kakuyo
**Last Updated:** July 8, 2026

---

# 1. Overview

## 1.1 Purpose

This document defines the Extract, Transform, and Load (ETL) processes used to populate the Pulse Music Analytics Platform data warehouse.

Its purpose is to describe how operational data is extracted from the source system, validated and transformed through the Medallion Architecture, and ultimately loaded into the dimensional (Galaxy Schema) warehouse.

The document serves as the technical implementation guide for the ETL pipelines and provides the transformation rules, loading order, data quality checks, and business logic required to produce trusted, conformed data assets.

---

## 1.2 Scope

This specification covers the complete ETL lifecycle for the Pulse Music Analytics Platform, including:

* Extraction of data from operational source tables
* Loading raw data into the Bronze layer
* Cleaning and standardizing data in the Silver layer
* Building dimension and fact tables in the Gold layer
* Surrogate key generation and lookup processes
* Incremental loading strategies
* Data validation and quality assurance
* Error handling and audit logging

The scope of this document is limited to the analytics warehouse and does not include operational database design or application-level business logic.

---

## 1.3 Objectives

The ETL pipelines are designed to achieve the following objectives:

* Preserve raw operational data without modification in the Bronze layer.
* Improve data quality through validation, cleansing, and standardization in the Silver layer.
* Produce a clean, consistent dimensional model optimized for analytical workloads.
* Maintain historical accuracy through Slowly Changing Dimension (SCD Type 2) processing where applicable.
* Ensure referential integrity between dimension and fact tables.
* Support repeatable and automated warehouse refreshes.
* Provide a scalable foundation for dashboards, ad hoc analysis, and future machine learning workloads.

---

## 1.4 Architecture Overview

The Pulse Music Analytics Platform follows a Medallion Architecture consisting of three logical layers.

### Bronze Layer

The Bronze layer stores raw operational data exactly as received from the source system.

Characteristics:

* No business transformations
* Minimal validation
* Immutable historical records
* Full auditability
* Serves as the system of record within the warehouse

Typical operations include:

* Data ingestion
* Metadata capture
* Load timestamp assignment
* File integrity validation

---

### Silver Layer

The Silver layer contains cleaned, validated, and standardized data.

This layer is responsible for improving data quality while preserving the original business meaning.

Typical transformations include:

* Removing duplicate records
* Standardizing categorical values
* Correcting inconsistent formatting
* Handling missing values
* Validating business rules
* Standardizing date and time formats
* Detecting invalid records
* Creating derived attributes

The Silver layer serves as the trusted source for downstream dimensional modeling.

---

### Gold Layer

The Gold layer contains the dimensional analytics warehouse.

This layer applies business logic and loads data into the Galaxy Schema consisting of conformed dimensions and business process fact tables.

Typical operations include:

* Surrogate key lookups
* Dimension loading
* SCD Type 2 processing
* Fact table loading
* Business metric calculation
* Referential integrity validation

The Gold layer is the primary source for reporting, dashboards, and analytical queries.

---

## 1.5 High-Level ETL Flow

```text
Operational Source System
            │
            ▼
     Bronze Layer
(Raw Operational Data)
            │
            ▼
      Silver Layer
(Cleansed & Standardized Data)
            │
            ▼
       Gold Layer
(Galaxy Schema Warehouse)
            │
            ▼
 Dashboards • Reports • Analytics
```

---

## 1.6 Source Systems

The operational database consists of the following source tables:

### Core Business Tables

| Source Table     | Description              |
| ---------------- | ------------------------ |
| Users            | User profile information |
| Songs            | Song catalog             |
| Artists          | Artist information       |
| Albums           | Album metadata           |
| Playlists        | Playlist metadata        |
| Podcasts         | Podcast show information |
| Podcast_Episodes | Podcast episode metadata |

### Operational Activity Tables

| Source Table              | Description                       |
| ------------------------- | --------------------------------- |
| Listening_History         | Song playback events              |
| Podcast_Listening_History | Podcast playback events           |
| Sessions                  | User application sessions         |
| Payments                  | Subscription payment transactions |
| User_Subscriptions        | Subscription lifecycle events     |
| Marketing_Campaigns       | Marketing campaign information    |

---

## 1.7 Target Warehouse

The ETL pipelines populate the Gold Layer Galaxy Schema consisting of:

### Dimension Tables

* `dim_date`
* `dim_time`
* `dim_device`
* `dim_plan`
* `dim_source`
* `dim_payment_method`
* `dim_campaign`
* `dim_artist`
* `dim_album`
* `dim_song`
* `dim_playlist`
* `dim_podcast`
* `dim_episode`
* `dim_user`

### Fact Tables

* `fact_listening`
* `fact_session`
* `fact_subscription_event`
* `fact_payment`
* `fact_campaign_performance`
* `fact_podcast_play`

---

## 1.8 Guiding Principles

The ETL implementation follows the following design principles:

1. **Data Integrity First**
   Raw operational data is never modified in the Bronze layer.

2. **Single Source of Truth**
   Every business entity is represented once within the dimensional model using surrogate keys.

3. **Reproducibility**
   ETL processes are deterministic and produce identical results when executed against the same source data.

4. **Automation**
   All pipeline stages are designed to execute automatically with minimal manual intervention.

5. **Scalability**
   Transformations are designed to support increasing data volumes while maintaining performance.

6. **Auditability**
   Every load can be traced from the Gold layer back to its original operational source.

7. **Maintainability**
   ETL logic is modular, well documented, and organized into reusable pipeline components.
