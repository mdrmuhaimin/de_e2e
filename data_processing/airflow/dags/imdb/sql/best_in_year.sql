WITH 
    rating_data AS (
        SELECT original_title, EXTRACT(YEAR FROM movies_metadata.release_date) AS year, vote_average FROM movies_metadata
    ),
    max_rating AS (
        SELECT 
            MAX(vote_average) as max_rating, 
            EXTRACT(YEAR FROM movies_metadata.release_date) AS year 
        FROM movies_metadata
        GROUP BY year
    )
        SELECT rating_data.*, max_rating.max_rating FROM rating_data
        JOIN max_rating 
        ON rating_data.year = max_rating.year
        AND rating_data.vote_average = max_rating.max_rating;
    -- SELECT COUNT(*) AS num_release, year FROM y GROUP BY year ORDER BY num_release DESC;

