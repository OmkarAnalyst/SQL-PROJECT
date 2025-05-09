 -- Electric Vehicle (EV) Sales and Adoption 

use vehicle;

select * from test;

select * from train;

-- 1)List distinct vehicle brands:

select distinct(brand) from test;

-- 2)Find the total number of vehicles sold:

select sum(units_sold) as Total_Number_of_Vehicles_Sold From train;

select brand ,sum(units_sold) as Total_Number_of_Vehicles_Sold 
From train
Group by brand;

-- 3)Get the average revenue per sale:

select * from train;

-- 4)Filter for vehicles with fast charging:

select * from test where Fast_Charging_Option = "Yes";

-- 5)Total revenue by region:

select Region,sum(Revenue) as Total_Revenue_By_Region
from train
Group by Region; 

-- 6)Top 3 brands by total units sold:

select brand,sum(units_Sold) as Total_units_sold
from train
Group by brand
order by Total_units_sold desc
limit 3;

-- 7)Monthly average units sold:

select * from train;

select extract(month from Dates) AS MONTHS, avg(Units_Sold) as Average_units_sold 
from train
GROUP BY dates;

-- 8)Compare revenue between customer segments:

select * from train;

select Customer_Segment,avg(Revenue) as Revenue 
from train
Group by Customer_Segment
order by Revenue desc;


-- 9)Find models with above-average battery capacity:

select * from train;

select Model,Battery_Capacity_kWh 
from train
where Battery_Capacity_kWh > (
select avg(Battery_Capacity_kWh) as Average_Battery_Capacity
from train 
);


-- 10)Which vehicle type has the highest average revenue per unit sold? -- Doubt Check

select * from train;

select vehicle_Type,avg(Revenue/ units_sold) as Average_Revenue
from train
group By vehicle_Type
order by Average_Revenue Desc;

-- 11)Find the top 3 models with the highest total revenue in 'North America'.

select * from train;

select Model,sum(Revenue) as Total_revenue 
from train 
where Region = "North America"
group by Model
order by Total_revenue desc
limit 3;

-- 12)Compare average discount percentage for vehicles with and without fast charging.

select * from train; 

select fast_Charging_option , avg(Discount_Percentage) as Average_Discount_Percentage
from train
group by Fast_Charging_Option;


-- 13)Which brand has the most models being sold (based on distinct models)

select * from train;

select brand , count(distinct(model)) as Model_Sold
from train
group by brand
order by model_sold desc;

-- 14)List the average battery capacity by customer segment and region.

select * from train;

select customer_segment,region,avg(Battery_capacity_kWh) as Average_Battery_Capacity
from train
group by Customer_Segment,region;

-- 15)Find the revenue contribution (%) of each brand.

select * from train;

SELECT Brand,
       SUM(Revenue) * 100.0 / (SELECT SUM(Revenue) FROM train) AS Revenue_Percentage
FROM train
GROUP BY Brand
ORDER BY Revenue_Percentage DESC;

-- 16)Identify any month where total units sold dropped compared to the previous month.

WITH MonthlySales AS (
  SELECT 
    DATE_FORMAT(Dates, '%Y-%m') AS Month,
    SUM(Units_Sold) AS Total_Units_Sold
  FROM train
  GROUP BY Month
),
SalesWithLag AS (
  SELECT 
    Month,
    Total_Units_Sold,
    LAG(Total_Units_Sold) OVER (ORDER BY Month) AS Prev_Month_Units_Sold
  FROM MonthlySales
)
SELECT *
FROM SalesWithLag
WHERE Total_Units_Sold < Prev_Month_Units_Sold;



-- 17)Find all models that have sold more than the average number of units sold across all models.


select * from train;

SELECT Model, SUM(Units_Sold) AS Total_Sold
FROM train
GROUP BY Model
HAVING SUM(Units_Sold) > (
  SELECT AVG(Units_Sold)
  FROM train
);

-- 18)What is the average revenue per vehicle type and brand combination?

SELECT Vehicle_Type, Brand, AVG(Revenue) AS Avg_Revenue
FROM train
GROUP BY Vehicle_Type, Brand;

-- 19)Which combination of brand and model has the highest revenue per unit sold?

SELECT Brand, Model, SUM(Revenue) / SUM(Units_Sold) AS Revenue_Per_Unit
FROM train
GROUP BY Brand, Model
ORDER BY Revenue_Per_Unit DESC
LIMIT 1;


