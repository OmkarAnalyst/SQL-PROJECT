create database Linkdin;

select * from Linkdin;

-- 1)Total Views --

select sum(views) as TotalViews from linkdin;

-- 2)Total Reactions--

select sum(Reactions) as Total_Reactions from linkdin;

-- 3)Total Comments--

select sum(Comments) as Total_Comments from linkdin;

-- 4)Total Reposts --

select sum(Reposts) as Total_Reposts from linkdin;

-- 5)Average Engagement per Post --

SELECT
    (SUM(reactions) + SUM(comments) + SUM(reposts)) / COUNT(Link_to_Post) AS average_engagement_per_post
FROM
    linkdin;
    
    
-- 6)Follower Growth Over Time --

WITH Follower_Changes AS (
    SELECT 
        Date,
        Followers,
        LAG(Followers) OVER (ORDER BY Date) AS Previous_Followers
    FROM linkdin
)
SELECT 
    Date,
    Followers,
    (Followers - COALESCE(Previous_Followers, Followers)) AS Net_Follower_Growth
FROM Follower_Changes
ORDER BY Date;

-- 7)Engagement Rate --

SELECT 
    Topic,
    COUNT(*) AS Total_Posts,
    SUM(Comments) AS Total_Comments,
    SUM(Reactions) AS Total_Reactions,
    SUM(Reposts) AS Total_Reposts,
    SUM(Views) AS Total_Views,
    SUM(Comments + Reactions + Reposts) AS Total_Engagements,
    (SUM(Comments + Reactions + Reposts) * 100.0 / NULLIF(SUM(Views), 0)) AS Engagement_Rate
FROM linkdin
GROUP BY Topic
ORDER BY Engagement_Rate DESC;

-- 8)Top Performing Posts --

SELECT 
    Link_to_Post,
    views,
    reactions,
    comments
FROM 
    linkdin
ORDER BY 
    views DESC
LIMIT 10; 

-- 9)Engagement by Topic --

SELECT 
    Topic,
    COUNT(*) AS Total_Posts,
    SUM(Comments) AS Total_Comments,
    SUM(Reactions) AS Total_Reactions,
    SUM(Reposts) AS Total_Reposts,
    SUM(Views) AS Total_Views,
    AVG(Comments) AS Avg_Comments,
    AVG(Reactions) AS Avg_Reactions,
    AVG(Reposts) AS Avg_Reposts,
    AVG(Views) AS Avg_Views
FROM linkdin
GROUP BY Topic
ORDER BY Total_Views DESC;

-- 10)Reposts/Views Ratio --

SELECT 
    Link_to_Post,
    views,
    reposts,
    CASE 
        WHEN views = 0 THEN 0  -- To avoid division by zero
        ELSE reposts / NULLIF(views, 0)
    END AS reposts_to_views_ratio
FROM 
    linkdin
ORDER BY 
    reposts_to_views_ratio DESC;

-- 11)Comments/Views Ratio --

SELECT 
    Link_to_post,
    views,
    comments,
    CASE 
        WHEN views = 0 THEN 0  -- To avoid division by zero
        ELSE comments / NULLIF(views, 0)
    END AS comments_to_views_ratio
FROM 
    linkdin
ORDER BY 
    comments_to_views_ratio DESC;

-- 12)Peak Posting Times --
-- Peak Posting Times (Posts per Day of the Week) --
/*
SELECT 
    DAYOFWEEK(created_at) AS day_of_week,
    COUNT(Link_to_post) AS posts_count
FROM 
      linkdin
GROUP BY 
    day_of_week
ORDER BY 
    posts_count DESC;
*/

-- 13)Posts per Topic --

SELECT 
    topic,
    COUNT(Link_to_post) AS posts_count
FROM 
    linkdin
GROUP BY 
    topic
ORDER BY 
    posts_count DESC;



