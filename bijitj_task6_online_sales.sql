create database onlinesales;
use onlinesales;


-- Step 1: Data cleaning and reprocessing on details table
-- finding duplicates in details table
select count(*) from details;
select distinct count(*) from details;


-- renaming table columns
alter table details
rename column `Order ID` to order_id,
rename column `Sub-category` to sub_category;


-- finding null values in details table
select * from details
where 
order_id is null
or
amount is null
or 
profit is null
or 
quantity is null
or 
category is null
or
sub_category is null
or
paymentmode is null;


-- creating new column revenue
alter table details
add column revenue float;
update details
set revenue= details.amount*details.quantity;


-- Step 2: Data cleaning and preprocessing on orders table
-- finding null values in orders table
select count(*) from orders;
select distinct count(*) from orders;


-- renaming column names
alter table orders
rename column `Order ID` to order_id,
rename column `Order Date` to order_date,
rename column `CustomerName` to cust_name;


-- finding null values
select * from orders
where 
order_id is null
or
order_date is null
or
cust_name is null
or
state is null
or
city is null;


-- adding month column in orders table
alter table orders
add column order_month varchar(10);
update orders
set order_month=monthname(order_date);


-- changing order_date data
alter table orders
modify `order_date` DATE;


-- Step 3: Data analysis
-- Q1: What is the total revenue in 2018?
select sum(amount) as total_revenue
from details;

-- Q2: What is the total profit in 2018?
select sum(profit) as total_profit
from details;

-- Q3: what is the revenue of the company in each month?
select orders.order_month,sum(details.revenue) as monthly_revenue
from orders
join details
on orders.order_id=details.order_id
group by orders.order_month
order by field(order_month, 'January','February','March','April','May','June','July','August',
'September','October','November','December') asc;

-- Q4: Arrange profit in each month in descending order
select orders.order_month,sum(details.profit) as monthly_profit
from orders
join details
on orders.order_id=details.order_id
group by orders.order_month 
order by monthly_profit desc;


-- Q5: Select top 10 highest revenue generating state
select orders.state,sum(details.revenue) as state_revenue
from orders
join details
on orders.order_id=details.order_id
group by orders.state 
order by state_revenue desc
limit 10;


-- Q6: Select bottom 5 state with lowest profit generating 
select orders.state,sum(details.profit) as state_profit
from orders
join details
on orders.order_id=details.order_id
group by orders.state 
order by state_profit asc
limit 5;


-- Q7: Which top 3 date has the highest number of orders?
select orders.order_date, count(details.order_id) as counts
from orders
join details
on orders.order_id=details.order_id
group by orders.order_date
order by counts desc
limit 3;


-- Q8: Give the month wise order
select orders.order_month, count(details.order_id) as counts
from orders
join details
on orders.order_id=details.order_id
group by orders.order_month
order by counts desc;


-- Q9: Which sub category of products has highest sold units. Retrieve the top 10
select sub_category, sum(quantity) as total_units
from details
group by sub_category
order by total_units desc
limit 10 ;


-- Q10: Which category of products has highest revenue?
select category, sum(revenue) as category_revenue
from details
group by category
order by category_revenue desc;


-- Q11: Which is the highest used payment method?
select paymentmode, count(paymentmode) as counts
from details
group by paymentmode
order by counts desc;


-- Q12: Through which payment method, highest revenue achieves?
select paymentmode, sum(revenue) as revenue
from details
group by paymentmode
order by revenue desc;


