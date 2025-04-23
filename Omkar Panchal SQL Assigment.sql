
--  Q1 a.	Fetch the employee number, first name and last name of those employees who are working as Sales Rep reporting to employee with employeenumber 1102 -- 

SELECT DISTINCT
    e.employeeNumber,
    e.firstName,
    e.lastName
FROM
    Employees e
WHERE
    e.jobTitle LIKE 'Sales Rep' 
    AND e.reportsTo = 1102;


-- Q1 b.	Show the unique productline values containing the word cars at the end from the products table. 

select productLine
 from productlines
 where productLine like "%cars";

--  Q2 a. Using a CASE statement, segment customers into three categories based on their country:

SELECT 
    customerNumber,
    customerName,
    CASE
        WHEN country IN ('USA', 'Canada') THEN 'North America'
        WHEN country IN ('UK', 'France', 'Germany') THEN 'Europe'
        ELSE 'Other'
    END AS CustomerSegment
FROM Customers;

-- Q3 a.	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders.

SELECT productCode, SUM(quantityOrdered) AS totalQuantity
FROM OrderDetails
GROUP BY productCode
ORDER BY totalQuantity DESC
LIMIT 10;

-- Q3 b.Company wants to analyse payment frequency by month. Extract the month name from the payment date to count the total number of payments for each month and include only
 -- those months with a payment count exceeding 20. Sort the results by total number of payments in descending order.    

SELECT  
   DATENAME(MONTH, PaymentDate) AS MonthName,  
   COUNT(PaymentID) AS TotalPayments  
FROM  
   Payments  
GROUP BY  
   DATENAME(MONTH, PaymentDate)  
HAVING  
   COUNT(PaymentID) > 20  
ORDER BY  
   TotalPayments DESC


/*Q4 a.	Create a table named Customers to store customer information. Include the following columns:

customer_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
first_name: This should be a VARCHAR(50) to store the customer's first name.
last_name: This should be a VARCHAR(50) to store the customer's last name.
email: This should be a VARCHAR(255) set as UNIQUE to ensure no duplicate email addresses exist.
phone_number: This can be a VARCHAR(20) to allow for different phone number formats.

Add a NOT NULL constraint to the first_name and last_name columns to ensure they always have a value.
*/


create database Customer_Orders;
use Customer_Orders;
create table Customers
(
customer_id int primary key auto_increment, 
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(225) unique,
phone_number varchar(20)
);




/* Q4 b.	Create a table named Orders to store information about customer orders. Include the following columns:

    	order_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
customer_id: This should be an integer referencing the customer_id in the Customers table  (FOREIGN KEY).
order_date: This should be a DATE data type to store the order date.
total_amount: This should be a DECIMAL(10,2) to store the total order amount.
     	
Constraints:
a)	Set a FOREIGN KEY constraint on customer_id to reference the Customers table.
b)	Add a CHECK constraint to ensure the total_amount is always a positive value.
*/

create table Orders
(
order_id int auto_increment primary key,
customer_id int,
order_date date,
total_amount decimal(10,2),
foreign key (customer_id) references Customers(customer_id),
check(total_amount > 0)
);


-- Q5 a. List the top 5 countries (by order count) that Classic Models ships to. (Use the Customers and Orders tables) not

SELECT
    c.country,
    COUNT(o.orderNumber) AS order_count
FROM
    Customers c
JOIN
    Orders o ON c.customerNumber = o.customerNumber
GROUP BY
    c.country
ORDER BY
    order_count DESC
LIMIT 5;


/*Q6 a. Create a table project with below fields.
●	EmployeeID : integer set as the PRIMARY KEY and AUTO_INCREMENT.
●	FullName: varchar(50) with no null values
●	Gender : Values should be only ‘Male’  or ‘Female’
●	ManagerID: integer 
*/


create table project(
EmployeeId int primary Key Auto_Increment,
FullName Varchar(50) Not null,
Gender Enum("Male","Female") not null,
ManagerID int
);

insert into project value(1,"Pranaya","Male",3);
insert into project value(2,"Priyanka","Female",1);
insert into project value(3,"Preety","Female",0);
insert into project value(4,"Anurag","Male",1);
insert into project value(5,"Sambit","Male",1);
insert into project value(6,"Rajesh","Male",3);
insert into project value(7,"Hina","Female",3);

select * from project;

