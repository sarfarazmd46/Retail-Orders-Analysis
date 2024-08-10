create database if not exists salesDataWalmart;

create table if not exists saless(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT decimal(6, 4) not null,
    total decimal(12,4) not null,
    `date` datetime not null,
    `time` TIME not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_percentage decimal(11,9),
    gross_income decimal(12,4) not null,
    rating decimal(2,1)
);
















# FEATURE ENGINEERING
#time_of_day column
SELECT 
	time,
	(case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:00:01" and "16:00:00" then "Afternoon"
        else "Evening"
	end
    ) as time_of_day
FROM sales;

alter table sales add column time_of_day varchar(20);
update sales
set time_of_day = (
	case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:00:01" and "16:00:00" then "Afternoon"
		else "Evening"
	end
);

#day_name column
select date , dayname(date) as day_name
from sales;
alter table sales add column day_name varchar(10);
update sales
set day_name = dayname(date);

#month_name
select date , monthname(date) as month_name
from sales;
alter table sales add column month_name varchar(10);
update sales
set month_name = monthname(date);



					#EDA
             #GENERIC QUESTOINS
#How many unique cities does the data have?
select distinct city as city , count(city)
from sales
group by city;

#In which city is each branch?
select distinct city,branch
from sales;

             #PRODUCT QUESTIONS
#How many unique product lines does the data have?
select count(distinct product_line) as count
from sales;

#What is the most common payment method?
select distinct payment_method as payment_method , count(payment_method) as count
from sales
group by payment_method
order by count desc
limit 1;

#What is the most selling product line?
select product_line , count(product_line)
from sales
group by product_line
order by count(product_line) desc
limit 1;

#What is the total revenue by month?
select month_name , sum(total) as revenue
from sales
group by month_name;

#What month had the largest COGS?
select month_name , sum(cogs)
from sales
group by month_name
order by sum(cogs) desc
limit 1;

#What product line had the largest revenue?
select product_line , sum(total) as revenue
from sales
group by product_line
order by revenue desc
limit 1;

#What is the city with the largest revenue?
select city , sum(total) as revenue
from sales
group by city
order by revenue desc
limit 1;

#Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

#Which branch sold more products than average product sold?
select branch , sum(quantity) as quantity
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

					#SALES QUESTIONS
#Number of sales made in each time of the day per weekday
select time_of_day , count(*) as total_sales
from sales
where day_name = "Sunday"
group by time_of_day
order by total_sales desc;

#Which of the customer types brings the most revenue?
select customer_type , sum(total) as revenue
from sales
group by customer_type;

#Which city has the largest tax percent/ VAT (Value Added Tax)?
select city , avg(VAT)
from sales
group by city;

#Which customer type pays the most in VAT?
select customer_type , sum(VAT)
from sales
group by customer_type
order by sum(VAT) desc;

			    #CUSTOMER QUESTIONS
-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;


-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;
