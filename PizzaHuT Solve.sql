-- PIZAA HUT PROJECT --

SELECT * FROM Orders;
SELECT * FROM Order_Details;
SELECT * FROM Pizza_types;
SELECT * FROm Pizzas;

-- Retrieve the total number of orders placed
USE pizzahut;

SELECT 
    COUNT(order_id) AS Total_Orders
FROM
    orders;

-- Calculate The Total revenue generated from pizza sales

SELECT 
    ROUND(SUM(Orde.quantity * p.price), 2) AS Total_sales
FROM
    Order_details AS Orde
        JOIN
    Pizzas p ON p.pizza_id = orde.pizza_id;
    
    
-- Identity The Highest-Priced Pizza.

SELECT 
    pt.name, p.price
FROM
    pizza_types AS pt
        JOIN
    Pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identity The Most Most Comman pizza size ordered.

SELECT 
    p.Size, COUNT(orde.order_details_id) AS Order_count
FROM
    Pizzas AS p
        JOIN
    Order_details orde ON p.pizza_id = orde.pizza_id
GROUP BY p.size
ORDER BY Order_Count DESC;

-- List The  Top 5 Most Ordered Pizza Types along with Their Quantities.

SELECT 
    py.Name, SUM(orde.Quantity) AS Quantity
FROM
    pizza_types py
        JOIN
    pizzas p ON py.pizza_type_id = p.pizza_type_id
        JOIN
    Order_details orde ON orde.pizza_id = p.pizza_id
GROUP BY py.name
ORDER BY Quantity DESC
LIMIT 5;

-- Get The Data Quality , Size , Name And Sum Of Size? 

SELECT 
    order_details.Quantity, 
    COUNT(pizzas.Size) AS TOTAL_SIZE, 
    pizza_types.name 
FROM 
    order_details
JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN 
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 
    order_details.Quantity, pizza_types.name
ORDER BY 
    TOTAL_SIZE DESC;
    
    ----------------- Intermiiate ---------------
    
-- Join the neccessary tables to find the Total Quantity Of each category ordered

 SELECT 
    Pizza_types.category,
    SUM(order_details.Quantity) AS Quantity
FROM
    Pizza_Types
        JOIN
    Pizzas ON Pizza_Types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY Pizza_Types.category
ORDER BY Quantity DESC;

--  Determine the distribution of orders by hours of the days

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);

-- JOIN  Relevent Tables to Find the category-Wise Distribution of Pizzas

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY Category;

-- Group The Orders by date and calculate the Average number of pizzas ordered per day

SELECT 
    ROUND(AVG(Quantity), 0) AS AVG_Pizza_Ordered_Per_Day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.Quantity) AS Quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_Quantity;
    
    --  Determine the Top 3 Most ordered Pizza Type based ON revenue
    
   SELECT 
    Pizza_types.Name,
    SUM(Order_details.Quantity * Pizzas.Price) AS Revenue
FROM
    pizza_types
        JOIN
    Pizzas ON Pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.Name
ORDER BY revenue DESC
LIMIT 3;

------------------- ADAVANCED ---------------------

-- Calculate the Percentage Contribute of each Pizza type to total revenue

SELECT 
    pizza_types.category,
    ROUND(SUM(Order_details.Quantity * Pizzas.price) / (SELECT 
                    ROUND(SUM(Order_details.quantity * pizzas.price),
                                2) AS Total_sales
                FROM
                    Order_details
                        JOIN
                    Pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS Revenue
FROM
    Pizza_Types
        JOIN
    Pizzas ON Pizza_types.Pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY Pizza_Types.category
ORDER BY Revenue DESC;


-- Analyze The Cumulative revenue generate over time]

Select order_date,Sum(revenue) Over(order by order_date) AS Cum_Revenue
From
(Select orders.order_date,
Sum(order_details.Quantity * Pizzas.price) AS Revenue
From order_details 
JOIn Pizzas ON order_details.Pizza_id = pizzas.Pizza_id
JOIN Orders ON orders.order_id = order_details.order_id
group by orders.order_date) AS Sales;

-- Determine The Top 3 Most ordered Pizza Type Based On revenue for each pizza category

Select Name , revenue From
(select category , name , Revenue ,
Rank()over(partition by category order by revenue desc) AS Rn
From 
( Select pizza_types.Category , Pizza_Types.Name , 
Sum((Order_details.Quantity) * Pizzas.Price) AS Revenue
From Pizza_types JOIN Pizzas
ON Pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN Order_details ON order_details.pizza_id = Pizzas.pizza_id
Group By Pizza_types.category , pizza_types.name ) as A) AS B
Where rn <=3;

 





    
    






 


 