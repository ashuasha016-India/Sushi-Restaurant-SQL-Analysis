# 🍣 Sushi Restaurant SQL Analysis

## 📌 Project Overview

This project analyzes a sushi restaurant dataset using PostgreSQL
to understand sales, customers, profitability, customer satisfaction,
products and staff performance.

## 🎯 Business Objective

The objective is to identify important business trends and provide
data-driven recommendations to improve restaurant performance.

## 🛠️ Tools Used

- PostgreSQL
- pgAdmin
- SQL
- GitHub

## 🗂️ Database Tables

- sushi_customers
- sushi_orders
- sushi_order_items
- sushi_reviews
- sushi_daily_pnl
- sushi_staff
- sushi_dim_date

## 🧹 Data Cleaning

- Checked duplicate records
- Checked NULL values
- Checked invalid values
- Checked date consistency
- Checked foreign-key relationships
- Created a dim date table

## 📊 Business Questions

1."What are the overall restaurant KPIs?"
    *Total Revenue *Total Orders *Total Customers *Total Cogs *Gross Profit *Gross Margin *Average Order Value
2."Which customer segments generate the most revenue?"
3."Do local customers generate more revenue than non-local customers"?
4."Which sales channels generate the most revenue"?
5."How does weekend performance compare with weekday performance?"
6."Which months generate the highest revenue?"
7. "What is the month-over-month revenue growth?"
8."Who are the top customers by revenue?"
9. "Which sushi items generate the most revenue?"
10. "Does customer rating differ by sales channel?"
11. "Which months are most profitable?"
12. "Which menu categories generate the highest gross profit?"
13. "Which menu items have high revenue but low gross profit margin?"
14. "Which dates had unusually high or low revenue compared with the overall average?"
15. "Which staff roles have the most terminated employees?"
16."Which staff roles have the highest average base hourly rate?"

## 🔍 Key Insights
* Regular customers generated the highest revenue among all customer segments.
*  Local customers generated more revenue than non-local customers.
* Dine-in was the highest-revenue-generating sales channel.
* Weekend performance was lower than weekday performance in terms of both revenue and gross profit.
* Roll items generated the highest number of orders and contributed the highest sales and profit among the menu categories.
* Takeaway had the highest average customer rating (3.72), followed by dine-in (3.66) and delivery (3.51).
* Sashimi, Omakase, and Nigiri generated relatively high revenue but had lower gross profit margins, indicating that their strong sales did not translate into equally strong profitability.
* The Server role had the highest number of terminated employees.
* Head Chef had the highest average base hourly rate among the staff roles.
* Monthly revenue shows an overall increasing trend over the period, although there are several fluctuations, including a sharp decline followed by a strong recovery.


## 👩‍💻 Skills Demonstrated

- Data Cleaning
- SQL Joins
- Aggregation
- CTEs
- CASE statements
- Window Functions
- Data Analysis
- Business Insights
