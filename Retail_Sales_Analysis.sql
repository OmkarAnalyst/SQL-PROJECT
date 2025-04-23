create database p1_retail_db;

create table Retail_sales(
Transactions_Id int primary key,
sale_Date date,
sale_Time Time,
Customer_Id int,
Gender varchar(20),
Age int,
Category varchar(40),
Quantity int,
Price_Per_Unit Float,
Cogs Float,
Total_Sale Float
);


select * from retail_sales;


select count(Transactions_Id) as Total_records from retail_sales;

select count(distinct(customer_Id)) as Total_Customer from retail_sales;

select distinct(category) as Total_Category from retail_sales;

select * from retail_sales
where
 Transactions_Id IS NULL
 OR
sale_Date IS NULL
 OR
 sale_Time IS NULL 
 OR 
 Customer_ID IS NULL
 OR 
 Gender IS NULL
 OR
 Age IS NULL
 OR
 Category IS NULL 
 OR 
 Quantity IS NULL
 OR
 Price_Per_Unit IS NULL
 OR
 Cogs IS NULL
 OR 
 Total_Sale IS NULL ;
 
 delete From retail_sales
Where
   Transactions_Id IS NULL
 OR
sale_Date IS NULL
 OR
 sale_Time IS NULL 
 OR 
 Customer_ID IS NULL
 OR 
 Gender IS NULL
 OR
 Age IS NULL
 OR
 Category IS NULL 
 OR 
 Quantity IS NULL
 OR
 Price_Per_Unit IS NULL
 OR
 Cogs IS NULL
 OR 
 Total_Sale IS NULL ;

/*1)Retrieve sales made on a specific date:*/

select * from retail_sales;

select * from retail_sales where sale_Date= '2022-12-16';


/*2)Write a SQL Query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of nov-2022.*/

select * from retail_sales
where
Category="Clothing"
and
extract(month from sale_Date) = '11' and
extract(Year from Sale_Date) = '2022'
and
Quantity>3;

/*3)Write a SQL Query to Calculate Total Sales (total sale) from each category.*/

select category,
sum(total_Sale) as Total_Amount
from retail_sales
group by category;

/*4)Write a SQL Query to find the average age of customer who purchased itmes from the beauty category.*/

select 
round(avg(age),2) as Average_Age 
from retail_sales
where category="Beauty"; 

/*5)Write a SQL Query to find all transaction where the total_sale is greater than 1000.*/

select * from retail_sales 
where Total_Sale>1000;

/*6)Write a SQL Query to find the total number of transactions (transaction_id) made by gender in each category.*/

select gender,category,
count(transactions_Id) as Total_Transactions
from retail_sales
group by Gender,category;

/*7)Write a SQL Query to calculate the average sales for each month.*/

select
extract(month from sale_Date) As Months,
extract(year from sale_date) as Years, 
round(avg(total_Sale),4) as Average_Sale
from retail_sales
group by Months,Years
order by 1, 2;

/*8)Write a SQL Query to find out the top 5 customers based on the highest total sales.*/

select Customer_Id, 
sum(Total_Sale) as Total_Sales
from retail_sales
group by Customer_Id
limit 5;


/*9)Write a SQL Query to find the number of unique customers who purchased items from each category.*/

select category,
count(distinct(Customer_Id)) as Total_Customer
 from retail_sales
 group by Category;



/*10)Write a SQL Query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17 , Evening >17.*/

select
case
when extract(hour from sale_Time) < 12 Then "Morning"
when extract(hour from sale_Time) Between 12 and 17 Then "Afternoon"
Else "Evening"
End As Shift,
count(transactions_Id) as Total_Orders
from retail_Sales
Group by shift;




