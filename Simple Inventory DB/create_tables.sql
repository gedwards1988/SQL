-- Create the 3 basic tables for our Shop Inventorystock_change

CREATE TABLE students
(
	id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE products
(
	id INT AUTO_INCREMENT NOT NULL,
    product_type VARCHAR(50) NOT NULL,
    product_brand VARCHAR(100) NOT NULL,
    product_model VARCHAR(250) NOT NULL,
    stock INT NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE orders
(
	order_id INT AUTO_INCREMENT NOT NULL,
    product_id INT NOT NULL,
    student_id INT NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY(order_id),
    FOREIGN KEY(product_id) REFERENCES products(id),
    FOREIGN KEY(student_id) REFERENCES students(id)
);

CREATE TABLE stock_change
(
	id INT AUTO_INCREMENT NOT NULL,
    order_id INT,
    before_quantity INT,
    after_quantity INT,
    changedAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
);