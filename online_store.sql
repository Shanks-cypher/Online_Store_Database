CREATE DATABASE IF NOT EXISTS online_store;
USE online_store;

-- ========== CUSTOMERS ==========
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== PRODUCTS ==========
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ========== ORDERS ==========
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- ========== ORDER ITEMS ==========
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ========== PAYMENTS ==========
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    method VARCHAR(30) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- ========== TRIGGER: Auto-update stock ==========
DELIMITER //
CREATE TRIGGER reduce_stock_after_purchase
AFTER INSERT ON order_items
FOR EACH ROW 
BEGIN
    UPDATE products 
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //
DELIMITER ;

-- ========== SAMPLE DATA ==========
INSERT INTO customers (name, email, phone, address)
VALUES
('John Doe', 'john@example.com', '9876543210', 'New York'),
('Jane Smith', 'jane@example.com', '8765432109', 'California');

INSERT INTO products (name, category, price, stock_quantity)
VALUES
('Laptop', 'Electronics', 65000, 10),
('Headphones', 'Electronics', 2000, 50),
('T-shirt', 'Clothing', 800, 100);

INSERT INTO orders (customer_id, order_date, status)
VALUES
(1, '2025-10-04', 'Delivered'),
(2, '2025-10-03', 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, subtotal)
VALUES
(1, 1, 1, 65000),
(2, 2, 2, 4000);

INSERT INTO payments (order_id, amount, payment_date, method)
VALUES
(1, 65000, '2025-10-04', 'Credit Card');
