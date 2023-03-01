WITH t1 AS (SELECT 
  user_id,
  date,
  first_day,
  --MIN(date) OVER (PARTITION BY user_id) AS "first_day",
  SUM(order_price) AS "day_revenue"
FROM (SELECT 
          user_id,
          order_id,
          DATE(time) AS "date",
          order_price
        FROM 
          user_actions
        LEFT JOIN (SELECT 
          order_id AS "ord_id",
          SUM(price) AS "order_price"
        FROM (SELECT 
                order_id,
                UNNEST(product_ids) AS "prod_id"    
            FROM 
                orders) AS t1
          LEFT JOIN products ON products.product_id=t1.prod_id 
        GROUP BY order_id) AS t1
          ON t1.ord_id=user_actions.order_id
        WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')
        ORDER BY user_id, order_id
        ) AS t1
LEFT JOIN (SELECT 
  user_id AS "us_id",
  MIN(DATE(time)) AS "first_day"
FROM user_actions
GROUP BY user_id) AS t2 
  ON t2.us_id=t1.user_id
GROUP BY 
  user_id, date, first_day
ORDER BY user_id, date
)

SELECT 
  date,
  SUM(day_revenue) AS "revenue",
  SUM(day_revenue) FILTER (WHERE date = first_day) AS "new_users_revenue",
  ROUND(SUM(day_revenue) FILTER (WHERE date = first_day) / SUM(day_revenue) * 100, 2) AS "new_users_revenue_share",
  ROUND(100 - SUM(day_revenue) FILTER (WHERE date = first_day) / SUM(day_revenue) * 100, 2) AS "old_users_revenue_share"
FROM t1
GROUP BY date
ORDER BY date