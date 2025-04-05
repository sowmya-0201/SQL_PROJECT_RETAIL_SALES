# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to get to know more about the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, goods_sold, and total sale amount.

``` sql
CREATE DATABASE retail_DB;

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

```

### 2. Basic Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.

```sql
SELECT count(*) FROM retail_sales;

SELECT *
FROM retail_sales
where sale_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR
age IS NULL OR
category IS NULL OR
quantity IS NULL OR
price_per_unit IS NULL OR
goods_sold IS NULL OR
total_sales IS NULL;

DELETE FROM retail_sales
WHERE sale_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR 
gender IS NULL OR
age IS NULL OR
category IS NULL OR 
quantity IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL;

SELECT count(distinct(customer_id)) as unique_customers FROM retail_sales; 

SELECT DISTINCT category FROM retail_sales;
```
### 3. Sales Analysis based on year, month, time

- **Transaction Count**: Find out the no.of transactions per year and per month.
  
```
with CTE as (
SELECT *, month(sale_date) as sale_month, year(sale_date) as sale_year FROM retail_sales)

SELECT sale_year, sale_month, count(transaction_id) as sales_per_yr_month FROM CTE group by sale_year, sale_month order by sale_year, sale_month; -- In each year and each month how much transaction is happening

SELECT sale_year, count(transaction_id) as sales_per_year FROM CTE group by sale_year order by sales_per_year desc; -- Total sales per year -- From this query I observed that the sales increased when compared to last year

SELECT sale_month, count(transaction_id) as sales_per_month FROM CTE group by sale_month order by sales_per_month desc; -- Total sales per month -- I observed december is having more sales.

SELECT sale_time, count(transaction_id) as sales_per_time FROM retail_sales group by sale_time order by sales_per_time desc; -- at what time we are getting more sales

SELECT min(sale_time) as min_time, max(sale_time) as max_time FROM retail_sales;  -- seeing the opening and closing more like the least and highest time of customers visiting our store.

```

### 4. Analysis on customers

```
SELECT count(distinct(customer_id)) as unique_customers FROM retail_sales; 

SELECT customer_id, count(transaction_id) as transactions FROM retail_sales group by customer_id order by tran desc LIMIT 5;  -- list of fav customers from highest to lowest

SELECT gender, count(*) as gender_sales FROM retail_sales group by gender; -- from this i can say we have slightly more female customers than male

SELECT age, count(*) as age_sales FROM retail_sales group by age order by count(*) desc;

SELECT category, count(case when gender = 'Male' then 1 end) as 'Male',
count(case when gender = 'Female' then 1 end) as 'Female'
FROM retail_Sales group by category;  -- For each category gender wise sales
```

### 5. Analysis on products we are selling

```
SELECT * FROM retail_sales;

SELECT distinct(category) FROM retail_Sales;

SELECT category, sum(quantity) as quantity_sold FROM retail_Sales group by category order by sum(quantity) desc; -- For each category how much quantity we are selling

SELECT category, sum(total_sales) as total_sales FROM retail_Sales group by category order by sum(total_sales) desc; --  total number of sales For each category
```

### 6. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
where category = 'Clothing'
and quantity >= 4
and sale_date like '2022-11%'
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, count(*) as total_orders, sum(total_sales) as total_sales_per_category 
FROM retail_sales
group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT round(avg(age), 2) as avg_age
FROM retail_sales
where category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT gender, category, count(*) as total_transactions
FROM retail_sales
group by gender, category
order by category;  
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT year, month, avg_sales 
FROM(SELECT year(sale_date) as year, monthname(sale_date) as month, round(avg(total_sales), 2) as avg_sales,
rank() over(partition by year(sale_date) order by avg(total_sales) desc) as rn 
FROM retail_sales 
group by year(sale_date), monthname(sale_date)) tab
where rn = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT customer_id, sum(total_sales)
FROM retail_sales
group by customer_id
order by sum(total_sales) desc limit 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, count(distinct(customer_id))
FROM retail_sales
group by category; 
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale AS(
SELECT *,
case when hour(sale_time) < 12 then "Morning"
when hour(sale_time) >= 12 and hour(sale_time) <= 17 then "Afternoon"
when hour(sale_time) > 17 then "Evening" end as shift
FROM retail_sales)

SELECT shift, count(transaction_id) as num_of_orders FROM hourly_sale group by shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing, Beauty and Electronics, gender wise sales.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

