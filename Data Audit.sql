CREATE SCHEMA IF NOT EXISTS sushi
    AUTHORIZATION postgres;
SET search_path To sushi;

CREATE Table sushi_customers(
             customer_id int PRIMARY KEY,
			 segment VARCHAR(35),
			 drinks_alcohol BOOLEAN,
			 is_local BOOLEAN,
			 joined_date DATE
);

CREATE TABLE sushi_staff(
           role VARCHAR(35),
		   base_hourly_rate_2015 NUMERIC(12,2),
		   hire_date DATE,
		   termination_date DATE
);

CREATE TABLE sushi_reviews(
        order_id INT ,
		date DATE,
		rating INT CHECK (rating BETWEEN 1 AND 5),
		channel VARCHAR(35),
		year INT,
		CONSTRAINT fk_reviews_order FOREIGN KEY (order_id) 
		REFERENCES sushi_orders(order_id)
);


CREATE TABLE sushi_orders (
   order_id INT PRIMARY KEY,
   date DATE,
   year INT,
   month INT CHECK (MONTH BETWEEN 1 AND 12),
   quarter INT CHECK (QUARTER BETWEEN 1 AND 4),
   day_of_week VARCHAR(10),
   is_weekend BOOLEAN,
   is_holiday BOOLEAN,
   customer_id INT,
   customer_segment VARCHAR(35),
   is_local BOOLEAN,
   channel VARCHAR(35),
   party_size INT,
   revenue NUMERIC(12,2),
   cogs NUMERIC(12,2),
   gross_profit NUMERIC(12,2),
   discount NUMERIC(12,2),
   tip NUMERIC(12,2),
   delivery_fee NUMERIC(12,2),
   total_collected NUMERIC(12,2),
   rating INT CHECK (rating BETWEEN 1 AND 5),
   CONSTRAINT fk_orders_customer_id FOREIGN KEY (customer_id)
   REFERENCES sushi_customers(customer_id)
   );

CREATE TABLE sushi_order_items(
          order_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            order_id  INT NOT NULL,
            date DATE,
			item VARCHAR(55),
			category VARCHAR(35),
			unit_price NUMERIC(12,2),
			cogs NUMERIC(12,2),
			gross_profit NUMERIC(12,2),
			CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
			REFERENCES sushi_orders(order_id)
           );

		   
CREATE TABLE sushi_daily_pnl(
       date DATE,
	   year INT,
	   month INT  CHECK (MONTH BETWEEN 1 AND 12),
	   quarter INT  CHECK (quarBETWEEN 1 AND 4),
	   day_of_week VARCHAR(15),
	   is_weekend BOOLEAN,
	   is_holiday BOOLEAN,
	   covers INT,
	   gross_revenue NUMERIC(12,2),
	   cogs  NUMERIC(12,2),
	   gross_profit  NUMERIC(12,2),
	   labour_cost NUMERIC(12,2),
	   fixed_ops_cost NUMERIC(12,2),
	   operating_profit NUMERIC(12,2),
	   gp_margin_pct NUMERIC(12,2)
);

SELECT 
    
    order_id,
    data_type
FROM information_schema.columns
WHERE table_schema = 'sushi'
ORDER BY table_name, ordinal_position;

SELECT COUNT(*)
FROM sushi_daily_pnl;

 SELECT order_id, COUNT(*) AS COUNT 
 FROM sushi_orders
 GROUP BY order_id
 HAVING COUNT(*) > 1;

 ----Check the number of records---
 
SELECT 'customer_id' AS customers, COUNT(*) AS rows
FROM sushi_customers

UNION ALL

SELECT 'role' AS staff, COUNT(*) AS rows
FROM sushi_staff

UNION ALL

SELECT 'rating' AS reviews, COUNT(*)
FROM sushi_reviews

UNION ALL

SELECT 'order_id' As orders, COUNT(*)
FROM sushi_orders

UNION ALL

SELECT 'item' As order_items, COUNT(*)
FROM sushi_order_items

UNION ALL

SELECT 'order_id' As daily_pnl, COUNT(*)
FROM sushi_daily_pnl;