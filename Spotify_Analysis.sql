create database spotify_db;

use spotify_db;



select * from spotify;


-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify where stream > '1000000000';

-- 2. List all albums along with their respective artists.

select 
distinct Album,Artist
from spotify
order by 1;
-- 3. Get the total number of comments for tracks where `licensed = TRUE`.

select sum(Comments) as Total_Comments from Spotify where Licensed = "true";
-- 4. Find all tracks that belong to the album type `single`.

select track from Spotify Where Album_type="single";

-- 5. Count the total number of tracks by each artist

Select Artist,Count(Track) as Total_tracks 
from spotify
group by Artist ;

select * from spotify;

-- 6. Calculate the average danceability of tracks in each album.

Select album ,avg(danceability) as Average_Danceability
 from spotify
 Group by album;

-- 7. Find the top 5 tracks with the highest energy values.

select track,Energy from spotify
order by energy DESC
limit 5;
-- 8. List all tracks along with their views and likes where `official_video = TRUE`.

Select track,Views,Likes 
from spotify 
where official_video = 'True';

-- 9. For each album, calculate the total views of all associated tracks.

select * from spotify;

select album, sum(views) as Total_Views
from spotify
group by Album; 


-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.

Select * from spotify;

Select Track,most_playedon 
from spotify
where most_playedon = 'Spotify' > 'Youtube' ;


-- 11. Find the top 3 most-viewed tracks for each artist using window functions.

SELECT
  Artist,
  Track,
  views
FROM (
  SELECT
    Artist,
    Track,
    views,
    ROW_NUMBER() OVER 
    (
      PARTITION BY Artist
      ORDER BY views DESC
    ) AS track_rank
  FROM
    spotify
) ranked_tracks
WHERE
  track_rank >= 3;

-- 12. Write a query to find tracks where the liveness score is above the average.

SELECT
  track,
  liveness
FROM
  spotify
WHERE
  liveness > (
    SELECT AVG(liveness) FROM spotify
  );

-- 13. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**

WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC

-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT
  track,
  energy,
  liveness,
  (energy / liveness) AS energy_to_liveness_ratio
FROM
  spotify
WHERE
  (energy / liveness) > 1.2;


-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT
  track,
  views,
  likes,
  SUM(likes) OVER (
    ORDER BY views
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_likes
FROM
  Spotify;