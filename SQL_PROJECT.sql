CREATE DATABASE retail_DB;
use retail_DB;

-- create table 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	Transaction_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender varchar(10),
	age INT,
	category varchar(40),
	quantity INT,
	price_per_unit FLOAT,
	goods_sold FLOAT,
	total_sales FLOAT 
);

SELECT * FROM retail_sales;

Truncate table retail_sales;

-- Data cleaning 

SELECT count(*) FROM retail_sales; -- To check whether we got all the rows from EXCEL or not here i faced some issue like in excel I have 2000 rows here it is loading only 1987 rows so there is some data loss.

SELECT * FROM retail_sales
where Transaction_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR age IS NULL
OR category IS NULL 
OR quantity IS NULL 
OR price_per_unit IS NULL
OR goods_sold IS NULL
OR total_sales IS NULL;  -- To know whether we have null values in our data or not

-- Data Exploration

-- Total sales 

SELECT count(transaction_id) as Total_sales FROM retail_sales; 

SELECT distinct(year(sale_date)) FROM retail_sales; -- From how many years We are operating like the distinct years we are operating

with CTE as (
SELECT *, month(sale_date) as mnt, year(sale_date) as yr FROM retail_sales)

SELECT yr, mnt, count(transaction_id) as sales_per_yr_month FROM CTE group by yr, mnt order by yr, mnt; -- In each year and each month how much transaction is happening

SELECT yr, count(transaction_id) as sales_per_year FROM CTE group by yr order by sales_per_year desc; -- Total sales per year -- From this query I observed that the sales increased when compared to last year

SELECT mnt, count(transaction_id) as sales_per_month FROM CTE group by mnt order by sales_per_month desc; -- Total sales per month -- I observed december is having more sales.

SELECT sale_time, count(transaction_id) as sales FROM retail_sales group by sale_time order by sales desc; -- at what time we are getting more sales

SELECT min(sale_time), max(sale_time) FROM retail_sales;  -- seeing the opening and closing more like the least and highest time of customers visiting our store.

-- customers

-- no.of unique customers are 155 

SELECT count(distinct(customer_id)) as unique_customers FROM retail_sales; 

SELECT customer_id, count(transaction_id) as tran FROM retail_sales group by customer_id order by tran desc;  -- list of fav customers from highest to lowest

SELECT gender, count(*) FROM retail_sales group by gender; -- from this i can say we have slightly more female customers than male

SELECT age, count(*) FROM retail_sales group by age order by count(*) desc; 

-- Products 
SELECT * FROM retail_sales;

SELECT distinct(category) FROM retail_Sales; -- Total number of categories we sell

SELECT category, sum(quantity) FROM retail_Sales group by category order by sum(quantity) desc; 

SELECT category, sum(total_sales) FROM retail_Sales group by category order by sum(total_sales) desc;

-- From the above two what I observed is clothing is getting sold the most but more profit we are booking from electronics

SELECT category, gender, count(gender)
From retail_Sales group by category, gender;

SELECT category, case when gender = 'male' then count(*) end as male, 
case when gender = 'Female' then count(*) end as Female
From retail_Sales group by category, gender;

with CTE as(
SELECT category, 
case when gender = 'male' then count(*) end as "Male",
case when gender = 'Female' then count(*) end as "Female"
FROM retail_sales group by category, gender 
)

SELECT 
case when category = 'Beauty' then Male end as 'Beauty',
case when category = 'Clothing' then Male end as 'Clothing',
case when category = 'Electronics' then Male end as 'Electronics'
FROM CTE;

SELECT category, count(case when gender = 'Male' then 1 end) as 'Male',
count(case when gender = 'Female' then 1 end) as 'Female'
FROM retail_Sales group by category;


SELECT category, count(*) From retail_Sales group by category, gender;


-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales where sale_date = '2022-11-05';


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales where category = 'Clothing' and quantity >= 4 and sale_date like '2022-11%'; 

-- need all the transactions where people bought more than 4 pieces in the month of novenmber 2022

-- Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT category, count(*) as total_transactions, sum(total_sales) as total_sales_per_category FROM retail_sales group by category;

-- These are the transactions that were made in each category and this is the amount(not profit) we got in each category 

SELECT * FROM retail_sales;


-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT round(avg(age), 2) as avg_age FROM retail_sales where category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales where total_sales > 1000;

-- I want the count of transactions where in one transation they are buying more than 1000 worth of products

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT gender, category, count(*) FROM retail_sales group by gender, category order by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT monthname(sale_date) as moth, round(avg(total_sales),2) as avg_sales FROM retail_sales  group by monthname(sale_date);

SELECT year(sale_date) as yer, monthname(sale_date) as mth, sum(total_sales) as total_Sales 
FROM retail_Sales group by year(sale_date), monthname(sale_date) order by total_sales desc;

SELECT yr as year, mn as month, avg_sales FROM(SELECT year(sale_date) as yr, monthname(sale_date) as mn, round(avg(total_sales), 2) as avg_sales,
rank() over(partition by year(sale_date) order by avg(total_sales) desc) as rn 
FROM retail_sales 
group by year(sale_date), monthname(sale_date)) tab where rn = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales:

SELECT customer_id, sum(total_sales) FROM retail_sales group by customer_id order by sum(total_sales) desc limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT category, count(distinct(customer_id)) FROM retail_sales group by category; 


-- Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

SELECT shift, count(transaction_id) as num_of_orders FROM(SELECT *,
case when sale_time < '12:00:00' then "Morning"
when sale_time >= '12:00:00' and sale_time <= '17:00:00' then "Afternoon"
when sale_time > '17:00:00' then "Evening" end as shift
FROM retail_sales) tab group by shift;

WITH CTE AS(
SELECT *,
case when hour(sale_time) < 12 then "Morning"
when hour(sale_time) >= 12 and hour(sale_time) <= 17 then "Afternoon"
when hour(sale_time) > 17 then "Evening" end as shift
FROM retail_sales)

SELECT shift, count(transaction_id) as num_of_orders FROM CTE group by shift;










