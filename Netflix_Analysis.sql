Create database netflix_db;

use netflix_db;


create table netflix(
Show_id  varchar(5),
Typess  varchar(10),
Title  varchar(300),
Director Varchar(700),
Casts varchar(1500),
Country varchar(600),
Date_added Varchar(55),
Release_Date int,
Rating Varchar(50),
Duration Varchar(50),
Listed_In Varchar(300),
Descriptions varchar(500)
); 

select * from netflix;


-- 1)Count the Number of Movies vs TV Shows

select typess,count(typess) as Counts from netflix
group by Typess;


-- 2)Find the Most Common Rating for Movies and TV Shows

WITH RatingCounts AS (
    SELECT 
        typess,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY typess, rating
),
RankedRatings AS (
    SELECT 
        typess,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY typess ORDER BY rating_count DESC) AS ranks
    FROM RatingCounts
)
SELECT 
    typess,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE ranks = 1;


-- 3)List All Movies Released in a Specific Year (e.g., 2020)

select * from netflix;

select * from netflix where Typess = "Movie" and Release_date = 2020;

-- 4)Find the Top 5 Countries with the Most Content on Netflix

SELECT 
    a.country,
    COUNT(*) AS total_titles
FROM 
    Netflix a
GROUP BY 
    a.country
ORDER BY 
    total_titles DESC
LIMIT 5;

-- 5)Identify the Longest Movie

select * from netflix;

SELECT 
    Title, 
    duration 
FROM 
    netflix
WHERE 
    typess = 'Movie'
ORDER BY 
    duration 
    limit 1;

-- 6)Find Content Added in the Last 5 Years

SELECT 
    title, 
    typess, 
    date_added
FROM 
    Netflix
WHERE 
    date_added >= CURRENT_DATE - INTERVAL 5 YEAR;


-- 7)Find All Movies by Director 'Toshiya Shinohara'

Select * from netflix  where Director ="Toshiya Shinohara";


-- 8)List All TV Shows with More Than 5 Seasons

select * from netflix where typess ="TV Show" and Duration >= 5 ;

-- 9)Count the Number of Content Items in Each Genre


select * from netflix;

select count(Title) as Total_Content from netflix ;


-- 10)Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

select * from netflix;

SELECT 
    release_date,
    COUNT(*) AS total_content,
    ROUND(AVG(COUNT(*)) OVER (ORDER BY release_date), 2) AS avg_content_release
FROM 
    netflix
WHERE 
    country = 'India'
GROUP BY 
    release_date
ORDER BY 
    avg_content_release DESC
LIMIT 5;


-- 11)List All Movies that are Documentaries

select * from netflix;

select * from netflix where typess="Movie" and Listed_In = "Documentaries";


-- 12)Find All Content Without a Director

select * 
from netflix 
where Director IS NULL;

-- 13)Find How Many Movies Actor 'Vijay Sethupathi, Parthiban, Raashi Khanna' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Vijay Sethupathi, Parthiban, Raashi Khanna%'
  AND release_date > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
  
  -- 14)Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
  
  SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN descriptions LIKE '%kill%' OR descriptions LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;


