create database elevatelabs;
use elevatelabs;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Charu', 'Mumbai'),
(2, 'Rahul', 'Delhi'),
(3, 'Amit', 'Pune');

INSERT INTO orders VALUES
(101, 1, '2024-01-10', 500),
(102, 2, '2024-02-15', 800),
(103, 1, '2024-03-20', 1200);

INSERT INTO products VALUES
(1, 'Laptop', 50000),
(2, 'Phone', 20000),
(3, 'Headphones', 2000);

INSERT INTO order_items VALUES
(1, 101, 3, 2),
(2, 102, 2, 1),
(3, 103, 1, 1);

select * from customers;
select * from orders;
select * from products;
select * from order_items;

-- Get all orders above 600
SELECT * 
FROM orders
WHERE amount > 600
ORDER BY amount DESC;

-- Group by aggregrate functions
-- Total spending per customer
SELECT customer_id, SUM(amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- Average order value
SELECT AVG(amount) AS avg_order
FROM orders;

-- JOINS (INNER, LEFT)
-- INNER JOIN (customers with orders)
SELECT c.name, o.order_id, o.amount
FROM customers c
INNER JOIN orders o 
ON c.customer_id = o.customer_id;

-- LEFT JOIN (all customers, even without orders)
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- RIGHT JOIN 
SELECT c.name, o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

-- subquery
-- Customers who spent more than average
SELECT name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(amount) > (SELECT AVG(amount) FROM orders)
);

-- View Creation
CREATE VIEW customer_summary AS
SELECT c.name, SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

SELECT * FROM customer_summary;
CREATE INDEX idx_customer_id ON orders(customer_id);

-- Top spending customer
SELECT c.name, SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;