-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## DATA3404 Assignment 2
-- MAGIC
-- MAGIC This is the SQL template notebook for the assignment on Databricks, 2026s1.
-- MAGIC
-- MAGIC ***
-- MAGIC This notebook assumes that you have executed the **Assignment2_Databricks_Bootstrap.ipynb** notebook first.
-- MAGIC *** 

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Schema Creation - RUN THE FOLLOWING CELL ONLY ONCE
-- MAGIC As the first step for any SQL work with HIVE, we are mapping the imported CSV files as SQL tables so that they are available for subsequent SQL queries using Hive with a number of tables:
-- MAGIC **Cities**, **Neighbourhoods**, **Hosts** (Hosts table fits all data scales, but there ares also Hosts_small and Hosts_medium table) and three variants of the
-- MAGIC **Listings_**_scale_ and the **Reviews_**_scale_  tables. You can switch between differenty dataset sizes by
-- MAGIC referring to _either_ the **Listings_small**, _or_ **Listings_medium** _or_
-- MAGIC **Listings_large** tables, and reespectively for the **Reviews_**_scale_  tables.

-- COMMAND ----------

/* The following schema is using TEMP external tables */
/* As part of your assignment optimisations, consider a better physical design here, but keep the same schema names. */

DROP TABLE IF EXISTS Cities;
CREATE TEMP TABLE Cities /* (
  id              INTEGER,
  city_name       VARCHAR(20),
  state           VARCHAR(40),
  country         VARCHAR(40),
  country_code    CHAR(2)
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_cities.csv";

DROP TABLE IF EXISTS Neighbourhoods;
CREATE TEMP TABLE Neighbourhoods
/* (
  id              INTEGER,
  city_id         INTEGER,
  nhood_name      VARCHAR(50),
  nhood_group     VARCHAR(50),
  geometry        JSONB
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", samplingRatio = "0.1")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_neighbourhoods.csv";

DROP TABLE IF EXISTS Hosts;
CREATE TEMPORARY TABLE Hosts  /* in effect this is Hosts_large */
/* (
  id              INTEGER,
  host_name       VARCHAR(50),
  host_since      DATE,
  host_about      VARCHAR(1000),
  is_superhost    CHAR,
  is_verified     CHAR,
  response_time   VARCHAR(20),
  response_rate   VARCHAR(4),
  acceptance_rate VARCHAR(4),
  comm_rating     NUMERIC(3,2),
  last_scraped    DATE
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.05")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_hosts.csv";

DROP TABLE IF EXISTS Hosts_small;
CREATE TEMPORARY TABLE Hosts_small
/* (
  id              INTEGER,
  host_name       VARCHAR(50),
  host_since      DATE,
  host_about      VARCHAR(1000),
  is_superhost    CHAR,
  is_verified     CHAR,
  response_time   VARCHAR(20),
  response_rate   VARCHAR(4),
  acceptance_rate VARCHAR(4),
  comm_rating     NUMERIC(3,2),
  last_scraped    DATE
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.05")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_hosts-small.csv";

DROP TABLE IF EXISTS Hosts_medium;
CREATE TEMPORARY TABLE Hosts_medium
/* (
  id              INTEGER,
  host_name       VARCHAR(50),
  host_since      DATE,
  host_about      VARCHAR(1000),
  is_superhost    CHAR,
  is_verified     CHAR,
  response_time   VARCHAR(20),
  response_rate   VARCHAR(4),
  acceptance_rate VARCHAR(4),
  comm_rating     NUMERIC(3,2),
  last_scraped    DATE
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.05")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_hosts-medium.csv";

DROP TABLE IF EXISTS Listings_Small;
CREATE TEMP TABLE Listings_Small /* (
  id             BIGINT,
  listing_name   VARCHAR(250),
  property_type  VARCHAR(40),
  room_type      VARCHAR(15),
  price          FLOAT,
  minimum_nights INTEGER,
  host_id        INTEGER,
  city_id        INTEGER,
  neighbourhood  INTEGER,
  latitude       NUMERIC(9,6),
  longitude      NUMERIC(9,6),
  description    VARCHAR(1000),
  accommodates   INT,
  bathrooms      INT,
  bedrooms       INT,
  beds           INT,
  amenities      STRING, -- ARRAY<STRING>
  rating          NUMERIC(3,2),
  instant_bookable CHAR,
  last_scraped   DATE
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.01")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_listings-small.csv";

DROP TABLE IF EXISTS Listings_Medium;
CREATE TEMP TABLE Listings_Medium /* (
  id             BIGINT,
  listing_name   VARCHAR(250),
  property_type  VARCHAR(40),
  room_type      VARCHAR(15),
  price          FLOAT,
  minimum_nights INTEGER,
  host_id        INTEGER,
  city_id        INTEGER,
  neighbourhood  INTEGER,
  latitude       NUMERIC(9,6),
  longitude      NUMERIC(9,6),
  description    VARCHAR(1000),
  accommodates   INT,
  bathrooms      INT,
  bedrooms       INT,
  beds           INT,
  amenities      STRING, -- ARRAY<STRING>,
  rating          NUMERIC(3,2),
  instant_bookable CHAR,
  last_scraped   DATE
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.01")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_listings-medium.csv";

DROP TABLE IF EXISTS Listings_Large;
CREATE TEMP TABLE Listings_Large /* (
  id             BIGINT,
  listing_name   VARCHAR(250),
  property_type  VARCHAR(40),
  room_type      VARCHAR(15),
  price          FLOAT,
  minimum_nights INTEGER,
  host_id        INTEGER,
  city_id        INTEGER,
  neighbourhood  INTEGER,
  latitude       NUMERIC(9,6),
  longitude      NUMERIC(9,6),
  description    VARCHAR(1000),
  accommodates   INT,
  bathrooms      INT,
  bedrooms       INT,
  beds           INT,
  amenities      STRING, -- ARRAY<STRING>,
  rating          NUMERIC(3,2),
  instant_bookable CHAR,
  last_scraped   DATE
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.01")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_listings-large.csv";

DROP TABLE IF EXISTS Reviews_Small;
CREATE TEMP TABLE Reviews_Small /* (
  id             BIGINT,
  listing_id     BIGINT,
  review_date    DATE    NOT NULL,
  reviewer_id    INTEGER NOT NULL,
  reviewer_name  VARCHAR(50),
  comments       STRING
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.01")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_reviews-small.csv";

DROP TABLE IF EXISTS Reviews_Medium;
CREATE TEMP TABLE Reviews_Medium /* (
  id             BIGINT,
  listing_id     BIGINT,
  review_date    DATE    NOT NULL,
  reviewer_id    INTEGER NOT NULL,
  reviewer_name  VARCHAR(50),
  comments       STRING
) */
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.01")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_reviews-medium.csv";

