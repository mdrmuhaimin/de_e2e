WITH popular_gen AS 
(
    WITH yeargen AS 
    (
        SELECT
            EXTRACT(YEAR FROM movies_metadata.release_date) AS year,
            json_object ->> 'name' AS g_name
        FROM
            movies_metadata,
            jsonb_array_elements(genres::JSONB) AS json_object
    )
        SELECT 
            year,
            g_name,
            count(*)
            OVER (PARTITION BY year, g_name) as count
            -- OVER (PARTITION BY g_name) as C
        FROM yeargen
)
SELECT DISTINCT * FROM popular_gen ORDER BY year DESC, count DESC;
