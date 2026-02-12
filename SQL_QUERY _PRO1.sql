use sql_project;
SELECT * FROM retail_sales;
-- Data cleaning - CHECKING FOR NULL VALUES- IN AGE ALSO WE HAVE NULL VALUES , BUT IN OTHER COLUMNS IT HAS VALUES , WHERE AS 3 RECORDS HAS NO DATA IN 4 COLUMNS 
select * from retail_sales
where 
transactions_id is null
or 
sale_date is null 
or
sale_time is null 
or
 customer_id is null
 or
 gender is null
 or
 category is null
 or
 quantiy is null
 or 
 price_per_unit is null
 or
 cogs is null 
 or
 total_sale is null;
 
-- DELETE THE ROWS WITH NULL VALUES 
DELETE FROM retail_sales 
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
 
 -- DATA EXPLORATION
 -- How many sales we have 
 select count(*) as total_sales from retail_sales;
 -- Total_sales - 1997

 -- How many unique customer we have 
  select count(distinct customer_id) as total_customers from retail_sales;
  -- Total_customers - 155
  select DISTINCT CATEGORY from retail_sales;
  -- clothing,beauty.electronis
  -- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS 
  -- Q1 - QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05'
  -- sale_date format in table retail_sales in mm-dd-yyyy so it is not retrivening data, 
  -- so using the retail sales analysis cleaned table which has sale_date in yyyy-mm-dd
SELECT * FROM  sql_project.`retail sales analysis -cleaned`
WHERE sale_date = '2022-11-05';
SELECT count(*) as sale_nov052022 FROM  sql_project.`retail sales analysis -cleaned`
WHERE sale_date = '2022-11-05';
-- Number of sale on Nov 11 2022 is 11
-- Q2 - QUERY TO RETRIEVE ALL transactions where category is 'clothing' and quantity sold is more than 10 in the month of nov -2022 
SELECT transactions_id,quantity,category FROM  sql_project.`retail sales analysis -cleaned`
WHERE category='clothing' AND  
DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4 ;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,sum(total_sale) FROM  sql_project.`retail sales analysis -cleaned`
 group by category;
	
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category,round(avg(age)) as avg_age FROM  sql_project.`retail sales analysis -cleaned`
where category = 'Beauty'
 group by 1;
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT transactions_id,sum(total_sale) as total_sale FROM  sql_project.`retail sales analysis -cleaned`
 group by transactions_id
 having total_sale >1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
 SELECT count(*), gender, category  FROM  sql_project.`retail sales analysis -cleaned`
 group by gender, category 
 ORDER BY gender, category;
 
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select sale_year, sale_month , highest_sale from 
(
	SELECT avg(total_sale) as highest_sale,
	Month(sale_date) as sale_month,
	YEAR(sale_date) as sale_year, 
	RANK() OVER(
		PARTITION BY YEAR(sale_date) 
        ORDER BY avg(total_sale) desc) as r1
FROM  sql_project.`retail sales analysis -cleaned` 
GROUP BY 3,2 
) as tab1
where r1=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT sum(total_sale) as highest_sale,customer_id 
FROM sql_project.`retail sales analysis -cleaned` 
GROUP BY 2 ORDER BY 1 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT CATEGORY, COUNT(DISTINCT customer_id)
FROM sql_project.`retail sales analysis -cleaned` 
GROUP BY 1 ;
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH Hourly_sale AS
(
SELECT *,
	CASE 
		WHEN HOUR(sale_time) < 12  THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS SHIFT
FROM sql_project.`retail sales analysis -cleaned` 
)
SELECT COUNT(*) as total_orders,shift FROM Hourly_sale GROUP BY SHIFT;

-- End of Project 