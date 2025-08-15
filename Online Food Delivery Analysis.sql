CREATE DATABASE food_delivery;
USE food_delivery;

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    email VARCHAR(100),
    signup_date DATE
);

-- Restaurants Table
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    cuisine_type VARCHAR(50),
    rating DECIMAL(2,1) -- 1.0 to 5.0
);

-- Menu Items Table
CREATE TABLE menu_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    item_name VARCHAR(100),
    price DECIMAL(10,2),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Delivery Staff Table
CREATE TABLE delivery_staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    phone VARCHAR(20)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    restaurant_id INT,
    staff_id INT,
    order_time DATETIME,
    delivery_time DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (staff_id) REFERENCES delivery_staff(staff_id)
);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

-- Customers
INSERT INTO customers (name, email, signup_date) VALUES
('Alice Johnson', 'alice@example.com', '2023-01-15'),
('Bob Smith', 'bob@example.com', '2023-02-20'),
('Charlie Brown', 'charlie@example.com', '2023-03-10');

-- Restaurants
INSERT INTO restaurants (name, cuisine_type, rating) VALUES
('Pizza Palace', 'Italian', 4.5),
('Sushi World', 'Japanese', 4.8),
('Burger Hub', 'Fast Food', 4.2);

-- Menu Items
INSERT INTO menu_items (restaurant_id, item_name, price) VALUES
(1, 'Margherita Pizza', 8.99),
(1, 'Pepperoni Pizza', 10.99),
(2, 'California Roll', 12.50),
(2, 'Salmon Sushi', 14.00),
(3, 'Cheeseburger', 6.50),
(3, 'Fries', 2.99);

-- Delivery Staff
INSERT INTO delivery_staff (name, phone) VALUES
('David Lee', '1234567890'),
('Emma Davis', '9876543210');

-- Orders
INSERT INTO orders (customer_id, restaurant_id, staff_id, order_time, delivery_time) VALUES
(1, 1, 1, '2023-08-10 12:15:00', '2023-08-10 12:40:00'),
(2, 2, 2, '2023-08-10 18:30:00', '2023-08-10 18:55:00'),
(3, 3, 1, '2023-08-11 14:20:00', '2023-08-11 14:45:00'),
(1, 1, 2, '2023-08-11 20:00:00', '2023-08-11 20:25:00'),
(2, 3, 1, '2023-08-12 09:10:00', '2023-08-12 09:35:00');

-- Order Items
INSERT INTO order_items (order_id, item_id, quantity) VALUES
(1, 1, 1),  -- Alice orders Margherita Pizza
(1, 2, 1),  -- Alice orders Pepperoni Pizza
(2, 3, 2),  -- Bob orders California Roll
(3, 5, 2),  -- Charlie orders Cheeseburger
(3, 6, 1),  -- Charlie orders Fries
(4, 2, 2),  -- Alice orders Pepperoni Pizza
(5, 6, 3);  -- Bob orders Fries

-- 1. Most Ordered Dishes
SELECT m.item_name, SUM(oi.quantity) AS total_orders
FROM order_items oi
JOIN menu_items m ON oi.item_id = m.item_id
GROUP BY m.item_id
ORDER BY total_orders DESC;

-- 2. Restaurant Ratings & Performance (total orders + avg rating)
SELECT r.name AS restaurant_name,
       r.cuisine_type,
       r.rating,
       COUNT(o.order_id) AS total_orders
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id
ORDER BY total_orders DESC;

-- 3. Delivery Time Analysis (average delivery duration in minutes)
SELECT r.name AS restaurant_name,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, o.order_time, o.delivery_time)), 2) AS avg_delivery_minutes
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id
ORDER BY avg_delivery_minutes ASC;

-- 4. Peak Ordering Hours
SELECT HOUR(order_time) AS order_hour,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC;
