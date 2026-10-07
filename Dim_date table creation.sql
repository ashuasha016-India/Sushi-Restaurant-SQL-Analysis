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