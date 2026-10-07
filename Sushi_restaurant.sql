-- SCHEMA: sushi

-- DROP SCHEMA IF EXISTS sushi ;

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


  SELECT * FROM sushi_customers;
DROP TABLE IF EXISTS sushi_daily_pnl;

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
 
---Creating dim_date--

  CREATE TABLE sushi_dim_date (
        date DATE PRIMARY KEY,
		year INT,
		month INT CHECK (MONTH  BETWEEN 1 AND 12),
		month_name VARCHAR(15),
		quarter INT CHECK (QUARTER  BETWEEN 1 AND 4),
		day_of_week VARCHAR(15),
		day_of_month INT,
		is_weekend BOOLEAN,
		is_holiday BOOLEAN
        );

  INSERT INTO sushi_dim_date(
         date,
		 year,
		 month,
		 month_name,
		 quarter,
		 day_of_week,
		 day_of_month,
		 is_weekend,
		 is_holiday
      )
	SELECT
	   d::DATE AS date,
	   EXTRACT(YEAR FROM d)::INT AS year,
	   EXTRACT(MONTH FROM d)::INT AS month,
	   TO_CHAR(d, 'MONTH') AS month_name,
	   EXTRACT(QUARTER FROM d)::INT AS quarter,
	   TO_CHAR(d, 'DAY') AS day_of_week,
	   EXTRACT(DAY FROM d)::INT AS day_of_month,
	   EXTRACT(ISODOW FROM d) IN (6,7) AS is_weekend,
	   FALSE AS is_holiday
	   FROM generate_series(
            (SELECT MIN(date) FROM sushi_orders),
			(SELECT MAX(date) FROM sushi_orders),
			 INTERVAL '1 day'
		     ) AS d;


   UPDATE sushi_dim_date d
   SET is_holiday = TRUE
   WHERE EXISTS (
       SELECT 1
	   FROM sushi_daily_pnl p
	   WHERE p.date = d.date
	   AND p.is_holiday = TRUE
    );

  SELECT DISTINCT o.date
  FROM sushi_orders o
  LEFT JOIN sushi_dim_date d
     ON o.date = d.date
	 WHERE d.date IS NULL;

---Create relationships--

 ALTER TABLE sushi_orders
 ADD CONSTRAINT fk_orders_date
 FOREIGN KEY (date)
 REFERENCES sushi_dim_date(date);

  ALTER TABLE sushi_daily_pnl
 ADD CONSTRAINT fk_pnl_date
 FOREIGN KEY (date)
 REFERENCES sushi_dim_date(date);

   ALTER TABLE sushi_reviews
 ADD CONSTRAINT fk_reviews_date
 FOREIGN KEY (date)
 REFERENCES sushi_dim_date(date);

   ALTER TABLE sushi_order_items
 ADD CONSTRAINT fk_order_items_date
 FOREIGN KEY (date)
 REFERENCES sushi_dim_date(date);

 SELECT *
