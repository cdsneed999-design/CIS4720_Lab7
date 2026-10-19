/* ==========================================================================
   lab6_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   This rebuilds everything in_class_lab6 asked you to build, so that whatever
   happened in the lab, you now have the same working database as everyone
   else. The lab PCs are wiped every night, which is why the database you
   built last time is not there any more. A script like this one is the real
   answer to that problem: the file is the database, and the server is
   disposable.

   WHAT IT BUILDS
     1. A schema called cis4720_yourname
     2. One table, PRODUCT, with five columns and a primary key
     3. Four rows of data
     4. One view, PRODUCT_PRICES, showing only the name and the price

   The extra credit from lab6 is deliberately NOT in here.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected, then run it one statement at a
   time, or run the whole file. Lab7 walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you will get errors,
   because the table already exists and the rows are already there. Lab7
   explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the following statements apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice.
CREATE DATABASE IF NOT EXISTS cis4720_Sneed;

-- Switch into it. Everything below lands inside this schema.
USE cis4720_Sneed;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
-- INT           whole numbers, used here for the id
-- VARCHAR(40)   text up to 40 characters
-- DECIMAL(7,2)  a number with exactly 2 decimal places, correct for money
-- DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means prod_id must be unique and may never be empty.
-- ======================================================================

/*
CREATE TABLE PRODUCT (
    prod_id     INT          NOT NULL,
    prod_name   VARCHAR(40)  NOT NULL,
    unit_price  DECIMAL(7,2),
    added_on    DATE,
    roast_level VARCHAR(10),
    PRIMARY KEY (prod_id)
);


-- ======================================================================
-- SECTION 3. The data
-- Four rows. In lab6 you added the first three by hand, then Antigua Classic
-- came later. The roast_level column was added with ALTER TABLE in lab6 and
-- is simply part of the table here.
-- ======================================================================

INSERT INTO PRODUCT VALUES (1,'Yirgacheffe',    18.50,'2026-01-15','Light');
INSERT INTO PRODUCT VALUES (2,'Huila Supremo',  15.25,'2026-03-02','Medium');
INSERT INTO PRODUCT VALUES (3,'Cerrado Daily',  12.60,'2026-05-20','Medium');
INSERT INTO PRODUCT VALUES (4,'Antigua Classic',16.80,'2026-07-04','Medium');


-- ======================================================================
-- SECTION 4. The view
-- A view is a stored SELECT statement that you can query as if it were a
-- table. This one shows only the name and the price, so anyone using it
-- cannot reach the id, the date or the roast level.
-- ======================================================================

CREATE VIEW PRODUCT_PRICES AS
SELECT prod_name, unit_price
FROM PRODUCT;


-- ======================================================================

*/
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so leave
-- them uncommented even after the first run.
-- ======================================================================

-- All four rows, straight from the table.
SELECT * FROM PRODUCT;

-- The view, most expensive first. Two columns, not five.
SELECT * FROM PRODUCT_PRICES ORDER BY unit_price DESC;

-- Should come back as 4 products and 63.15.
SELECT COUNT(*) AS products, SUM(unit_price) AS total_price FROM PRODUCT;

-- PRODUCT is a BASE TABLE and PRODUCT_PRICES is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7 WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 10. Section 5.1, look at your schema

-- This shows which database I am currently using.
SELECT DATABASE() AS my_schema;

-- This lists the tables and views in my database.
SHOW FULL TABLES FROM cis4720_Sneed;


-- STEP 11. Section 5.2, look at the data types

-- This shows the columns and data types in the PRODUCT table.
DESCRIBE cis4720_Sneed.PRODUCT;


-- STEP 12. Section 5.3, create a table by copying with a subquery

-- This copies the product ID, name, and price into a new table.
CREATE TABLE cis4720_Sneed.PRODUCT_COPY AS
SELECT prod_id, prod_name, unit_price
FROM cis4720_Sneed.PRODUCT;

-- This displays the four products in the copied table.
SELECT * FROM cis4720_Sneed.PRODUCT_COPY;

-- This shows how MySQL created the table and whether it has constraints.
SHOW CREATE TABLE cis4720_Sneed.PRODUCT_COPY;


-- STEP 13. Section 5.4, change the structure of the copy

-- This adds a temporary column to the copied table.
ALTER TABLE cis4720_Sneed.PRODUCT_COPY
ADD COLUMN on_sale CHAR(1);

-- This allows longer product names while still requiring a name.
ALTER TABLE cis4720_Sneed.PRODUCT_COPY
MODIFY COLUMN prod_name VARCHAR(60) NOT NULL;

-- This prevents duplicate product IDs.
ALTER TABLE cis4720_Sneed.PRODUCT_COPY
ADD PRIMARY KEY (prod_id);

-- This displays the updated column definitions and primary key.
DESCRIBE cis4720_Sneed.PRODUCT_COPY;

-- This tests whether a duplicate product ID is rejected.
-- Expected error: 1062. Uncomment only when testing.
-- INSERT INTO cis4720_Sneed.PRODUCT_COPY
-- VALUES (1, 'Duplicate', 9.99, NULL);

-- This removes the temporary column.
ALTER TABLE cis4720_Sneed.PRODUCT_COPY
DROP COLUMN on_sale;


-- STEP 14. Section 5.5, insert, update and delete a row

-- This adds a new coffee product to the copied table.
INSERT INTO cis4720_Sneed.PRODUCT_COPY
(prod_id, prod_name, unit_price)
VALUES (5, 'Kenya Peaberry', 21.40);

-- This confirms that the new product was added.
SELECT * FROM cis4720_Sneed.PRODUCT_COPY WHERE prod_id = 5;

-- This changes the new product's price.
UPDATE cis4720_Sneed.PRODUCT_COPY
SET unit_price = 22.95
WHERE prod_id = 5;

-- This checks that the new price was saved.
SELECT * FROM cis4720_Sneed.PRODUCT_COPY WHERE prod_id = 5;

-- This removes the new product.
DELETE FROM cis4720_Sneed.PRODUCT_COPY
WHERE prod_id = 5;

-- This counts the products remaining after the deletion.
SELECT COUNT(*) AS rows_left
FROM cis4720_Sneed.PRODUCT_COPY;


-- STEP 15. Section 5.6, create a view and update through it

-- This creates a view of products priced below sixteen dollars.
CREATE VIEW cis4720_Sneed.CHEAP_PRODUCTS AS
SELECT prod_id, prod_name, unit_price
FROM cis4720_Sneed.PRODUCT_COPY
WHERE unit_price < 16.00;

-- This displays the products in the view.
SELECT * FROM cis4720_Sneed.CHEAP_PRODUCTS;

-- This checks the price before updating through the view.
SELECT prod_id, unit_price
FROM cis4720_Sneed.PRODUCT_COPY
WHERE prod_id = 3;

-- This changes a product price through the view.
UPDATE cis4720_Sneed.CHEAP_PRODUCTS
SET unit_price = 13.99
WHERE prod_id = 3;

-- This confirms that the copied table received the price change.
SELECT prod_id, unit_price
FROM cis4720_Sneed.PRODUCT_COPY
WHERE prod_id = 3;

-- This creates a summary view using aggregate functions.
CREATE VIEW cis4720_Sneed.PRICE_SUMMARY AS
SELECT COUNT(*) AS n, SUM(unit_price) AS total
FROM cis4720_Sneed.PRODUCT_COPY;

-- This attempts to update the summary view.
-- Expected error: 1288, because aggregate views are not updatable.
-- UPDATE cis4720_Sneed.PRICE_SUMMARY SET total = 99;
