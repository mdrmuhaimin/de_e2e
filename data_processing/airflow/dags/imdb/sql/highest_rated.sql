WITH y AS (SELECT EXTRACT(YEAR FROM movies_metadata.release_date) AS year FROM movies_metadata)
    SELECT COUNT(*) AS num_release, year FROM y GROUP BY year ORDER BY num_release DESC;