FROM sushi_dim_date
ORDER BY date
LIMIT 20;

  SELECT COUNT(*) AS total_dates
  FROM sushi_dim_date;

  SELECT date, COUNT(*) 
  FROM sushi_dim_date
  GROUP BY date
  HAVING COUNT(*) > 1;

 SELECT DISTINCT o.date
 FROM sushi_orders o
   LEFT JOIN sushi_dim_date d
   ON o.date = d.date
  WHERE d.date IS NULL;

  SELECT DISTINCT p.date
  FROM sushi_daily_pnl P
  LEFT JOIN sushi_dim_date d
     ON p.date = d.date
   WHERE d.date IS NULL;
  
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

  -----Business Metrics-----

  1."What are the overall restaurant KPIs?"
    *Total Revenue *Total Orders *Total Customers *Total Cogs *Gross Profit *Gross Margin *Average Order Value

   SELECT 
      SUM(revenue) AS total_revenue, 
	  COUNT(DISTINCT order_id) AS total_orders,
	  COUNT(DISTINCT customer_id) AS total_customers,
	  SUM(cogs) AS total_cogs,
	  SUM(gross_profit) AS gross_profit,
	  ROUND(100.0 * SUM(gross_profit) / NULLIF(SUM(revenue),0),2
	    ) AS gross_margin_pct,
	  ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT order_id),0),
	     2 ) AS avg_order_value
		 FROM sushi_orders;

  2."Which customer segments generate the most revenue?"

   SELECT
      c.segment,
	  COUNT(DISTINCT c.customer_id) AS customers,
	  COUNT(DISTINCT o.order_id) AS orders,
	  SUM(o.revenue) AS revenue,
	  ROUND(AVG(o.revenue),2) AS avg_order_value
	    FROM sushi_customers c
	  JOIN sushi_orders o
	     ON c.customer_id = o.customer_id
	  GROUP BY c.segment
	  ORDER BY revenue DESC;

   3."Do local customers generate more revenue than non-local customers"?

    SELECT
      c.is_local,
	  COUNT(DISTINCT c.customer_id) AS customers,
	  COUNT(DISTINCT o.order_id) AS orders,
	  SUM(o.revenue) AS revenue,
	  ROUND(AVG(o.revenue),2) AS avg_order_value
	    FROM sushi_customers c
	  JOIN sushi_orders o
	     ON c.customer_id = o.customer_id
	  GROUP BY c.is_local
	  ORDER BY revenue DESC;
   
  4."Which sales channels generate the most revenue"?

   SELECT
      channel,
	  COUNT(DISTINCT order_id) AS orders,
	  SUM(revenue) AS revenue,
	  SUM(gross_profit) AS gross_profit,
	  ROUND(100.0 * SUM(gross_profit) / NULLIF(SUM(revenue),0), 2) AS gross_margin_pct
	    FROM sushi_orders
	  GROUP BY channel
	  ORDER BY revenue DESC;

  5."How does weekend performance compare with weekday performance?"

   SELECT
      is_weekend,
	  COUNT(DISTINCT order_id) AS orders,
	  SUM(revenue) AS revenue,
	  SUM(gross_profit) AS gross_profit,
	  ROUND(AVG(revenue),2) AS avg_order_value
	    FROM sushi_orders
	  GROUP BY is_weekend
	  ORDER BY is_weekend;

  6."Which months generate the highest revenue?"

  SELECT
    d.year,
	d.month,
	d.month_name,
	SUM(o.revenue) AS revenue,
	COUNT(DISTINCT o.order_id) AS orders
	FROM sushi_orders o
	JOIN sushi_dim_date d
	   ON o.date = d.date
	GROUP BY 
	    d.year,
		d.month,
		d.month_name
	ORDER BY 
	    d.year,
		d.month;"

  7. "What is the month-over-month revenue growth?"

   WITH monthly_sales 
   (
       SELECT
	      d.year,
		  d.month,
		  d.month_name,
		  SUM(o.revenue) AS revenue
	FROM sushi_orders o
	JOIN sushi_dim_date d
	   ON o.date = d.date
	GROUP BY 
	    d.year,
		d.month,
		d.month_name
		 )
   SELECT 
       year,
	   month,
	   month_name,
	   revenue,
	   LAG(revenue) OVER (
          ORDER BY year,month
	   ) AS previous_month_revenue,

	   revenue-
	   LAG(revenue) OVER (
             ORDER BY year, month
	   ) AS revenue_change,

	   ROUND(
           100.0 *
		   (
             revenue -
			 LAG(revenue) OVER (
                ORDER BY year, month
			 )
			 )
			 / NULLIF(
                 LAG(revenue) OVER (
                     ORDER BY year, month
				 ), 0
			 ),
			 2
	     ) AS growth_pct

	 FROM monthly_sales
	 ORDER BY year, month;

  8."Who are the top customers by revenue?"

  WITH customer_revenue AS
  (
      SELECT 
	     c.customer_id,
		 c.segment,
		 SUM(o.revenue) AS revenue
	  FROM sushi_customers c
	  JOIN sushi_orders o
	     ON c.customer_id = o.customer_id
	  GROUP BY 
	       c.customer_id,
		   c.segment
   )

   SELECT
       customer_id,
	   segment,
	   revenue,
	   RANK() OVER (
           ORDER BY revenue DESC
		) AS customer_rank
	FROM customer_revenue
	ORDER BY customer_rank;

8."What are the top 3 customers within each segment?"

   WITH customer_revenue AS
   (     
       SELECT 
	       c.customer_id,
		   c.segment,
		   SUM(o.revenue) AS revenue
	   FROM sushi_customers c
	   JOIN sushi_orders o
	      ON c.customer_id = o.customer_id
	   GROUP BY 
	        c.customer_id,
			c.segment
			),

	ranked_customers AS
	(
        SELECT
		*,
		DENSE_RANK() OVER (
            PARTITION BY segment
			ORDER BY revenue DESC
		) AS segment_rank
     FROM customer_revenue
		)

	SELECT *
	FROM ranked_customers
	WHERE segment_rank <= 3
	ORDER BY segment, segment_rank;

