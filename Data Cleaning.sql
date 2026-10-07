----Checking Null values----

SELECT 
     COUNT(*) AS total_rows,
	 COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
     COUNT(*) FILTER (WHERE segment IS NULL) AS null_segment,
     COUNT(*) FILTER (WHERE drinks_alcohol IS NULL) AS null_drinks_alcohol,
	 COUNT(*) FILTER (WHERE is_local IS NULL) AS null_is_local,
	 COUNT(*) FILTER (WHERE joined_date IS NULL) AS null_joined_date		 	 
      from sushi_customers;

SELECT 
     COUNT(*) AS total_rows,
	 COUNT(*) FILTER (WHERE role  IS NULL) AS null_role,
     COUNT(*) FILTER (WHERE base_hourly_rate_2015 IS NULL) AS null_base_hourly_rate_2015,
     COUNT(*) FILTER (WHERE hire_date IS NULL) AS null_hire_date,
	 COUNT(*) FILTER (WHERE termination_date IS NULL) AS null_termination_date
	 from sushi_staff;

SELECT 
     COUNT(*) AS total_rows,
     COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
     COUNT(*) FILTER (WHERE date IS NULL) AS null_date,
     COUNT(*) FILTER (WHERE rating IS NULL) AS null_rating,
	 COUNT(*) FILTER (WHERE channel IS NULL) AS null_channel,
	 COUNT(*) FILTER (WHERE year IS NULL) AS null_year
	 from sushi_reviews;

SELECT 
     COUNT(*) AS total_rows,
	 COUNT(*) FILTER (WHERE order_id  IS NULL) AS null_order_id,
     COUNT(*) FILTER (WHERE date IS NULL) AS null_date,
     COUNT(*) FILTER (WHERE year IS NULL) AS null_year,
	 COUNT(*) FILTER (WHERE month IS NULL) AS null_month, 
	 COUNT(*) FILTER (WHERE quarter IS NULL) AS null_quarter,
	  COUNT(*) FILTER (WHERE day_of_week IS NULL) AS null_day_of_week,
     COUNT(*) FILTER (WHERE is_weekend IS NULL) AS null_is_weekend,
     COUNT(*) FILTER (WHERE is_holiday IS NULL) AS null_is_holiday,
	 COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
	 COUNT(*) FILTER (WHERE customer_segment IS NULL) AS null_customer_segment,
	 COUNT(*) FILTER (WHERE is_local  IS NULL) AS null_is_local,
     COUNT(*) FILTER (WHERE channel IS NULL) AS null_channel,
     COUNT(*) FILTER (WHERE party_size IS NULL) AS null_party_size,
	 COUNT(*) FILTER (WHERE revenue IS NULL) AS null_revenue, 
	 COUNT(*) FILTER (WHERE  cogs IS NULL) AS null_cogs,
	  COUNT(*) FILTER (WHERE gross_profit IS NULL) AS null_gross_profit,
     COUNT(*) FILTER (WHERE discount IS NULL) AS null_discount,
     COUNT(*) FILTER (WHERE tip IS NULL) AS null_tip,
	 COUNT(*) FILTER (WHERE delivery_fee IS NULL) AS null_delivery_fee,
	 COUNT(*) FILTER (WHERE total_collected IS NULL) AS null_total_collected,
	 COUNT(*) FILTER (WHERE rating IS NULL) As null_rating
	 from sushi_orders;

