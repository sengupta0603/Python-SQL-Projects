SELECT TOP (1000) [order_id]
      ,[order_date]
      ,[ship_mode]
      ,[segment]
      ,[country]
      ,[city]
      ,[state]
      ,[postal_code]
      ,[region]
      ,[category]
      ,[sub_category]
      ,[product_id]
      ,[quantity]
      ,[discount]
      ,[sale_price]
      ,[profit]
  FROM [master].[dbo].[df_orders]

  Select * From df_orders;



  --Analysis Quest bsics

 --How would you find the top 5 cities with the highest total sales?


Select top 5 city,  
Sum(sale_price) as highest_sale
from df_orders
--Where Year(order_date) = 2022
group by city 
Order by highest_sale desc

 --How would you show the top 5 cities with the highest total sales and compare both the years?
 

with cte as (
  Select city, Year(order_date) as sale_year,
  Sum(sale_price) As sales
  From df_orders
  group by YEAR(order_date), city
)
Select city,
  Sum(case When sale_year = 2022 then sales else 0 end) AS sales_2022,
  Sum(case When sale_year = 2023 then sales else 0 end) AS sales_2023
From cte
Group by city
Order by city;

--Write a SQL query to find the total number of orders, total sales, and total profit for each segment.

Select segment, 
count(order_id) as total_orders, 
Sum(sale_price) as total_sale, 
Sum(profit) as total_profit
from df_orders
group by segment
order by total_sale desc


--Analyzing Impact of Discounts on Profit:


SELECT
    discount,
    COUNT(order_id) AS total_orders,
    SUM(sale_price) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(profit) AS avg_profit
FROM [master].[dbo].[df_orders]
GROUP BY discount
ORDER BY discount;


  --find top 10 highest reveue generating products 

  Select top 10 product_id , Sum(sale_price) As sales
  From df_orders
  Group By product_id
  Order By sales DESC
  

--find top 5 highest selling products in each region
 with cte as (
 Select region, product_id , Sum(sale_price) As sales
  From df_orders
  Group By region, product_id)
  Select * from(
  Select *
  , ROW_NUMBER() over (partition by region order by sales desc) as rank
  from cte) Ab
  Where rank <=5



--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte  as (
Select YEAR(order_date) as order_year, MONTH(order_date) as order_month ,
Sum(sale_price) AS sales
from df_orders
group by YEAR(order_date), MONTH(order_date)
--order by YEAR(order_date), MONTH(order_date)
)
 Select order_month 
 , Sum(case When order_year=2022 then sales else 0  end) AS sales_2022
  , Sum(case When order_year=2023 then sales else 0 end) AS sales_2023
 From cte
 group by order_month
 Order by order_month

--for each category which month had highest sales 
with cte As(
Select category, FORMAT(order_date, 'yyyy-MM') as order_year_month, 
Sum(sale_price) as sales
from df_orders
group by category, FORMAT(order_date, 'yyyy-MM')
--order by category, FORMAT(order_date, 'yyyy-MM')
)
Select * from(
select * 
, ROW_NUMBER() over (partition by category order by sales desc) as rank
from cte
) a
Where rank=1

--which sub category had highest growth by profit in 2023 compare to 2022
with cte  as (
Select sub_category , YEAR(order_date) as order_year,  
Sum(sale_price) AS sales
from df_orders
group by sub_category,YEAR(order_date)
--order by YEAR(order_date), MONTH(order_date)
)
, cte2 as(
 Select sub_category 
 , Sum(case When order_year=2022 then sales else 0  end) AS sales_2022
  , Sum(case When order_year=2023 then sales else 0 end) AS sales_2023
 From cte
 group by sub_category
 )
 Select top 1 * 
 , (sales_2023-sales_2022)*100/sales_2022 As growth
 
 From cte2
 order by growth desc


 