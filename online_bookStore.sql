CREATE TABLE IF NOT EXISTS Books(
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10,2),
    Stock INT
);


CREATE TABLE IF NOT EXISTS Customers(
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);


CREATE TABLE IF NOT EXISTS Orders(
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10,2)
);



-- retrve all table in the fiction genre
SELECT * FROM Books
WHERE genre = 'Fiction';


-- find the book published after the year 1995
SELECT * FROM Books
WHERE published_year>1995;


-- List all the custumers from the canada
SELECT * FROM Customers
WHERE country = 'Canada';


-- Show Orders placed in november 2023
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-29';



-- find the total stock of books available 
SELECT SUM(stock) as total_stocks
FROM Books;

-- find the details of the most expensive books 
SELECT  * FROM Books 
ORDER BY
price DESC 
LIMIT 1;

-- select custumers who ordered more than 1 quantity of book
SELECT * FROM Orders
WHERE quantity>1;

-- retrive all orders where total amount exeeds $20
SELECT * FROM Orders
WHERE total_amount>20;

-- List all geners available in the Books Table
SELECT DISTINCT genre 
FROM Books;

--find the books with the lowest price
SELECT * FROM Books 
ORDER BY price ASC 
LIMIT 1;

-- Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue
FROM Orders;


-- ADVANCED QUESTIONS --

--Retrive the total number of books sold for each genre
SELECT b.Genre, SUM(o.quantity) as total_sold_each_gener
FROM Orders o
JOIN Books b ON b.book_id = o.book_id
GROUP BY b.genre;


-- Find the average price of books in the 'Fantasy' genre
SELECT AVG(price) as Avg_PriceOf_Fantasy
FROM Books
WHERE genre = 'Fantasy';

-- List Custumers Who have placed at least 2 orders
SELECT o.customer_id, c.name, COUNT(o.order_id) as Order_Count
FROM Orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;

-- Find most frequently ordered Book
SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY  o.book_id, b.title
ORDER BY order_count desc
LIMIT 1;

-- Show the top 3 most expensive books of 'Fantasy' genre
SELECT * FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- Retrive the total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS total_sold
FROM Books b
JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.author;

-- List the cities where custumers who spend over $30 are located
SELECT DISTINCT c.city, o.total_amount
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.total_amount>30;




SELECT * FROM Customers;
SELECT * FROM Books;
SELECT * FROM Orders;

-- Find the custumer who spend the most on orders

SELECT c.name, SUM(o.total_amount) AS total_spend
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spend DESC
LIMIT 1;

-- Calculate the stock remaining after fullfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_Quantity,
		   b.stock - COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM Books b
LEFT JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;
