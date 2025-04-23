create database library_db;

use library_db;

create table branch(
Branch_ID Varchar(10) primary key,
Manager_ID Varchar(15),
Branch_Address Varchar(40),
Contact_No Varchar(20)
);


create table Employee(
Emp_ID Varchar(30) Primary key,
Emp_Name Varchar(20),
Positions varchar(30),
Salary decimal(10,2),
Branch_ID Varchar(10),
foreign key(Branch_ID) references branch(Branch_ID)
);


select * from issued_status;
create table Members(
Members_ID varchar(20) Primary key,
Members_Name Varchar(20),
Members_Address varchar(30),
Reg_Date date
);


Create table books(
isbn varchar(50) primary key,
Book_title varchar(30),
Category varchar(30),
Rental_Price Decimal(10,2),
Statuss Varchar(30),
Author Varchar(30),
Publisher Varchar(30)
);

create table Issued_Status(
issued_id varchar(30) Primary key,
issued_member_id varchar(30),
issued_book_name varchar(30),
issued_date date,
issued_book_isbn varchar(30),
issued_employee_id varchar(30),
foreign key (issued_member_id) references Members(Members_ID),
foreign key (issued_employee_id) references employee(Emp_ID),
foreign key (issued_book_isbn) references books(isbn)
);


create table ReturnStatus(
Return_ID varchar(20) Primary Key,
issued_ID varchar(30),
Return_Book_Name Varchar(30),
Return_Date Date,
Return_Book_isbn varchar(30),
foreign key (Return_book_isbn) references books(isbn)
);


select * from issued_status;

-- 1)Create a New Book Record**-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

select * from books;

insert into books value("978-1-60129-456-2","To Kill a Mockingbird","Classic",6.00,"Yes","Harper Lee","J.B. Lippincott & Co.");

-- 2)Update an Existing Member's Address

select * from members;

update members set Members_Address="412 Main St" where Members_Address="123 Main St";

-- 3)Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

select * from issued_Status;

delete from issued_status where issued_id = 'IS121';


-- 4)Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from employee;
select * from books;
select * from issued_status;

select * from issued_status where issued_employee_id= 'E101';

-- 5)List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

select * from issued_status;

select issued_member_id,
count(issued_book_name) as Total_books
from issued_status
group by issued_member_id;

-- 6)Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

select * from books;
select * from issued_status;

-- 7)Retrieve All Books in a Specific Category:

select * from books;

select * from books where category ="classic";

-- 8)Find Total Rental Income by Category:

select * from issued_status;
select * from books;
select 
b.category,
sum(b.rental_price) as total_rental_Income
from 
books as b
join
issued_status as st
on b.isbn=st.issued_book_isbn
group by category;


-- 9)List Employees with Their Branch Manager's Name and their branch details**:

select * from employee;
select * from branch;

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.positions,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employee as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employee as e2
ON e2.emp_id = b.manager_id;


-- 10)Create a Table of Books with Rental Price Above a Certain Threshold

create table  Expensive_books as 
select * from books where Rental_price> 7.00;


-- 12)Retrieve the List of Books Not Yet Returned


SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;


-- 13): Identify Members with Overdue Books**  
-- Write a query to identify members who have overdue books (assume a 30-day return period).
-- Display the member's_id, member's name, book title, issue date, and days overdue.

select * from members;
select * from issued_status;
select * from books;
select * from returnstatus;

select 
m.members_ID,
m.members_name,
b.Book_title,
ist.issued_date,
rs.return_Date,
current_date - ist.issued_date as days_Overdue
from issued_status as ist
join
members as m
 on m.members_id = ist.issued_member_id
 join
 books as b
 on b.isbn = ist.issued_book_isbn
 left join
 returnstatus as rs
 on rs.issued_id = ist.issued_id
 where
 rs.return_Date is null
 and
 (current_date - ist.issued_date) > 30
 order by 1;


-- 14)Update Book Status on Return**  
-- Write a query to update the status of books in the books table to "Yes" 
-- when they are returned (based on entries in the return_status table).

UPDATE books b
SET b.status = 'Yes'
FROM return_status r
WHERE b.book_id = r.book_id
AND r.returned = TRUE;

-- 15)Branch Performance Report**  
-- Create a query that generates a performance report for each branch, showing the number of books issued,
-- the number of books returned, and the total revenue generated from book rentals.

select * from books;
select * from issued_status;
select * from returnstatus;

select * from branch;

select
b.branch_ID,
b.Manager_ID,
count(ist.issued_ID) as books_Issued,
count(rs.return_ID) as books_Return,
sum(bk.Rental_Price) as Revenue_generated_by_books_rental
from issued_status as ist
join 
employee as e 
on e.emp_id = ist.issued_employee_id
join
branch as b
on e.branch_id = b.branch_id
left join
returnstatus as rs
on rs.issued_id = ist.issued_id
join
books as bk
on ist.issued_book_isbn = bk.isbn
Group by 1,2;


-- 16)CTAS: Create a Table of Active Members**  
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members 
-- who have issued at least one book in the last 2 months.


CREATE TABLE active_members AS
SELECT DISTINCT m.member_id, m.member_name, m.member_email
FROM members m
JOIN book_issues b ON m.member_id = b.member_id
WHERE b.issue_date >= CURRENT_DATE - INTERVAL '2 months';

-- 17)Find Employees with the Most Book Issues Processed**  
-- Write a query to find the top 3 employees who have processed the most book issues.
-- Display the employee name, number of books processed, and their branch.

SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employee as e
ON e.emp_id = ist.issued_employee_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2;



-- 18)Identify Members Issuing High-Risk Books**  
-- Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. 
-- Display the member name, book title, and the number of times they've issued damaged books.

SELECT m.members_name, b.book_title, COUNT(*) AS damaged_books_issued
FROM members m
JOIN books bi ON m.member_id = bi.member_id
JOIN books b ON bi.book_id = b.book_id
WHERE b.status = 'damaged'
GROUP BY m.member_name, b.book_title
HAVING COUNT(*) > 2;

select * from returnstatus;


/*19)Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

DELIMITER $$

CREATE PROCEDURE ManageBookStatus(IN p_book_id INT)
BEGIN
    DECLARE current_status VARCHAR(10);

    -- Check the current status of the book
    SELECT status INTO current_status
    FROM books
    WHERE book_id = p_book_id;

    -- If the book is available, issue it
    IF current_status = 'yes' THEN
        UPDATE books
        SET status = 'no'
        WHERE book_id = p_book_id;
        
        -- Optional: You can insert a record into the book_issues table to log the issuance (if applicable)
        -- INSERT INTO book_issues (book_id, member_id, issue_date) VALUES (p_book_id, <member_id>, CURRENT_DATE);
        
        SELECT 'Book has been issued successfully.' AS message;
    ELSE
        -- If the book is not available, return an error message
        SELECT 'Error: The book is currently not available.' AS message;
    END IF;
END $$

DELIMITER ;


/*20)Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
*/

CREATE TABLE overdue_books_fines AS
SELECT 
    m.members_id,
    COUNT(bi.book_id) AS overdue_books,
    SUM(DATEDIFF(CURRENT_DATE, bi.issue_date) * 0.50) AS total_fines
FROM 
    members m
JOIN 
    books bi ON m.member_id = bi.member_id
JOIN 
    books b ON bi.book_id = b.book_id
WHERE 
    bi.return_date IS NULL
    AND DATEDIFF(CURRENT_DATE, bi.issue_date) > 30
GROUP BY 
    m.member_id;

select * from books;

select * from members;