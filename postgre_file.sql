-- TASK 1
-- Find the top-10 listings in Melbourne (by id and name) by a superhost which received the most reviews in 2025, as well as the date of the latest review per each listing.

--  small
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT l.id, l.listing_name, COUNT(r.id) AS num_reviews, MAX(r.review_date) AS last_review_date
FROM Airbnb.Listings_Small l
JOIN Airbnb.Hosts h ON l.host_id = h.id
JOIN Airbnb.Reviews_Small r ON l.id = r.listing_id
JOIN Airbnb.Cities c ON l.city_id = c.id
WHERE c.city_name = 'Melbourne' AND h.is_superhost = 't' AND (r.review_date >= '2025-01-01' AND r.review_date < '2026-01-01')
GROUP BY l.id, l.listing_name
ORDER BY num_reviews DESC
LIMIT 10;

--medium 
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT l.id, l.listing_name, COUNT(r.id) AS num_reviews, MAX(r.review_date) AS last_review_date
FROM Airbnb.Listings_Medium l
JOIN Airbnb.Hosts_medium h ON l.host_id = h.id
JOIN Airbnb.Reviews_Medium r ON l.id = r.listing_id
JOIN Airbnb.Cities c ON l.city_id = c.id
WHERE c.city_name = 'Melbourne' AND h.is_superhost = 't' AND (r.review_date >= '2025-01-01' AND r.review_date < '2026-01-01')   
GROUP BY l.id, l.listing_name
ORDER BY num_reviews DESC
LIMIT 10;

-- large
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT l.id, l.listing_name, COUNT(r.id) AS num_reviews, MAX(r.review_date) AS last_review_date
FROM Airbnb.Listings_Large l
JOIN Airbnb.Hosts h ON l.host_id = h.id
JOIN Airbnb.Reviews_Large r ON l.id = r.listing_id
JOIN Airbnb.Cities c ON l.city_id = c.id
WHERE c.city_name = 'Melbourne' AND h.is_superhost = 't' AND (r.review_date >= '2025-01-01' AND r.review_date < '2026-01-01')
GROUP BY l.id, l.listing_name
ORDER BY num_reviews DESC
LIMIT 10;

-- INDEXES:

-- FIRST INDEX:
CREATE INDEX IF NOT EXISTS idx_reviews_small_listing_date  ON Airbnb.Reviews_Small(listing_id, review_date);
CREATE INDEX IF NOT EXISTS idx_reviews_medium_listing_date ON Airbnb.Reviews_Medium(listing_id, review_date);
CREATE INDEX IF NOT EXISTS idx_reviews_large_listing_date  ON Airbnb.Reviews_Large(listing_id, review_date);

-- SECOND INDEX:
CREATE INDEX IF NOT EXISTS idx_listings_small_host_city  ON Airbnb.Listings_Small(host_id, city_id);
CREATE INDEX IF NOT EXISTS idx_listings_medium_host_city ON Airbnb.Listings_Medium(host_id, city_id);
CREATE INDEX IF NOT EXISTS idx_listings_large_host_city  ON Airbnb.Listings_Large(host_id, city_id);

-- THIRD INDEX:
CREATE INDEX IF NOT EXISTS idx_hosts_superhost        ON Airbnb.Hosts(is_superhost, id);
CREATE INDEX IF NOT EXISTS idx_hosts_small_superhost  ON Airbnb.Hosts_small(is_superhost, id);
CREATE INDEX IF NOT EXISTS idx_hosts_medium_superhost ON Airbnb.Hosts_medium(is_superhost, id);

-- Create Index, run the EXPLAIN ANALYZE, and then drop the index to move onto to the next one. 
-- Do DISCARD ALL; after dropping the index to clear the buffer cache before each timed run.


-- FIRST INDEX:
DROP INDEX Airbnb.idx_reviews_small_listing_date;
DROP INDEX Airbnb.idx_reviews_medium_listing_date;
DROP INDEX Airbnb.idx_reviews_large_listing_date;

-- SECOND INDEX:
DROP INDEX Airbnb.idx_listings_small_host_city;
DROP INDEX Airbnb.idx_listings_medium_host_city;
DROP INDEX Airbnb.idx_listings_large_host_city;


-- THIRD INDEX:
DROP INDEX Airbnb.idx_hosts_superhost;
DROP INDEX Airbnb.idx_hosts_small_superhost;
DROP INDEX Airbnb.idx_hosts_medium_superhost;


-- Task 2

/* =========================================================
   SMALL DATASET QUERY
   ========================================================= */
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.city_name,
    n.nhood_name,
    COUNT(DISTINCT l.id) AS num_listings,
    COUNT(r.id) AS num_positive_reviews,
    ROUND(AVG(l.rating)::numeric, 2) AS avg_rating,
    MAX(r.review_date) AS most_recent_review
FROM Airbnb.Listings_Small l
JOIN Airbnb.Hosts h
    ON l.host_id = h.id
JOIN Airbnb.Neighbourhoods n
    ON l.neighbourhood = n.id
JOIN Airbnb.Cities c
    ON l.city_id = c.id
JOIN Airbnb.Reviews_Small r
    ON l.id = r.listing_id
WHERE
    c.country = 'Australia'
    AND h.is_verified = 't'
    AND 'Wifi' = ANY(l.amenities)
    AND (
        r.comments ILIKE '%great place%'
        OR r.comments ILIKE '%clean place%'
    )
