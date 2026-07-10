# Business Requirements Document

# Project Overview

## Purpose

Pulse Music is a fictional subscription-based music streaming platform operating across multiple international markets. The company has experienced rapid user growth since its launch and now requires a centralized analytics platform to support business decision-making.

This project aims to design and implement an end-to-end analytics solution that models the core operations of the business. The platform will include a relational data warehouse, realistic synthetic data, automated ETL processes, data quality validation, SQL-based analytics, and interactive Power BI dashboards.

The resulting analytics environment is intended to mirror the structure and workflows commonly found within a real-world music streaming company.

---

# Business Background

## Company

**Pulse Music**

Founded: 2022

Headquarters: New York, USA

Industry:
Digital Music Streaming

Business Model:

* Freemium streaming
* Premium subscriptions
* Advertising revenue

Target Audience:

Music listeners aged 16–55 with global availability across selected markets.

---

# Business Objectives

Pulse Music's executive leadership has identified several strategic objectives for the analytics platform.

### Increase Premium Revenue

Understand what drives users to upgrade from Free to Premium and identify opportunities to improve subscription conversion.

---

### Improve User Retention

Reduce customer churn by identifying behavioral patterns associated with cancellations.

---

### Increase User Engagement

Monitor listening behavior to encourage longer sessions, increased platform usage, and stronger user loyalty.

---

### Optimize Marketing Spend

Evaluate the effectiveness of acquisition campaigns and identify the highest-performing marketing channels.

---

### Improve Content Strategy

Understand which artists, genres, playlists, and podcasts generate the greatest user engagement.

---

### Support Executive Decision-Making

Provide executives with timely, accurate KPIs through interactive dashboards.

---

# Revenue Model

Pulse Music generates revenue through two primary streams.

## Subscription Revenue

Plans include:

| Plan           	| Monthly Price |
| ------------------ | ------------: |
| Free           	|        	$0 |
| Student        	|     	$5.99 |
| Premium Individual |    	$10.99 |
| Premium Family 	|    	$16.99 |

---

## Advertising Revenue

Free-tier users generate advertising revenue based on listening activity.

Revenue is influenced by:

* Listening hours
* Geographic market
* Advertising demand
* Seasonality

---

# Markets

Pulse Music currently operates in:

| Country    	|
| -------------- |
| United States  |
| Canada     	|
| United Kingdom |
| Germany    	|
| France     	|
| Australia  	|
| Brazil     	|
| Japan      	|
| India      	|

Future expansion markets are outside the scope of this project.

---

# Departments Using the Data

The analytics platform supports several business teams.

| Department       	| Primary Questions                 	|
| -------------------- | ------------------------------------- |
| Executive Leadership | Is the business growing?          	|
| Product          	| Are users engaging more?          	|
| Marketing        	| Which campaigns generate subscribers? |
| Finance          	| What drives revenue?              	|
| Content          	| Which music performs best?        	|
| Customer Success 	| Why are users cancelling?         	|

---

# Key Performance Indicators (KPIs)

The platform should support calculation of the following metrics.

## Growth

* Daily Active Users (DAU)
* Weekly Active Users (WAU)
* Monthly Active Users (MAU)
* New User Signups
* User Growth Rate

---

## Engagement

* Average Session Duration
* Average Listening Time
* Songs per Session
* Sessions per User
* Skip Rate
* Completion Rate

---

## Subscription

* Premium Conversion Rate
* Active Subscribers
* Subscription Mix
* Monthly Churn Rate
* Average Subscription Duration

---

## Revenue

* Monthly Recurring Revenue (MRR)
* Annual Recurring Revenue (ARR)
* Average Revenue Per User (ARPU)
* Customer Lifetime Value (LTV)
* Advertising Revenue
* Total Revenue

---

## Marketing

* Customer Acquisition Cost (CAC)
* Campaign Conversion Rate
* Cost per Install (CPI)
* Return on Advertising Spend (ROAS)

---

## Content

* Top Artists
* Top Songs
* Genre Popularity
* Playlist Engagement
* Podcast Engagement

---

# Core Business Questions

The analytics platform should enable stakeholders to answer questions such as:

### Growth

* How quickly is the user base growing?
* Which countries are experiencing the highest growth?
* What percentage of new users become active listeners?

---

### Engagement

* How often do users return to the platform?
* Which devices generate the longest listening sessions?
* Which genres have the highest completion rates?

---

### Revenue

* Which subscription plan generates the most revenue?
* How has MRR changed over time?
* What percentage of revenue comes from advertisements?

---

### Marketing

* Which acquisition channels produce the highest-value customers?
* Which campaigns have the highest ROI?
* How long does it take new users to convert to Premium?

---

### Retention

* Which user segments are most likely to churn?
* How does listening behavior change before cancellation?
* Which subscription plans have the highest retention?

---

### Content

* Which artists drive the most listening hours?
* Which playlists increase user engagement?
* Which podcasts have the highest completion rates?

---

# Reporting Frequency

| Report          	| Frequency |
| ------------------- | --------- |
| Executive Dashboard | Daily 	|
| Marketing Dashboard | Weekly	|
| Revenue Dashboard   | Monthly   |
| Retention Analysis  | Monthly   |
| Content Performance | Weekly	|

---

# Project Scope

### Included

* User analytics
* Subscription analytics
* Revenue analytics
* Marketing analytics
* Content analytics
* Podcast analytics
* Data quality validation
* SQL reporting
* Power BI dashboards
* Synthetic data generation

### Excluded

* Recommendation algorithms
* Machine learning personalization
* Audio processing
* Real-time streaming analytics
* Mobile app development

---

# Assumptions

* All data is synthetic but designed to closely resemble production data.
* Personally identifiable information (PII) will not be generated; user records will use synthetic identifiers rather than names or email addresses.
* All timestamps will use UTC for consistency.
* Currency values will be stored in USD to simplify financial reporting.
* The dataset will intentionally include a small percentage of realistic data quality issues (e.g., missing values, duplicates, invalid timestamps, orphaned records) to support data cleaning and validation exercises.