DROP TABLE IF EXISTS Reviews_Large;
CREATE TEMP TABLE Reviews_Large /* (
  id             BIGINT,
  listing_id     BIGINT,
  review_date    DATE    NOT NULL,
  reviewer_id    INTEGER NOT NULL,
  reviewer_name  VARCHAR(50),
  comments       STRING
)*/
USING CSV
OPTIONS (header = "true", inferSchema = "true", nullValue = "NULL", dateFormat = "yyyy-MM-dd", samplingRatio = "0.01")
LOCATION "/Volumes/workspace/data3404/airbnb/airbnb_reviews-large.csv";

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Check whether schema has been created correctly
-- MAGIC
-- MAGIC Expected table sizes:  
-- MAGIC <style scoped>
-- MAGIC table {
-- MAGIC   font-size: 10px;
-- MAGIC }
-- MAGIC </style>
-- MAGIC | table         |  count  |
-- MAGIC |---------------|--------:|
-- MAGIC |Cities         |      12 |
-- MAGIC |Neighbourhoods |     551 |
-- MAGIC |Hosts_small    |    8200 |
-- MAGIC |Hosts_medium   |   33759 |
-- MAGIC |Hosts          |   60661 |
-- MAGIC |Listings_small |   10800 |
-- MAGIC |Listings_medium|   54000 |
-- MAGIC |Listings_large |  108464 |
-- MAGIC |Reviews_small  |  442000 |
-- MAGIC |Reviews_medium | 2210000 |
-- MAGIC |Reviews_large  | 4424389 |

-- COMMAND ----------

SELECT 'Cities', COUNT(*) FROM Cities
UNION
SELECT 'Neighbourhoods', COUNT(*) FROM Neighbourhoods
UNION
SELECT 'Hosts', COUNT(*) FROM Hosts
UNION
SELECT 'Hosts', COUNT(*) FROM Hosts_small
UNION
SELECT 'Hosts', COUNT(*) FROM Hosts_medium
UNION
SELECT 'Listings_small', COUNT(*) FROM Listings_small
UNION
SELECT 'Listings_medium', COUNT(*) FROM Listings_medium
UNION
SELECT 'Listings_large', COUNT(*) FROM Listings_large
UNION
SELECT 'Reviews_small', COUNT(*) FROM Reviews_small
UNION
SELECT 'Reviews_medium', COUNT(*) FROM Reviews_medium
UNION
SELECT 'Reviews_large', COUNT(*) FROM Reviews_large

-- COMMAND ----------

-- MAGIC %md
-- MAGIC After you executed the CREATE TABLE statements from the cell above, you can now use SQL to query the imported data.
-- MAGIC
-- MAGIC For example:

-- COMMAND ----------

SELECT city_name FROM Cities;