select p.FullName,
o.EmployeeId as ManagerId,
o.FullName as ManagerName From
project p join project o
on p.ManagerID = o.employeeId;

/*Q7 a. Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values */

create table facility
(
facility_ID int,
Name varchar(50),
State varchar(50),
Country varchar(50)
);

Alter table facility modify facility_ID int Auto_Increment primary Key;

desc facility;

alter table facility add column city varchar(50) not null after Name;

desc facility;

/*Q8 a. Create a view named product_category_sales that provides insights into sales performance by product category. This view should include the following information:
productLine: The category name of the product (from the ProductLines table).

total_sales: The total revenue generated by products within that category (calculated by summing the orderDetails.quantity * orderDetails.priceEach for each product in the category).

number_of_orders: The total number of orders containing products from that category.

(Hint: Tables to be used: Products, orders, orderdetails and productlines)

The view when read should show the output as:*/

CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine AS productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    ProductLines pl
JOIN 
    Products p ON pl.productLine = p.productLine
JOIN 
    OrderDetails od ON p.productCode = od.productCode
JOIN 
    Orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;

select * from product_category_sales    
    
/* Q9 a. Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments*/

DELIMITER //

CREATE PROCEDURE Get_country_payments  
   year INT,  
   country VARCHAR(50)  
AS  
BEGIN  
   SELECT  
      YEAR(p.PaymentDate) AS PaymentYear,  
      c.Country,  
      FORMAT(SUM(p.Amount), 'N0') AS TotalAmount  
   FROM  
      Payments p  
   INNER JOIN  
      Customers c ON p.CustomerID = c.CustomerID  
   WHERE  
      YEAR(p.PaymentDate) = @year AND c.Country = @country  
   GROUP BY  
      YEAR(p.PaymentDate), c.Country  
END

DELIMITER ;

CALL Get_country_payments(2023, 'France');

-- Q10 a) Using customers and orders tables, rank the customers based on their order frequency

SELECT  
   c.CustomerName,  
   COUNT(o.OrderID) AS OrderFrequency,  
   RANK() OVER (ORDER BY COUNT(o.OrderID) DESC) AS Rank  
FROM  
   Customers c  
INNER JOIN  
   Orders o ON c.CustomerID = o.CustomerID  
GROUP BY  
   c.CustomerName  
ORDER BY  
   OrderFrequency DESC

/*b) Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
Table: Orders*/

WITH OrderCounts AS (  
   SELECT  
      YEAR(OrderDate) AS OrderYear,  
      DATENAME(MONTH, OrderDate) AS OrderMonth,  
      COUNT(OrderID) AS OrderCount  
   FROM  
      Orders  
   GROUP BY  
      YEAR(OrderDate), DATENAME(MONTH, OrderDate)  
)  
SELECT  
   OrderYear,  
   OrderMonth,  
   OrderCount,  
   FORMAT(((OrderCount - LAG(OrderCount) OVER (PARTITION BY OrderMonth ORDER BY OrderYear)) /
 LAG(OrderCount) OVER (PARTITION BY OrderMonth ORDER BY OrderYear)) * 100), 'N0') AS YoYChange  
FROM  
   OrderCounts  
ORDER BY  
   OrderYear, OrderMonth

/*Q11 a. Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product 
line and its count.*/

SELECT
    productLine,
    COUNT(*) AS productLineCount
FROM
    Products
WHERE
    buyPrice > (SELECT AVG(buyPrice) FROM Products)
GROUP BY
    productLine;


/*Q12. ERROR HANDLING in SQL
      Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. 
Show the message as “Error occurred” in case of anything wrong.*/

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100) NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL
);

DELIMITER //

CREATE PROCEDURE InsertEmployee (
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(100),
    IN p_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handling code
        SELECT 'Error occurred' AS ErrorMessage;
    END;

    -- Insert data into the table
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);
    
    -- Optionally, you can add a success message
    SELECT 'Record inserted successfully' AS SuccessMessage;
END //

DELIMITER ;


CALL InsertEmployee(1, 'Ved Patel', 'VedPatel21@gmail.com');

/*Q13. TRIGGERS
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours
*/

use classicmodels;

CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);


DELIMITER //

CREATE TRIGGER before_insert_emp_bit
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END //

DELIMITER ;

INSERT INTO Emp_BIT VALUES ('John', 'Designer', '2020-10-04', -8);

select * from Emp_BIT;