SELECT 
     COUNT(*) AS total_rows,
     COUNT(*) FILTER (WHERE date IS NULL) AS null_date,
     COUNT(*) FILTER (WHERE year IS NULL) AS null_year,
	 COUNT(*) FILTER (WHERE month IS NULL) AS null_month, 
	 COUNT(*) FILTER (WHERE quarter IS NULL) AS null_quarter,
	  COUNT(*) FILTER (WHERE day_of_week IS NULL) AS null_day_of_week,
     COUNT(*) FILTER (WHERE is_weekend IS NULL) AS null_is_weekend,
     COUNT(*) FILTER (WHERE is_holiday IS NULL) AS null_is_holiday,
	 COUNT(*) FILTER (WHERE covers IS NULL) AS null_covers,
	 COUNT(*) FILTER (WHERE gross_revenue IS NULL) AS null_gross_revenue, 
	 COUNT(*) FILTER (WHERE  cogs IS NULL) AS null_cogs,
     COUNT(*) FILTER (WHERE gross_profit IS NULL) AS null_gross_profit,
     COUNT(*) FILTER (WHERE  labour_cost IS NULL) AS null_labour_cost,
	 COUNT(*) FILTER (WHERE fixed_ops_cost IS NULL) AS null_fixed_ops_cost ,
	 COUNT(*) FILTER (WHERE operating_profit IS NULL) AS null_operating_profit, 
	 COUNT(*) FILTER (WHERE  gp_margin_pct IS NULL) AS null_gp_margin_pct
	 from sushi_daily_pnl;

-----Duplicate checks----

SELECT 
     customer_id, COUNT(*) AS count
	 FROM sushi_customers
	 GROUP BY customer_id
	 HAVING COUNT(*) > 1;

SELECT 
     order_id, COUNT(*) AS count
	 FROM sushi_orders
	 GROUP BY order_id
	 HAVING COUNT(*) > 1;


SELECT 
     order_id, COUNT(*) AS review_count
	 FROM sushi_reviews
	 GROUP BY order_id
	 HAVING COUNT(*) > 1;

SELECT 
     order_id, COUNT(*) AS item_count
	 FROM sushi_order_items
	 GROUP BY order_id
	 HAVING COUNT(*) > 1
	 ORDER BY item_count DESC;

	 
-----Checking invalid values---
SELECT 
    FROM sushi_orders
	WHERE rating IS NOT NULL
	  AND (rating < 1 OR rating > 5);

SELECT 
    FROM sushi_reviews
	WHERE rating IS NOT NULL
	  AND (rating < 1 OR rating > 5);

SELECT 
     FROM sushi_order_items
	 WHERE unit_price <= 0;

SELECT 
     FROM sushi_orders
	 WHERE date IS NULL;

---Orphan checks--

 SELECT o.order_id,
        o.customer_id
 FROM sushi_orders o
 LEFT JOIN sushi_customers c
    ON o.customer_id = c.customer_id
	WHERE c.customer_id IS NULL;
 
----Negative revenue---
 
 SELECT * 
    FROM sushi_orders 
	WHERE cogs < 0;
   
  SELECT * 
    FROM sushi_order_items
	WHERE cogs < 0;

-----Invalid party_size---

  SELECT * 
    FROM sushi_orders
	WHERE party_size <= 0;

------Checking Discounts----

  SELECT *
     FROM sushi_orders
	 WHERE discount < 0;

----Checking weekend consistency---

SELECT *
  FROM sushi_orders
  WHERE is_weekend <>
        (EXTRACT(ISODOW FROM date) IN (6,7));

-----Order items without orders----

 SELECT 
     oi.order_id
 FROM  sushi_order_items oi
 LEFT JOIN sushi_orders o
      ON oi.order_id = o.order_id
  WHERE o.order_id IS NULL;

------Reviews without orders----

  SELECT
     r.order_id
  FROM sushi_reviews r
  LEFT JOIN sushi_orders o
      ON r.order_id = o.order_id
  WHERE o.order_id IS NULL;

-----DATA CONSISTENCY-----

  SELECT
     o.order_id,
	 o.customer_id,
	 c.segment AS customer_segment,
	 o.customer_segment AS order_segment
  FROM sushi_orders o
  JOIN sushi_customers c
      ON o.customer_id = c.customer_id
  WHERE c.segment <> o.customer_segment;

  SELECT 
      o.order_id,
	 o.customer_id,
	 c.is_local AS customer_is_local,
	 o. is_local AS order_is_local
  FROM sushi_orders o
  JOIN sushi_customers c
      ON o.customer_id = c.customer_id
  WHERE c.is_local <> o.is_local;

-----Checking order rating vs review rating---

   SELECT 
      o.order_id,
	  o.rating AS order_rating,
	  r.rating AS review_rating
  FROM sushi_orders o
  JOIN sushi_reviews r
      ON o.order_id = r.order_id
  WHERE o.rating <> r.rating;

