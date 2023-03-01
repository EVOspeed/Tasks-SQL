WITH t1 AS (SELECT 
  order_id,
  --t1.product_id,
  SUM(price) AS "order_price"
FROM (
SELECT 
  user_actions.order_id,
  UNNEST(product_ids) AS "product_id"
FROM 
  user_actions
  LEFT JOIN orders ON orders.order_id=user_actions.order_id
WHERE user_actions.order_id NOT IN (SELECT order_id
                        FROM user_actions
                        WHERE action = 'cancel_order')
    ) AS t1
LEFT JOIN products ON products.product_id=t1.product_id
GROUP BY   order_id
),
t2 AS (SELECT 
  DATE(time) AS "date",
  --user_actions.order_id,
  SUM(order_price) AS "revenue"
FROM user_actions
JOIN t1 ON t1.order_id=user_actions.order_id
WHERE user_actions.order_id NOT IN (SELECT order_id
                                FROM user_actions
                                WHERE action = 'cancel_order')
GROUP BY date
),
t3 AS (SELECT 
  DATE(time) AS "date",
  COUNT(DISTINCT user_id) FILTER (WHERE action='create_order') AS "dau",
  COUNT(user_id) FILTER (WHERE order_id NOT IN (SELECT order_id
                                                         FROM user_actions
                                                         WHERE action='cancel_order')) AS "total_orders",
  COUNT(DISTINCT user_id) FILTER (WHERE order_id NOT IN (SELECT order_id
                                                         FROM user_actions
                                                         WHERE action='cancel_order')) AS "paying_users"
FROM user_actions
GROUP BY date
)

SELECT 
  t2.date,
  ROUND(revenue / dau, 2) AS "arpu",
  ROUND(revenue / paying_users, 2) AS "arppu",
  ROUND(revenue / total_orders, 2) AS "aov"
FROM t2
JOIN t3 ON t3.date=t2.date