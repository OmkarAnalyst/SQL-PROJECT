create database user_db;

select * from user_submission;


-- 1)List All Distinct Users and Their Stats

select distinct(username) as unique_user, 
sum(points) as Total_Points_Earned,
count(submitted_at) as Submission_count
from user_submission
group by username;


-- 2)Calculate the Daily Average Points for Each User

select
username,
DATE(Submitted_at) AS daily,
round(avg(points)) as avg_points
from user_submission
group by username,Date(submitted_at);


-- 3)Find the Top 3 Users with the Most Correct Submissions for Each Day

WITH daily_submissions AS (
    SELECT 
        Date(submitted_at) AS daily,
        username,
        SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions
    FROM user_submission
    GROUP BY 1, 2
),
users_rank AS (
    SELECT 
        daily,
        username,
        correct_submissions,
        DENSE_RANK() OVER(PARTITION BY daily ORDER BY correct_submissions DESC) AS ranks
    FROM daily_submissions
)
SELECT 
    daily,
    username,
    correct_submissions
FROM users_rank
WHERE ranks <= 3;


-- 4)Find the Top 5 Users with the Highest Number of Incorrect Submissions

select
username,
sum(case when points < 0 then 1 Else 0 End) as incorrect_Submissions,
sum(case when points > 0 then 1 Else 0 End) as correct_submissions,
sum(case when points < 0 then points else 0 End) as incorrect_submission_points_earned,
sum(case when points > 0 then points else 0 End) as correct_submission_points_earned,
sum(points) as points_earned
from user_submission
group by username
order by incorrect_submissions desc;
-
-- 5) Find the Top 10 Performers for Each Week
 
SELECT *  
FROM (
    SELECT 
        EXTRACT(WEEK FROM submitted_at) AS week_no,
        username,
        SUM(points) AS total_points_earned,
        DENSE_RANK() OVER(PARTITION BY EXTRACT(WEEK FROM submitted_at) ORDER BY SUM(points) DESC) AS ranks
    FROM user_submission
    GROUP BY 1, 2
    ORDER BY week_no, total_points_earned DESC
)
WHERE ranks <= 10;