-- COMMAND ----------

DESCRIBE Hosts;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # Task 1
-- MAGIC
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Find the top-10 listings in Melbourne (by id and name) by a superhost which received the most reviews in 2025, as well as the date of the latest review per each listing.
-- MAGIC

-- COMMAND ----------

--  small
SELECT l.id, l.listing_name, COUNT(r.id) AS num_reviews, MAX(r.review_date) AS last_review_date
FROM Listings_Small l
JOIN Hosts h ON l.host_id = h.id
JOIN Reviews_Small r ON l.id = r.listing_id
JOIN Cities c ON l.city_id = c.id
WHERE c.city_name = 'Melbourne' AND h.is_superhost = 't' AND YEAR(r.review_date) = 2025
GROUP BY l.id, l.listing_name
ORDER BY num_reviews DESC
LIMIT 10;

-- COMMAND ----------

--medium 
SELECT l.id, l.listing_name, COUNT(r.id) AS num_reviews, MAX(r.review_date) AS last_review_date
FROM Listings_Medium l
JOIN Hosts_medium h ON l.host_id = h.id
JOIN Reviews_Medium r ON l.id = r.listing_id
JOIN Cities c ON l.city_id = c.id
WHERE c.city_name = 'Melbourne' AND h.is_superhost = 't' AND YEAR(r.review_date) = 2025
GROUP BY l.id, l.listing_name
ORDER BY num_reviews DESC
LIMIT 10;

-- COMMAND ----------

-- large
SELECT l.id, l.listing_name, COUNT(r.id) AS num_reviews, MAX(r.review_date) AS last_review_date
FROM Listings_Large l
JOIN Hosts h ON l.host_id = h.id
JOIN Reviews_Large r ON l.id = r.listing_id
JOIN Cities c ON l.city_id = c.id
WHERE c.city_name = 'Melbourne' AND h.is_superhost = 't' AND YEAR(r.review_date) = 2025
GROUP BY l.id, l.listing_name
ORDER BY num_reviews DESC
LIMIT 10;

-- COMMAND ----------

EXPLAIN SELECT l.id, l.listing_name, COUNT(r.id) AS num_reviews, MAX(r.review_date) AS last_review_date
FROM Listings_Large l
JOIN Hosts h ON l.host_id = h.id
JOIN Reviews_Large r ON l.id = r.listing_id
JOIN Cities c ON l.city_id = c.id
WHERE c.city_name = 'Melbourne' AND h.is_superhost = 't' AND YEAR(r.review_date) = 2025
GROUP BY l.id, l.listing_name
ORDER BY num_reviews DESC
LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Runtime Results
-- MAGIC
-- MAGIC ### Databricks/Spark Runtimes
-- MAGIC | Dataset | Runtime |
-- MAGIC |---------|---------|
-- MAGIC | Small   | 1s 217ms |
-- MAGIC | Medium  | 2 s 212 ms |
-- MAGIC | Large   | 5 s 139 ms |
-- MAGIC
-- MAGIC
-- MAGIC ### PostgreSQL Runtimes
-- MAGIC NEED TO RUN query on PostgreSQL with and without indexes on small/medium/large datasets and record runtimes here.
-- MAGIC
-- MAGIC | Dataset | Without index | With index |
-- MAGIC |---------|--------------|------------|
-- MAGIC | Small   |              |            |
-- MAGIC | Medium  |              |            |
-- MAGIC | Large   |              |            |
-- MAGIC
-- MAGIC ## Index Suggestions
-- MAGIC The query filters heavily on:
-- MAGIC - `Reviews.review_date` (YEAR filter) and `Reviews.listing_id` (join)
-- MAGIC - `Hosts.is_superhost` (filter)
-- MAGIC - `Listings.host_id` and `Listings.city_id` (joins)
-- MAGIC
-- MAGIC Suggested indexes for PostgreSQL:
-- MAGIC CREATE INDEX idx_reviews_listing_date ON Reviews(listing_id, review_date);
-- MAGIC CREATE INDEX idx_listings_host_city ON Listings(host_id, city_id);
-- MAGIC CREATE INDEX idx_hosts_superhost ON Hosts(id, is_superhost);
-- MAGIC
-- MAGIC These would speed up the joins and filters significantly.
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # Task 2

-- COMMAND ----------

-- small listing
SELECT c.city_name, n.nhood_name, COUNT(DISTINCT l.id) AS num_listings, COUNT(r.id) AS num_positive_reviews, ROUND(AVG(l.rating), 2) AS avg_rating, MAX(r.review_date) AS most_recent_review
FROM Listings_Small l
JOIN Hosts h ON l.host_id = h.id
JOIN Neighbourhoods n ON l.neighbourhood = n.id
JOIN Cities c ON l.city_id = c.id
JOIN Reviews_Small r ON l.id = r.listing_id
WHERE c.country = 'Australia' AND h.is_verified = 't' AND l.amenities LIKE '%Wifi%' AND (LOWER(r.comments) LIKE '%great place%'  OR LOWER(r.comments) LIKE '%clean place%')
GROUP BY c.city_name, n.nhood_name
HAVING COUNT(r.id) >= 650
ORDER BY num_positive_reviews DESC
LIMIT 10;

