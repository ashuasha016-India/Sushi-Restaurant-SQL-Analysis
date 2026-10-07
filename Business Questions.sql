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
