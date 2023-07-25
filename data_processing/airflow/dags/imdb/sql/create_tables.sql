DROP TABLE IF EXISTS movies_metadata;
-- DROP TABLE IF EXISTS ratings;
----------------------------------------
CREATE TABLE IF NOT EXISTS movies_metadata (
    original_title VARCHAR,
    budget BIGINT,
    genres JSONB,
    id INT,
    imdb_id VARCHAR,
    release_date DATE,
    revenue BIGINT,
    vote_average FLOAT
);

----------------------------------------

CREATE TABLE IF NOT EXISTS ratings (
    userId INT,
    movieId INT,
    rating FLOAT,
    t_stamp TIMESTAMP
);