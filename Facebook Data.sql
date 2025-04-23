create database facebook;


select * from facebook;

-- 1)Total Cost--

SELECT SUM(CAST(REPLACE(Total_Cost, '$', '') AS DECIMAL(10,2))) AS Total_Cost
FROM facebook;

-- 2)Total Impression --

SELECT SUM(Total_Impressions_Expression) AS Total_Impressions
FROM facebook;

-- 3)Total Links Click --

SELECT SUM(Total_Link_Clicks_Expression) AS Total_Link_Clicks
FROM facebook;

-- 4)Total Page Likes--

SELECT SUM(Total_Page_Likes_Expression) AS Total_Page_Likes
FROM facebook;

-- 5)Total People Reached --

select sum(Total_People_reached) as Total_People_Reached from facebook;


-- 6)Total Post(Comments, Reaction, Share)--

SELECT 
    SUM(Total_Post_Reactions) AS Total_Reactions,
    SUM(Total_Post_Shares) AS Total_Shares,
    SUM(Post_Comments) AS Total_Comments,  
    (SUM(Total_Post_Reactions) + SUM(Total_Post_Shares) + SUM(Post_Comments)) AS Total_Post
FROM facebook;

-- 7)Total Social Interactions--

select sum(Total_Social_Interactions) as Total_Social_Interactions from facebook;

-- 8)Total Website(Leads, Purchase, Value)--

SELECT 
    SUM(Total_Website_Leads) AS Total_Website_Leads,
    SUM(Website_Purchases) AS Total_Website_Purchases,
    SUM(Total_Website_Purchases_Value_Expression) AS Total_Website_Value 
FROM facebook;

-- 9)Total Campaign--

select count(Campaign_Name) as Total_Campaign from facebook;

-- 10)Avg Purchase Value : [Total Website Purchases Value] / [Total Website Purchases]--
    
    SELECT 
    SUM(Total_Website_Purchases_Value_Expression) / NULLIF(SUM(Website_Purchases), 0) AS Avg_Purchase_Value
FROM facebook;

-- 11)Cost per People Reached : [Total Cost] / [Total People Reached]

SELECT 
 SUM(CAST(REPLACE(Total_Cost, '$', '') AS DECIMAL(10,2))) / NULLIF(SUM(Total_People_Reached), 0) AS Cost_Per_People_Reached
FROM facebook;

-- 12)CPA (Cost per Action) : [Total Cost] / [Total Social Interactions]

SELECT 
    SUM(CAST(REPLACE(Total_Cost, '$', '') AS DECIMAL(10,2))) / NULLIF(SUM(Total_Social_Interactions), 0) AS CPA
FROM facebook;

-- 13)CPC (Cost per Click) : [Total Cost] / [Total Link Clicks]

SELECT 
  SUM(CAST(REPLACE(Total_Cost, '$', '') AS DECIMAL(10,2))) / NULLIF(SUM(Total_Link_Clicks), 0) AS CPC
FROM facebook;

-- 14)CPL (Cost per Lead) : [Total Cost] / [Total Website Leads]

SELECT 
SUM(CAST(REPLACE(Total_Cost, '$', '') AS DECIMAL(10,2))) / NULLIF(SUM(Total_Website_Leads), 0) AS CPL
FROM facebook;

-- 15)CPM (Cost per 1'000 impressions) : [Total Cost] / [Total K. Impressions]

SELECT 
SUM(CAST(REPLACE(Total_Cost, '$', '') AS DECIMAL(10,2))) / NULLIF(SUM(Total_Impressions_Expression), 0) * 1000 AS CPM
FROM facebook;

-- 16)CTR (Click-Through-Rate) : [Total Link Clicks] / [Total Impressions]

SELECT 
    (SUM(Total_Link_Clicks_Expression) / NULLIF(SUM(Total_Impressions_Expression), 0)) * 100 AS CTR
FROM facebook;

-- 17)LTR (Lead-Through-Rate) : [Total Website Leads] / [Total Link Clicks]

SELECT 
    (SUM(Total_Website_Leads) / NULLIF(SUM(Total_Link_Clicks_Expression), 0)) * 100 AS LTR
FROM facebook;

-- 18)Page Likes per Impression : [Total Page Likes] / [Total Impressions]

SELECT 
    SUM(Total_Page_Likes_Expression) / NULLIF(SUM(Total_Impressions_Expression), 0) AS Page_Likes_Per_Impression
FROM facebook;

-- 19)Post Comments per Impression : [Total Post Comments] / [Total Impressions]

SELECT 
    SUM(Post_Comments) / NULLIF(SUM(Total_Impressions_Expression), 0) AS Post_Comments_Per_Impression
FROM facebook;

-- 20)Post Reactions per Impression : [Total Post Reactions] / [Total Impressions]

SELECT 
    SUM(Total_Post_Reactions) / NULLIF(SUM(Total_Impressions_Expression), 0) AS Post_Reactions_Per_Impression
FROM facebook;

-- 21)Post Shares per Impression : [Total Post Shares] / [Total Impressions]

SELECT 
    SUM(Total_Post_Shares) / NULLIF(SUM(Total_Impressions_Expression), 0) AS Post_Shares_Per_Impression
FROM facebook;

/*
-- 22)ROI % : [Total Margin] / [Total Cost]

SELECT 
    (SUM(Total_Margin) / NULLIF(SUM(CAST(REPLACE(REPLACE(Total_Cost, '$', ''), ',', '') AS DECIMAL(10,2))), 0)) * 100 AS ROI_Percentage
FROM facebook;

*/

-- 23)Social Interaction per Impression : [Total Social Interactions] / [Total Impressions]

SELECT 
    SUM(Total_Social_Interactions) / NULLIF(SUM(Impressions), 0) AS Social_Interaction_Per_Impression
FROM facebook;


-- 24)Total Margin : [Total Website Purchases Value] - [Total Cost]

SELECT 
    SUM(Total_Website_Purchases_Value_Expression) - SUM(CAST(REPLACE(Total_Cost, '$', '') AS DECIMAL(10,2))) AS Total_Margin
FROM facebook;