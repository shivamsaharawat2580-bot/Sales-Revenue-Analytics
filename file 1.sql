CREATE TABLE customerp1 (
customer_id int primary key,
customer_name VARCHAR(100),
email VARCHAR(100),
city VARCHAR (100),
state VARCHAR (100)
);

SELECT * FROM customerp1;

CREATE TABLE productp1 (
product_id int primary key,
product_name VARCHAR(100),
category VARCHAR(100),
brand VARCHAR (100),
price INT
);

SELECT * FROM productp1;

CREATE TABLE employeesp1 (
employee_id int primary key,
employee_name VARCHAR(100),
department VARCHAR (100)
);

SELECT * FROM employeep1;


CREATE TABLE orderp1 (
order_id int primary key,
customer_id INT,
employee_id INT,
order_date date
);
SELECT * FROM orderp1;

CREATE TABLE orderdetailsp1 (
order_detail_id int primary key,
order_id INT,
product_id INT,
quantity INT
);
SELECT * FROM orderdetailsp1;

 CREATE TABLE returnp1 (
return_id int primary key,
order_id INT,
return_date DATE,
return_reason VARCHAR (100)
);
SELECT * FROM returnp1;

--total revenue
SELECT SUM(p.price*od.quantity) AS total_revenue
FROM productp1 p 
JOIN orderdetailsp1 od ON p.product_id=od.product_id;


--monthly revenue
SELECT EXTRACT(month from o.order_date) AS month, EXTRACT(year from o.order_date) AS year,
TO_CHAR(o.order_date,'month') AS month_name,
sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
JOIN orderp1 o ON o.order_id=od.order_id
GROUP BY 1,2,3;

--revenue by category
SELECT p.category,sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
GROUP BY 1;

--revenue by city/state
SELECT c.city,c.state,sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
JOIN orderp1 o ON o.order_id=od.order_id
JOIN customerp1 c ON c.customer_id=o.customer_id
GROUP BY 1,2;

--revenue by employee id
SELECT e.employee_name,sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
JOIN orderp1 o ON o.order_id=od.order_id
JOIN employeep1 e ON e.employee_id=o.employee_id
GROUP BY 1;

--top 10 product by revenue
SELECT p.product_name,sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
GROUP BY 1
ORDER BY total_revenue desc LIMIT 10;

--revenue by quantity
SELECT p.product_name,sum(od.quantity) AS total_quantity
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
GROUP BY 1
ORDER BY total_quantity desc LIMIT 10;

--best category
SELECT p.category,sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
GROUP BY 1
ORDER BY total_revenue desc LIMIT 1;

--wrost category
SELECT p.category,sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
GROUP BY 1
ORDER BY total_revenue asc LIMIT 1;

---top 10 customers
SELECT c.customer_name,sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
JOIN orderp1 o ON o.order_id=od.order_id
JOIN customerp1 c ON c.customer_id=o.customer_id
GROUP BY 1
ORDER BY total_revenue desc LIMIT 10;

--customer revenue contribution
WITH customer_revenue AS (
SELECT c.customer_name,sum(p.price*od.quantity) AS total_revenue
FROM productp1 p
JOIN orderdetailsp1 od ON p.product_id=od.product_id
JOIN orderp1 o ON o.order_id=od.order_id
JOIN customerp1 c ON c.customer_id=o.customer_id
GROUP BY 1)
SELECT customer_name, total_revenue, 
 ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 2) AS revenue_contribution_pct
 FROM customer_revenue
 ORDER BY total_revenue desc;

--average order value
WITH average_order AS (
SELECT od.order_id,sum(p.price*od.quantity) AS total_value
FROM orderdetailsp1 od
JOIN productp1 p ON p.product_id=od.product_id
GROUP BY 1)
SELECT avg(total_value) AS average_order_value
FROM average_order;

--overall return rate
SELECT count(distinct r.order_id)*100.0/count(distinct o.order_id) AS return_rate
FROM orderp1 o
LEFT JOIN returnp1 r ON o.order_id=r.order_id;1

--return reason
 SELECT COUNT(distinct order_id) as total_return_order ,return_reason
 FROM returnp1
 GROUP BY 2;

 --HIGHEST SALES MONTH & LOWEST SALES MONTH
 SELECT TO_CHAR(o.order_date,'month') AS month_name,
 EXTRACT(year FROM o.order_date) AS year,
 SUM(p.price*od.quantity) AS total_sales
 FROM orderp1 o
 JOIN orderdetailsp1 od ON od.order_id=o.order_id
 JOIN productp1 p ON p.product_id=od.product_id
 GROUP BY 1,2
 ORDER BY total_sales desc LIMIT 1;
 
  SELECT TO_CHAR(o.order_date,'month') AS month_name,
   EXTRACT(year FROM o.order_date) AS year,
 SUM(p.price*od.quantity) AS total_sales
 FROM orderp1 o
 JOIN orderdetailsp1 od ON od.order_id=o.order_id
 JOIN productp1 p ON p.product_id=od.product_id
 GROUP BY 1,2
 ORDER BY total_sales asc LIMIT 1;

--monthly trends
 SELECT TO_CHAR(o.order_date,'month') AS month_name,
 EXTRACT(year FROM o.order_date) AS year,
 SUM(p.price*od.quantity) AS total_sales
 FROM orderp1 o
 JOIN orderdetailsp1 od ON od.order_id=o.order_id
 JOIN productp1 p ON p.product_id=od.product_id
 GROUP BY 1,2
 ORDER BY total_sales desc;

--YEAR OVER YEAR COMPARISION- mot correct 
 SELECT EXTRACT(year FROM o.order_date) AS year,
 SUM(p.price*od.quantity) AS total_sales
 FROM orderp1 o
 JOIN orderdetailsp1 od ON od.order_id=o.order_id
 JOIN productp1 p ON p.product_id=od.product_id
 GROUP BY 1
 ORDER BY total_sales desc; 









