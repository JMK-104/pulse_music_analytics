-- ==========================================================
-- Marketing Campaigns
-- ==========================================================

-- Empty Campaign Names
SELECT *
FROM marketing_campaigns
WHERE TRIM(campaign_name) = ''
;

-- Future Campaign Start Dates
SELECT *
FROM marketing_campaigns
WHERE start_date > CURRENT_DATE
;

-- End dates before start dates
SELECT *
FROM marketing_campaigns
WHERE end_date < start_date
;

-- Negative campaign budgets
SELECT *
FROM marketing_campaigns
WHERE budget < 0
;

-- Negative campaign spend
SELECT *
FROM marketing_campaigns
WHERE spend < 0
;

-- Spend exceeds budget
SELECT *
FROM marketing_campaigns
WHERE spend > budget
;

-- Negative Marketing metrics
SELECT *
FROM marketing_campaigns
WHERE impressions < 0
   OR clicks < 0
   OR conversions < 0
;

-- Clicks greater then impressions
SELECT *
FROM marketing_campaigns
WHERE clicks > impressions
;

-- Conversions greater than clicks
SELECT *
FROM marketing_campaigns
WHERE conversions > clicks
;

-- Missing campaign objectives
SELECT *
FROM marketing_campaigns
WHERE campaign_objective IS NULL
;

-- Invalid Channel Values
SELECT
    channel,
    COUNT(*) AS campaign_count
FROM marketing_campaigns
GROUP BY channel
ORDER BY campaign_count DESC
;

-- Duplicate Campaigns
SELECT
    campaign_name,
    channel,
    start_date,
    COUNT(*) AS duplicate_count
FROM marketing_campaigns
GROUP BY
    campaign_name,
    channel,
    start_date
HAVING COUNT(*) > 1
;

-- Campaign efficiency anomalies
SELECT
    campaign_id,
    campaign_name,
    clicks::DECIMAL / NULLIF(impressions,0) AS click_through_rate
FROM marketing_campaigns
;

-- Campaigns with spend but no activity
SELECT *
FROM marketing_campaigns
WHERE spend > 0
AND (
    impressions IS NULL
    OR impressions = 0
)
;