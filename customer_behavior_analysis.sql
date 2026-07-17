USE mydatabase;
SHOW TABLES;
SELECT * FROM customer LIMIT 5;

select gender,sum(purchase_amount) as revenue 
from customer
group by gender;

SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes'
  AND purchase_amount >= (
      SELECT AVG(purchase_amount)
      FROM customer
  );
  
SELECT item_purchased,
       ROUND(AVG(review_rating), 2) AS `Average Product Rating`
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

select shipping_type,
avg(purchase_amount)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type;

SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY subscription_status
order by total_revenue,avg_spend desc;

select item_purchased,
round(100*sum(case when discount_applied="Yes"
then 1
else 0
end)
/count(*) ,2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc limit 5;
WITH customer_type AS (
    SELECT
        customer_id,
        previous_purchases,
        CASE
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer
)

SELECT
    customer_segment,
    COUNT(*) AS `Number of Customers`
FROM customer_type
GROUP BY customer_segment;

WITH item_count AS (
    SELECT
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_count
WHERE item_rank <= 3;

select subscription_status,count(customer_id) as repeat_buyers 
from customer
where previous_purchases>5
group by subscription_status;

SELECT age_group,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;