9. "Which sushi items generate the most revenue?"

   SELECT
        item,
		category,
		COUNT(*) AS times_ordered,
		SUM(unit_price) AS total_sales
	FROM sushi_order_items
	GROUP BY 
	      item,
		  category
	 ORDER BY total_sales DESC;

10. "Does customer rating differ by sales channel?"

    SELECT
	    channel,
		COUNT(*) AS orders,
		ROUND(AVG(rating),2) AS average_rating,
		SUM(revenue) AS revenue
	  FROM sushi_orders
	  WHERE rating IS NOT NULL
	  GROUP BY channel
	  ORDER BY average_rating DESC;

11. "Which months are most profitable?"

  SELECT
      year,
	  month,
	  SUM(gross_revenue) AS revenue,
	  SUM(cogs) AS cogs,
	  SUM(gross_profit) AS gross_profit,
	  SUM(labour_cost) AS labour_cost,
	  SUM(fixed_ops_cost) AS fixed_cost,
	  SUM(operating_profit) AS operating_profit
	FROM sushi_daily_pnl
	GROUP BY
	     year,
		 month
	ORDER BY operating_profit DESC;

---Create a  running total---

  WITH daily_sales AS
  (
      SELECT
	      date, 
		  SUM(revenue) AS revenue
	  FROM sushi_orders
	  GROUP BY date
  )
   
  SELECT
      date,
	  revenue,
	  SUM(revenue) OVER (
          ORDER BY date
	  ) AS  Cumulative_revenue
   FROM daily_sales
   ORDER BY date;
 
 12. "Which menu categories generate the highest gross profit?"

     SELECT 
	     category,
		 SUM(unit_price) AS total_sales,
		 SUM(cogs) AS total_cogs,
		 SUM(gross_profit) AS total_gross_profit,
		 ROUND(
            100.0 * SUM(gross_profit) /
		  NULLIF(SUM(unit_price), 0),
		   2
		  ) AS profit_margin_pct
	 FROM sushi_order_items
	 GROUP BY category
	 ORDER BY total_gross_profit DESC;
		 
 13. "Which menu items have high revenue but low gross profit margin?"

      SELECT 
	     item,
	     category,
		 SUM(unit_price) AS total_revenue,
		 SUM(gross_profit) AS total_gross_profit,
		 ROUND(
            100.0 * SUM(gross_profit) /
		  NULLIF(SUM(unit_price), 0),
		   2
		  ) AS profit_margin_pct
	 FROM sushi_order_items
	 GROUP BY item,category
	 HAVING SUM(unit_price) > 0
	 ORDER BY profit_margin_pct ASC, total_revenue DESC;
		 
  14. "Which dates had unusually high or low revenue compared with the overall average?"

     WITH daily_revenue AS
	 (
         SELECT
		     date,
			 SUM(revenue) AS daily_revenue
		 FROM sushi_orders
		 GROUP BY date
	 ),
	 average_revenue AS
	 (
          SELECT
		      AVG(daily_revenue) AS avg_daily_revenue
		  FROM daily_revenue
	 )
	 SELECT
	    d.date,
		d.daily_revenue,
		ROUND(a.avg_daily_revenue, 2) AS overall_average,
		ROUND(d.daily_revenue - a.avg_daily_revenue,
		  2
		 ) AS difference_from_average,
		 CASE
		    WHEN d.daily_revenue > a.avg_daily_revenue THEN 'Above Average'
	        WHEN d.daily_revenue < a.avg_daily_revenue THEN 'Below Average'
			 ELSE 'Average'
			END AS performance
		FROM daily_revenue d
		CROSS JOIN average_revenue a
		ORDER BY d.daily_revenue DESC;

  15. "Which staff roles have the most terminated employees?"

       SELECT
	       role,
		   COUNT(*) AS total_staff,
		   COUNT(*) FILTER ( WHERE termination_date IS NOT NULL) AS terminated_staff,
		   ROUND(
               100.0 * COUNT(*) FILTER (WHERE termination_date IS NOT NULL
			   ) / NULLIF(COUNT(*), 0), 2) AS turnover_rate_pct
		 FROM sushi_staff
		 GROUP BY role
		 ORDER BY turnover_rate_pct DESC;

   16."Which staff roles have the highest average base hourly rate?"

     SELECT
	    role,
		COUNT(*) AS staff_count,
		ROUND(AVG(base_hourly_rate_2015),2) AS avg_hourly_rate,
		ROUND(MIN(base_hourly_rate_2015),2) AS min_hourly_rate,
		ROUND(MAX(base_hourly_rate_2015),2) AS max_hourly_rate
	 FROM sushi_staff
	 GROUP BY role
	 ORDER BY avg_hourly_rate DESC;