GROUP BY
    c.city_name,
    n.nhood_name
HAVING COUNT(r.id) >= 650
ORDER BY num_listings DESC
LIMIT 10;

/* =========================================================
   MEDIUM DATASET QUERY
   ========================================================= */
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.city_name,
    n.nhood_name,
    COUNT(DISTINCT l.id) AS num_listings,
    COUNT(r.id) AS num_positive_reviews,
    ROUND(AVG(l.rating)::numeric, 2) AS avg_rating,
    MAX(r.review_date) AS most_recent_review
FROM Airbnb.Listings_Medium l
JOIN Airbnb.Hosts h
    ON l.host_id = h.id
JOIN Airbnb.Neighbourhoods n
    ON l.neighbourhood = n.id
JOIN Airbnb.Cities c
    ON l.city_id = c.id
JOIN Airbnb.Reviews_Medium r
    ON l.id = r.listing_id
WHERE
    c.country = 'Australia'
    AND h.is_verified = 't'
    AND 'Wifi' = ANY(l.amenities)
    AND (
        r.comments ILIKE '%great place%'
        OR r.comments ILIKE '%clean place%'
    )
GROUP BY
    c.city_name,
    n.nhood_name
HAVING COUNT(r.id) >= 650
ORDER BY num_listings DESC
LIMIT 10;

/* =========================================================
   LARGE DATASET QUERY
   ========================================================= */
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    c.city_name,
    n.nhood_name,
    COUNT(DISTINCT l.id) AS num_listings,
    COUNT(r.id) AS num_positive_reviews,
    ROUND(AVG(l.rating)::numeric, 2) AS avg_rating,
    MAX(r.review_date) AS most_recent_review
FROM Airbnb.Listings_Large l
JOIN Airbnb.Hosts h
    ON l.host_id = h.id
JOIN Airbnb.Neighbourhoods n
    ON l.neighbourhood = n.id
JOIN Airbnb.Cities c
    ON l.city_id = c.id
JOIN Airbnb.Reviews_Large r
    ON l.id = r.listing_id
WHERE
    c.country = 'Australia'
    AND h.is_verified = 't'
    AND 'Wifi' = ANY(l.amenities)
    AND (
        r.comments ILIKE '%great place%'
        OR r.comments ILIKE '%clean place%'
    )
GROUP BY
    c.city_name,
    n.nhood_name
HAVING COUNT(r.id) >= 650
ORDER BY num_listings DESC
LIMIT 10;


-- 1. The Join Accelerators (Standard B-Tree for Reviews)
CREATE INDEX idx_reviews_small_listing_id ON Airbnb.Reviews_Small(listing_id);
CREATE INDEX idx_reviews_medium_listing_id ON Airbnb.Reviews_Medium(listing_id);
CREATE INDEX idx_reviews_large_listing_id ON Airbnb.Reviews_Large(listing_id);

-- 2. Index (GIN Comments trigram)
CREATE INDEX idx_reviews_large_comments_trgm ON Airbnb.Reviews_Large USING gin(comments gin_trgm_ops);


-- 3. Trigrams for the Reviews tables
CREATE INDEX idx_reviews_small_comments_trgm 
    ON Airbnb.Reviews_Small USING GIN (comments gin_trgm_ops);

CREATE INDEX idx_reviews_medium_comments_trgm 
    ON Airbnb.Reviews_Medium USING GIN (comments gin_trgm_ops);

CREATE INDEX idx_reviews_large_comments_trgm 
    ON Airbnb.Reviews_Large USING GIN (comments gin_trgm_ops);

-- 4. Trigrams for the Listings tables
CREATE INDEX idx_listings_small_amenities_gin 
    ON Airbnb.Listings_Small USING GIN (amenities);

CREATE INDEX idx_listings_medium_amenities_gin 
    ON Airbnb.Listings_Medium USING GIN (amenities);

CREATE INDEX idx_listings_large_amenities_gin 
    ON Airbnb.Listings_Large USING GIN (amenities);

DROP INDEX IF EXISTS Airbnb.idx_reviews_small_listing_id;
DROP INDEX IF EXISTS Airbnb.idx_reviews_medium_listing_id;
DROP INDEX IF EXISTS Airbnb.idx_reviews_large_listing_id;

DROP INDEX IF EXISTS Airbnb.idx_hosts_verified_partial;

DROP INDEX IF EXISTS Airbnb.idx_reviews_small_comments_trgm;
DROP INDEX IF EXISTS Airbnb.idx_reviews_medium_comments_trgm;
DROP INDEX IF EXISTS Airbnb.idx_reviews_large_comments_trgm;

DROP INDEX IF EXISTS Airbnb.idx_listings_small_amenities_gin;
DROP INDEX IF EXISTS Airbnb.idx_listings_medium_amenities_gin;
DROP INDEX IF EXISTS Airbnb.idx_listings_large_amenities_gin;

-- Examine size:

SELECT 
    t.relname AS table_name, 
    i.relname AS index_name, 
    pg_size_pretty(pg_relation_size(i.oid)) AS index_size
FROM pg_class t
JOIN pg_index ix ON t.oid = ix.indrelid
JOIN pg_class i ON i.oid = ix.indexrelid
WHERE t.relname LIKE 'listings_%' OR t.relname LIKE 'reviews_%' OR t.relname = 'hosts'
ORDER BY pg_relation_size(i.oid) DESC;
