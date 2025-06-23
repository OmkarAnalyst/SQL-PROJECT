Create database Zepto_Db;


-- 1)Total Number of Unique Categories:
-- Count the number of distinct product categories available in zepto_v1.


select * from zepto_1;

select count(distinct(category)) as Distinct_product_Category
from Zepto_1;


-- 2)Average mrp per Category:
-- Calculate the average mrp for products within each Category in zepto_v1.

select * from zepto_1;

select category,avg(mrp) as Average_MRP 
from zepto_1
Group by category;


-- 3)Count of Out-of-Stock Products per Category:
-- For each Category, find out how many products are currently outOfStock in zepto_v1.

select * from zepto_1;

select category , count(outOfStock) as Currently_OutofStock
from zepto_1
Group by category;

-- 4)Category with Highest Average Discount:
-- Identify the Category that has the highest average discountPercent in zepto_v1.

select * from zepto_1;

select category, avg(DiscountPercent) as Average_DiscountPercentage
from zepto_1
Group by Category
order by Average_DiscountPercentage Desc;

-- 5)Products with High Discount and Low mrp:
-- Find names of products in zepto_v1 that have a discountPercent greater than 20% and an mrp less than 50.

select * from zepto_1;

select name from zepto_1
where discountPercent  > 20 
and mrp < 50;


-- 6)Total Potential Value of Available Stock:
-- Calculate the sum of (discountedSellingPrice * availableQuantity) for all products that are not outOfStock in zepto_v1.

select * from zepto_1;

select category ,sum(discountedSellingPrice * availableQuantity) as Potential_Value
from  zepto_1	where outOfStock = "False"
group by category;

-- 7)Categories with All Products In Stock:
-- List Category names where all products in that category are inStock.

select category , name from zepto_1
where outOfStock = "FALSE";


-- 8)Products with Highest Discounted Selling Price:
-- Find the name and Category of the product with the maximum discountedSellingPrice in zepto_v1.

select * from zepto_1;

Select category ,max(discountedSellingPrice) as Maximum_DiscountedSelling_Price
from zepto_1
group by Category
order by Maximum_DiscountedSelling_Price desc;


-- 9)Average Weight of Products per Category:
-- Calculate the average weightInGms for products in each Category in zepto_v1.

select * from zepto_1;

select category , avg(weightInGms) as Average_Weight_Gms
from zepto_1
Group by category;

-- 10)Count of Products with Zero Discount:
-- How many products in zepto_v1 are being sold at their full mrp (i.e., discountPercent is 0)?

select * from zepto_1;

select count(category) as Products 
from zepto_1 where discountPercent = 0;


-- 11)Percentage of Out-of-Stock Products:
-- Calculate the percentage of all products in zepto_v1 that are outOfStock.

select * from zepto_1;

SELECT
  (SUM(CASE WHEN outOfStock = TRUE THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS percentage_out_of_stock
FROM
  zepto_1;

-- 12)Products with Quantity Mismatch (v1):
-- Find products in zepto_v1 where availableQuantity is exactly 0 but outOfStock is marked as FALSE.

select name , outOfStock , availableQuantity 
from zepto_1
where availableQuantity = 0 and outOfStock = FALSE;

-- 13)Average discountedSellingPrice for 'Dairy & Bread' Products:
-- What is the average discountedSellingPrice for products belonging to the 'Dairy & Bread' category in zepto_v1?

select * from zepto_1;

select name , avg(discountedSellingPrice) as Average_Discounted_sellingprice
from zepto_1
where category = "Dairy, Bread & Batter"
group by name;


-- 14)Total Discount Amount per Category:
-- For each category in zepto_v1, calculate the sum of the actual discount amount for all products (mrp - discountedSellingPrice).


select * from zepto_1;

select category , sum(discountedSellingPrice) as Discount_Amount
from zepto_1
group by category;