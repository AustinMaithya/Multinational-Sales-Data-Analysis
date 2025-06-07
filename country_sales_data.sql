-- Importing data from different csv workbooks and joining the data using union all since they have the same columns
-- creating a new table with all the data combined 
create table country_sales_data as
SELECT *
 FROM sales_data.sales_canada
 Union all 
 SELECT *
 FROM sales_data.sales_china 
 Union all 
 SELECT *
 FROM sales_data.sales_india
 Union all 
 SELECT *
 FROM sales_data.sales_nigeria
 Union all 
 SELECT *
 FROM sales_data.sales_uk
 Union all 
 SELECT *
 FROM sales_data.sales_us;
 
 -- cleaning data
		-- checking nulls 
 
 select * 
 from country_sales_data
 where Country is null or Price_per_Unit is null or Quantity_Purchased is null
		or Cost_Price is null or Discount_Applied is null ;

-- checking duplicates 
with check_duplicates as 
(
select Country, 
	Transaction_ID,
    row_number()over(partition by Transaction_ID,Country,Product_ID order by Country) as row_num
from country_sales_data) 
select Country, row_num
from check_duplicates
where row_num > 1;
        
	select *
    from country_sales_data;
 
 -- SALES PERFORMANCE QUESTIONS 
 -- Which country is generating the highest sales revenue?
 select Country,  ROUND(SUM((Price_per_Unit*Quantity_Purchased) - Discount_Applied),2)as Total_Sales
 from country_sales_data
 group by Country
 order by Total_Sales desc
 limit 1
;

-- What are the monthly/quarterly/yearly sales trends?
select *
from country_sales_data;



-- What is the average order value by country or product?
Select Category,Country,avg(Quantity_Purchased) as avg_order_value
from country_sales_data
group by Category,Country
;


-- Which products or categories are selling best by region?
select Category,Country,ROUND(SUM((Price_per_Unit*Quantity_Purchased) - Discount_Applied),2)as Total_Revenue
from country_sales_data
group by Category,Country
order by Total_Sales desc
Limit 1 ;

alter table country_sales_data
add column Total_Revenue double ;

update country_sales_data
set Total_Revenue = (Price_per_Unit*Quantity_Purchased) - Discount_Applied;
-- Which markets are underperforming?

select Category,Country,ROUND(SUM(Total_Revenue),2) as Total_Sales
from country_sales_data
group by Category,Country
order by Total_Sales asc
limit 5;

-- profit by category
select Category, (sum(Total_Revenue) - (sum(Quantity_Purchased*Cost_Price))) as Profit
from country_sales_data
group by Category
order by Profit desc;
-- profit by country
select Country, (sum(Total_Revenue) - (sum(Quantity_Purchased*Cost_Price))) as Profit
from country_sales_data
group by Country
order by Profit desc;



