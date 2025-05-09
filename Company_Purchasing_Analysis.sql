-- Company Purchasing 

use company_purchase;


select * from spend_analysis;
 
-- 1)List distinct categories of items:

select distinct(Category) as Distinct_category from spend_analysis;

-- 2)Count total number of transactions

select count(TransactionID) as Total_transactions from spend_analysis;

-- 3)Calculate the total spending

select Buyer, sum(totalCost) as Total_Spending 
from spend_analysis
group by Buyer
order by Total_Spending;

-- 4)Get all purchases made by a specific buyer (e.g., 'Kelly Joseph'):

select * from spend_analysis where Buyer = "Kelly Joseph";

-- 5)Find the total cost per category:

select * from spend_analysis;

select Category,sum(Totalcost) as Total_Cost_Per_Category
from spend_analysis
group by Category
order by total_Cost_Per_Category desc;


-- 6)List suppliers and the number of purchases from each:


select Supplier,count(*) as Number_of_Purchase
from spend_analysis
Group by supplier;


-- 7)Get the average unit price for each item

select * from spend_analysis;

select ItemName,avg(UnitPrice) as Average_Unit_Price
from spend_analysis
group by ItemName;


-- 8)Find purchases with total cost greater than the average total cost

select * from spend_analysis;

select * from spend_analysis 
where TotalCost > (
select avg(TotalCost)  
from spend_analysis );

-- 9)Show total spending per month:

SELECT DATE_FORMAT(PurchaseDate, '%Y-%m') AS Month, SUM(TotalCost) AS Monthly_Spend
FROM spend_analysis
GROUP BY Month
ORDER BY Month;

-- 10)Find the top 3 most expensive purchases

select buyer,sum(totalCost) as Total_Cost
from spend_analysis
group by buyer
order by total_Cost Desc
limit 3;

-- 11)Which buyer spent the most in total

select Buyer,sum(TotalCost) as Total_Spending 
from spend_analysis
Group by Buyer
order by Total_Spending Desc;


-- 12)Which item has been purchased the most in total quantity?

select ItemName,sum(Quantity) as Total_Quantity
from spend_analysis
Group by ItemName
order by Total_Quantity Desc; 


-- 13)Find the average spending per transaction for each buyer:


select * from spend_analysis;

select buyer,avg(TotalCost) as Average_Spending_Per_Transaction
from spend_analysis
group by buyer;


-- 14)List suppliers who provided more than one category of items:


select supplier
from spend_analysis
group by supplier
having count(distinct category) > 1;

-- 15)how all transactions made in the first quarter (Q1) of any year:


select  * 
from spend_analysis
where month(PurchaseDate) Between 1 and 3;


-- 16)Rank buyers by their total spending using MySQL variables:

SELECT 
  Buyer,
  SUM(TotalCost) AS Total_Spent,
  RANK() OVER (ORDER BY SUM(TotalCost) DESC) AS Spending_Rank
FROM spend_analysis
GROUP BY Buyer;

-- 17)Find the average unit price per supplier and category combo:

select supplier,Category,avg(UnitPrice) as Average_unit_price
from spend_analysis
group by supplier,category;

-- 18)How many distinct items were bought each month?

select * from spend_analysis;

SELECT DATE_FORMAT(PurchaseDate, '%Y-%m') AS Months,
count(distinct ItemName) AS Distinct_Items
from spend_analysis
group by Months;


-- 19)Show monthly spend trends for each buyer (pivot-style summary

SELECT
  Buyer,
  SUM(CASE WHEN MONTH(PurchaseDate) = 1 THEN TotalCost ELSE 0 END) AS Jan,
  SUM(CASE WHEN MONTH(PurchaseDate) = 2 THEN TotalCost ELSE 0 END) AS Feb,
  SUM(CASE WHEN MONTH(PurchaseDate) = 3 THEN TotalCost ELSE 0 END) AS Mar
FROM spend_analysis
GROUP BY Buyer;

-- 20)Get the top 2 most purchased items by quantity per category


select * from spend_analysis;

SELECT *
FROM (
  SELECT 
    Category,
    ItemName,
    SUM(Quantity) AS Total_Quantity,
    RANK() OVER (PARTITION BY Category ORDER BY SUM(Quantity) DESC) AS rnk
  FROM spend_analysis
  GROUP BY Category, ItemName
) ranked
WHERE rnk <= 2;