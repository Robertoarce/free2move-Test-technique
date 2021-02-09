-- AGENDA

--1) Drop all tables.
--2) Create customer table.
--3) Create items    table.
--4) Create orders   table.
--5) Create products table.

-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------

-- 1) Make sure tables are non existant:

DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;

-- 2) Create first table : customer:


CREATE TABLE customer (

    customer_id                 VARCHAR (40) PRIMARY KEY,
    customer_unique_id          VARCHAR (40),
    customer_zip_code_prefix    VARCHAR(7),
    customer_city               VARCHAR (40),
    customer_state              VARCHAR (5)
);

-- Feed table with csv
\copy customer FROM 'fixed_customer.csv' WITH (FORMAT csv , DELIMITER ",", HEADER);
 

-- 2) Create table : items:

CREATE TABLE items (
id                  VARCHAR (40) PRIMARY KEY,
order_id            VARCHAR (40),
order_item_id       numeric (2),
product_id          VARCHAR (40),
seller_id           VARCHAR (40),
shipping_limit_date timestamp (6),
price               numeric (40),
freight_value       numeric (40),
shipping_limit_day  timestamp (6) 
);

--import data 

\copy items FROM 'fixed_items.csv' WITH (FORMAT csv , DELIMITER ",", HEADER);


-- 3) Create table : orders:

CREATE TABLE orders (
order_id	 	                      VARCHAR(40) PRIMARY KEY,
customer_id	 	                    VARCHAR(40),
order_status	 	                  VARCHAR(20),
order_purchase_timestamp	 	      VARCHAR(40),
order_approved_at	 	              VARCHAR(40),
order_delivered_carrier_date	 	  VARCHAR(40),
order_delivered_customer_date	 	  VARCHAR(40),
order_estimated_delivery_date	 	  VARCHAR(40),
order_purchase_timestamp_day	 	  VARCHAR(40),
order_approved_at_day	 	          VARCHAR(40),
order_delivered_carrier_date_day	timestamp(6),
order_delivered_customer_date_day	timestamp(6),
order_estimated_delivery_date_day	timestamp(6)
);

--import data

\copy orders FROM 'fixed_orders.csv' WITH (FORMAT csv , DELIMITER ",", HEADER);


-- 4) Create table : products:


CREATE TABLE products (
 product_id	 VARCHAR(40),
product_category_name	 VARCHAR(40),
product_name_lenght	 numeric(40),
product_description_lenght	 numeric(40),
product_photos_qty	 numeric(40),
product_weight_g	 numeric(40),
product_length_cm	 numeric(40),
product_height_cm	 numeric(40),
product_width_cm	 numeric(40),
product_category_name_english	 VARCHAR(40)
);
 \copy products FROM 'fixed_products.csv' WITH (FORMAT csv , DELIMITER ",", HEADER);

----------------------------------------------------------------
----------------------------------------------------------------