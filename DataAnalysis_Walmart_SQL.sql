SELECT * FROM dataanalysis.walmartsalesdata;

-- Data cleaning
SELECT
	*
FROM walmartsalesdata;

Use dataanalysis;


-- Add the time_of_day column


Select 
	time,
    (CASE
      When time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
      When time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
      ELSE "Evening"
      END) AS timr_of_day
From walmartsalesdata;

ALTER TABLE walmartsalesdata ADD COLUMN time_of_day VARCHAR(20);


UPDATE walmartsalesdata
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name column
SELECT 
     date, dayname(date)
 From  walmartsalesdata;

Alter table walmartsalesdata ADD column day_name VARCHAR(25);


Update walmartsalesdata
	SET	day_name = dayname(date);	
    
-- Add month_name column		
        
SELECT 
	monthname(date)
    
From walmartsalesdata;

ALTER Table walmartsalesdata ADD Column month_name varchar(25);

UPDATE walmartsalesdata
  SET month_name = monthname(date);
  
  
  
 -- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have? 

select 
	distinct City  
From walmartsalesdata;
  
-- In which city is each branch?

SELECT 
	DISTINCT city,
    branch
FROM walmartsalesdata;  


-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM walmartsalesdata;


-- What is the most selling product line   

Select 
	 Sum(quantity) AS qty,
     product_line 
From walmartsalesdata
     Group BY product_line
     ORDER BY qty DESC;

-- What is the total revenue by month

SELECT 
    month_name AS Months,
    SUM(total) AS total_revenue
FROM walmartsalesdata
GROUP BY month_name
ORDER BY total_revenue;

-- What month had the largest COGS?
SELECT 
   month_name AS Months,
   SUM(cogs) As total_cogs
From walmartsalesdata
Group By Months
Order By total_cogs;

-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM walmartsalesdata
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM walmartsalesdata
GROUP BY city, branch 
ORDER BY total_revenue;


-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(VAT) as avg_tax
FROM walmartsalesdata
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM walmartsalesdata;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM walmartsalesdata
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM walmartsalesdata
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmartsalesdata);


-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM walmartsalesdata
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM walmartsalesdata
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Query for Top Performing Products by Gross Income
SELECT product_line, SUM(gross_income) AS total_gross_income
FROM walmartsalesdata
GROUP BY product_line
ORDER BY total_gross_income DESC;


-- -------------------------- Customers -------------------------------
-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM walmartsalesdata;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment_method
FROM walmartsalesdata;


-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM walmartsalesdata
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmartsalesdata
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmartsalesdata
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmartsalesdata
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmartsalesdata
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM walmartsalesdata
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM walmartsalesdata
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM walmartsalesdata
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(VAT), 2) AS avg_VAT
FROM walmartsalesdata
GROUP BY city 
ORDER BY avg_VAT DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(VAT) AS total_VAT
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY total_VAT;



-- This query calculates the average gross margin percentage for each product line.

SELECT 
    product_line, 
    AVG(gross_margin_percentage) AS average_gmp
FROM 
    walmartsalesdata
GROUP BY 
    product_line
ORDER BY 
    average_gmp DESC;
    
-- This query calculates the total gross income for each branch.

SELECT 
    branch, 
    SUM(gross_income) AS total_gross_income
FROM 
    walmartsalesdata
GROUP BY 
    branch
ORDER BY 
    total_gross_income DESC;

-- Query for Gross Margin Distribution by Branch
SELECT 
    branch, 
    COUNT(*) AS transaction_count, 
    AVG(gross_margin_percentage) AS average_gmp, 
    MIN(gross_margin_percentage) AS min_gmp, 
    MAX(gross_margin_percentage) AS max_gmp
FROM 
    walmartsalesdata
GROUP BY 
    branch
ORDER BY 
    average_gmp DESC;


