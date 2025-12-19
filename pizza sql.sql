create database pizzahut;
use pizzahut;


select * from pizzas;
select * from pizza_types;

create table Orders(order_id int not null,
order_Date date not null ,order_time time not null,
primary key(order_id));
select * from Orders limit 10;

create table Order_details(order_details_id int not null, order_id int not null,
pizza_id text not null ,quantity int not null,
primary key(order_details_id));

select * from Order_details limit 10;




select count(order_id) from Orders;

SELECT 
    round(SUM(p.price * od.quantity),2) AS Total_Revenue
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id; 



select t.name , t.category , p.price from pizza_types t
join pizzas p  on p.pizza_type_id = t.pizza_type_id 
order by p.price  desc limit 1;





select p.size , (p.price * od.quantity) total_price
from pizzas p
join order_details od on p.pizza_id = od.pizza_id
order by total_price desc limit 1;







select p.size,count(od.order_details_id) quantity from pizzas p join order_details od 
on p.pizza_id = od.pizza_id
group by p.size 
order by quantity desc  limit 1;



-- List the top 5 most ordered pizza types along with their quantities.
select t.name ,sum(od.quantity) quantity from pizzas p
join pizza_types t on p.pizza_type_id = t.pizza_type_id
join  order_details od on p.pizza_id = od.pizza_id
group by t.name
order by quantity desc limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.
select t.category ,sum(od.quantity) totalquantity from pizzas p
join pizza_types t on p.pizza_type_id = t.pizza_type_id
join  order_details od on p.pizza_id = od.pizza_id
group by t.category;

-- Determine the distribution of orders by hour of the day.

select hour(order_time) By_hour ,count(order_id) from orders 
group by by_hour ;


-- Join relevant tables to find the category-wise distribution of pizzas.
select t.category , count(name) from pizza_types t  
group by t.category;

-- Group the orders by date and calculate the average number of pizzas ordered per day. 
select round(avg(quantity),0) from (select sum(od.quantity) quantity,o.order_date from
order_details od   
join orders o on o.order_id =od.order_id
group by o.order_date) order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.


select t.name,sum(p.price*od.quantity) Total_Reveune from pizza_types t
join pizzas p on t.pizza_type_id=p.pizza_type_id
join order_details od on p.pizza_id=od.pizza_id
group by t.name
order by Total_Reveune desc limit 3 ;

-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT t.category,ROUND(SUM(p.price * od.quantity) /
(SELECT SUM(p.price * od.quantity) total_sale 
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id) * 100,2) AS revenue 
FROM pizza_types t JOIN pizzas p ON t.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY t.category
ORDER BY revenue DESC
LIMIT 3;

-- Analyze the cumulative revenue generated over time.
select order_Date , sum(revenue) over(order by order_Date) as cum_relative from 
(select o.order_Date , sum(od.quantity*p.price) as revenue from 
pizzas p join order_details od on p.pizza_id = od.pizza_id 
join orders o on o.order_id = od.order_id
group by o.order_Date) as sales ;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category , name , Total_revenue, rank() over(partition by category order by Total_revenue desc) as rn from
(select t.category,t.name, round(sum(od.quantity*p.price),0) Total_revenue from pizzas p
join order_details od on od.pizza_id = p.pizza_id
join pizza_types t on t.pizza_type_id = p.pizza_type_id
group by t.category,t.name) as a;