-- COMMAND ----------

-- medium listing
SELECT c.city_name, n.nhood_name, COUNT(DISTINCT l.id) AS num_listings, COUNT(r.id) AS num_positive_reviews, ROUND(AVG(l.rating), 2) AS avg_rating, MAX(r.review_date) AS most_recent_review
FROM Listings_Medium l
JOIN Hosts h ON l.host_id = h.id
JOIN Neighbourhoods n ON l.neighbourhood = n.id
JOIN Cities c ON l.city_id = c.id
JOIN Reviews_Medium r ON l.id = r.listing_id
WHERE c.country = 'Australia' AND h.is_verified = 't' AND l.amenities LIKE '%Wifi%' AND (LOWER(r.comments) LIKE '%great place%' OR LOWER(r.comments) LIKE '%clean place%')
GROUP BY c.city_name, n.nhood_name
HAVING COUNT(r.id) >= 650
ORDER BY num_positive_reviews DESC
LIMIT 10;

-- COMMAND ----------

-- large listing
SELECT c.city_name, n.nhood_name, COUNT(DISTINCT l.id) AS num_listings, COUNT(r.id) AS num_positive_reviews, ROUND(AVG(l.rating), 2) AS avg_rating, MAX(r.review_date) AS most_recent_review
FROM Listings_Large l
JOIN Hosts h ON l.host_id = h.id
JOIN Neighbourhoods n ON l.neighbourhood = n.id
JOIN Cities c ON l.city_id = c.id
JOIN Reviews_Large r ON l.id = r.listing_id
WHERE c.country = 'Australia' AND h.is_verified = 't' AND l.amenities LIKE '%Wifi%' AND (LOWER(r.comments) LIKE '%great place%' OR LOWER(r.comments) LIKE '%clean place%')
GROUP BY c.city_name, n.nhood_name
HAVING COUNT(r.id) >= 650
ORDER BY num_positive_reviews DESC
LIMIT 10;

-- COMMAND ----------

EXPLAIN SELECT c.city_name, n.nhood_name, COUNT(DISTINCT l.id) AS num_listings, COUNT(r.id) AS num_positive_reviews, ROUND(AVG(l.rating), 2) AS avg_rating, MAX(r.review_date) AS most_recent_review
FROM Listings_Large l
JOIN Hosts h ON l.host_id = h.id
JOIN Neighbourhoods n ON l.neighbourhood = n.id
JOIN Cities c ON l.city_id = c.id
JOIN Reviews_Large r ON l.id = r.listing_id
WHERE c.country = 'Australia' AND h.is_verified = 't' AND l.amenities LIKE '%Wifi%' AND (LOWER(r.comments) LIKE '%great place%' OR LOWER(r.comments) LIKE '%clean place%')
GROUP BY c.city_name, n.nhood_name
HAVING COUNT(r.id) >= 650
ORDER BY num_positive_reviews DESC
LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Runtime Results
-- MAGIC
-- MAGIC ### Databricks/Spark Runtimes
-- MAGIC | Dataset | Runtime |
-- MAGIC |---------|---------|
-- MAGIC | Small   | 1 s 990 ms        |
-- MAGIC | Medium  | 3 s 319 ms        |
-- MAGIC | Large   |  7 s 9 ms       |
-- MAGIC
-- MAGIC ### PostgreSQL Runtimes (TODO)
-- MAGIC | Dataset | Without index | With index |
-- MAGIC |---------|--------------|------------|
-- MAGIC | Small   |              |            |
-- MAGIC | Medium  |              |            |
-- MAGIC | Large   |              |            |
-- MAGIC
-- MAGIC ## Index Suggestions
-- MAGIC The query filters heavily on:
-- MAGIC - `Reviews.comments` (LIKE filter)
-- MAGIC - `Hosts.is_verified` (filter)
-- MAGIC - `Listings.amenities` (LIKE filter)
-- MAGIC - `Listings.neighbourhood` and `Listings.city_id` (joins)
-- MAGIC
-- MAGIC Suggested indexes for PostgreSQL:
-- MAGIC CREATE INDEX idx_listings_neighbourhood ON Listings(neighbourhood, city_id);
-- MAGIC CREATE INDEX idx_hosts_verified ON Hosts(id, is_verified);
-- MAGIC CREATE INDEX idx_reviews_listing ON Reviews(listing_id);
