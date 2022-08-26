-- Insert data from csv file into created tables

LOAD DATA INFILE -- <Enter file location here> --
INTO TABLE students
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, first_name, last_name, @DOB)
SET dob = STR_TO_DATE(@DOB, '%d/%m/%Y');

LOAD DATA INFILE -- <Enter file location here> --
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, product_type, product_brand, product_model, stock);