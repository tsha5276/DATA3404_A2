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

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT l.id, l.listing_name, COUNT(r.id) AS num_reviews, MAX(r.review_date) AS last_review_date
FROM Airbnb.Listings_Small l
JOIN Airbnb.Hosts h ON l.host_id = h.id
JOIN Airbnb.Reviews_Small r ON l.id = r.listing_id
JOIN Airbnb.Cities c ON l.city_id = c.id
WHERE c.city_name = 'Melbourne' AND h.is_superhost = 't' AND EXTRACT(YEAR FROM r.review_date) = 2025
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
-- MAGIC | Dataset | Without indexes |
-- MAGIC |---------|----------------|
-- MAGIC | Small   |           |                          
-- MAGIC | Medium  |           |                        
-- MAGIC | Large   |           |                         
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

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # Task 3
-- MAGIC

-- COMMAND ----------

-- MAGIC %python
-- MAGIC from pyspark.sql import functions as F
-- MAGIC import time
-- MAGIC
-- MAGIC # can this based on what size we testing
-- MAGIC scale = "small"
-- MAGIC city_name = "Melbourne"
-- MAGIC
-- MAGIC start_time = time.time()
-- MAGIC
-- MAGIC listings = spark.read.format("csv") \
-- MAGIC     .option("header", "true") \
-- MAGIC     .option("inferSchema", "true") \
-- MAGIC     .option("nullValue", "NULL") \
-- MAGIC     .option("dateFormat", "yyyy-MM-dd") \
-- MAGIC     .option("samplingRatio", "0.01") \
-- MAGIC     .load(f"/Volumes/workspace/data3404/airbnb/airbnb_listings-{scale}.csv")
-- MAGIC
-- MAGIC reviews = spark.read.format("csv") \
-- MAGIC     .option("header", "true") \
-- MAGIC     .option("inferSchema", "true") \
-- MAGIC     .option("nullValue", "NULL") \
-- MAGIC     .option("dateFormat", "yyyy-MM-dd") \
-- MAGIC     .option("samplingRatio", "0.01") \
-- MAGIC     .load(f"/Volumes/workspace/data3404/airbnb/airbnb_reviews-{scale}.csv")
-- MAGIC
-- MAGIC cities = spark.read.format("csv") \
-- MAGIC     .option("header", "true") \
-- MAGIC     .option("inferSchema", "true") \
-- MAGIC     .option("nullValue", "NULL") \
-- MAGIC     .load("/Volumes/workspace/data3404/airbnb/airbnb_cities.csv")
-- MAGIC
-- MAGIC neighbourhoods = spark.read.format("csv") \
-- MAGIC     .option("header", "true") \
-- MAGIC     .option("inferSchema", "true") \
-- MAGIC     .option("nullValue", "NULL") \
-- MAGIC     .load("/Volumes/workspace/data3404/airbnb/airbnb_neighbourhoods.csv")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC
-- MAGIC city_id = cities.filter(F.col("city_name") == city_name).first()["id"]
-- MAGIC
-- MAGIC city_listings = listings.filter(F.col("city_id") == city_id)
-- MAGIC
-- MAGIC # remove hotels and hostels
-- MAGIC city_listings = city_listings.filter(~F.lower(F.col("property_type")).like("%hotel%"))
-- MAGIC city_listings = city_listings.filter(~F.lower(F.col("property_type")).like("%hostel%"))
-- MAGIC
-- MAGIC city_listings.show(5)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # join reviews with our filtered listings
-- MAGIC reviews_listings = reviews.join(city_listings, reviews.listing_id == city_listings.id, "inner")
-- MAGIC
-- MAGIC # calculate booking duration - min 3 days max 21 days
-- MAGIC reviews_listings = reviews_listings.withColumn("duration", F.greatest(F.lit(3), F.col("minimum_nights")))
-- MAGIC reviews_listings = reviews_listings.withColumn("duration", F.least(F.lit(21), F.col("duration")))
-- MAGIC
-- MAGIC reviews_listings.select("listing_id", "minimum_nights", "duration").show(5)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # filter reviews to 2025 only
-- MAGIC reviews_2025 = reviews_listings.filter(F.col("review_date") >= '2025-01-01')
-- MAGIC reviews_2025 = reviews_2025.filter(F.col("review_date") < '2026-01-01')
-- MAGIC
-- MAGIC # count reviews per listing and keep useful columns
-- MAGIC reviews_grouped = reviews_2025.groupBy("listing_id", "minimum_nights", "duration", "neighbourhood", "rating", "property_type", "listing_name") \
-- MAGIC     .agg(F.count("*").alias("num_reviews"))
-- MAGIC
-- MAGIC # calculate occupied days using san fran
-- MAGIC reviews_grouped = reviews_grouped.withColumn("occupied_days", (F.col("num_reviews") / 0.67) * F.col("duration"))
-- MAGIC
-- MAGIC reviews_grouped.show(5)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # calculate occupancy rate (occupied days / 365), capped at 1.0 (100%)
-- MAGIC reviews_grouped = reviews_grouped.withColumn("occupancy_rate", F.col("occupied_days") / F.lit(365.0))
-- MAGIC reviews_grouped = reviews_grouped.withColumn("occupancy_rate", F.least(F.lit(1.0), F.col("occupancy_rate")))
-- MAGIC
-- MAGIC reviews_grouped.select("listing_id", "listing_name", "occupied_days", "occupancy_rate").show(5)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # join with neighbourhoods to get neighbourhood names
-- MAGIC occupancy_with_nhood = reviews_grouped.join(neighbourhoods, reviews_grouped.neighbourhood == neighbourhoods.id, "inner")
-- MAGIC
-- MAGIC # group by neighbourhood and calculate average occupancy rate
-- MAGIC top_neighbourhoods = occupancy_with_nhood.groupBy("nhood_name") \
-- MAGIC     .agg(
-- MAGIC         F.count("listing_id").alias("num_listings"),
-- MAGIC         F.avg("occupancy_rate").alias("avg_occupancy_rate")
-- MAGIC     )
-- MAGIC
-- MAGIC # sort by average occupancy rate descending
-- MAGIC top_neighbourhoods = top_neighbourhoods.orderBy(F.desc("avg_occupancy_rate"), F.asc("nhood_name"))
-- MAGIC top_neighbourhoods = top_neighbourhoods.limit(10)
-- MAGIC
-- MAGIC top_neighbourhoods.show()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC from pyspark.sql.window import Window
-- MAGIC
-- MAGIC # rank listings within each neighbourhood by occupancy rate
-- MAGIC window = Window.partitionBy("nhood_name").orderBy(F.desc("occupancy_rate"), F.asc("listing_name"))
-- MAGIC occupancy_with_nhood = occupancy_with_nhood.withColumn("rank", F.rank().over(window))
-- MAGIC
-- MAGIC # keep only top 3 listings per neighbourhood
-- MAGIC top3_listings = occupancy_with_nhood.filter(F.col("rank") <= 3)
-- MAGIC
-- MAGIC # keep only neighbourhoods that are in our top 10
-- MAGIC top_nhood_names = [row["nhood_name"] for row in top_neighbourhoods.collect()]
-- MAGIC top3_listings = top3_listings.filter(F.col("nhood_name").isin(top_nhood_names))
-- MAGIC
-- MAGIC top3_listings.select("nhood_name", "listing_name", "property_type", "rating", "occupancy_rate").show()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # THIS IS ALL AI --> need to change
-- MAGIC top3_formatted = top3_listings.groupBy("nhood_name") \
-- MAGIC     .agg(
-- MAGIC         F.collect_list(
-- MAGIC             F.struct("listing_name", "property_type", "rating", "occupancy_rate")
-- MAGIC         ).alias("top3")
-- MAGIC     )
-- MAGIC
-- MAGIC # Join back with nhood_occupancy to get num_listings and avg_occupancy_rate
-- MAGIC final = nhood_occupancy.join(top3_formatted, "nhood_name")
-- MAGIC
-- MAGIC # Format the output string
-- MAGIC def format_row(row):
-- MAGIC     listings_str = ", ".join([
-- MAGIC         f"({l['listing_name']}, {l['property_type']}, {l['rating']}, {round(l['occupancy_rate'], 4)})"
-- MAGIC         for l in row['top3'][:3]
-- MAGIC     ])
-- MAGIC     return f"{row['nhood_name']}\t{row['num_listings']}\t{round(row['avg_occupancy_rate'], 4)}\t[{listings_str}]"
-- MAGIC
-- MAGIC for row in final.orderBy(F.desc("avg_occupancy_rate"), F.asc("nhood_name")).collect():
-- MAGIC     print(format_row(row))
-- MAGIC
-- MAGIC end_time = time.time()
-- MAGIC print(f"Total runtime: {round(end_time - start_time, 2)} seconds")
-- MAGIC
