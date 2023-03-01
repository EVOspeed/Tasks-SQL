with day_total_orders as (SELECT date(time) as "date",
 count(user_id) as "orders"
FROM user_actions
WHERE order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
GROUP BY date
ORDER BY date), 
day_first_orders as (SELECT date_first_orders,
  count(user_id) as "first_orders"
FROM (SELECT user_id,
        min(date(time)) as "date_first_orders"
      FROM   user_actions
      WHERE  order_id not in (SELECT order_id
                              FROM   user_actions
                              WHERE  action = 'cancel_order')
      GROUP BY user_id
      ORDER BY user_id
    ) as t1
GROUP BY date_first_orders
ORDER BY date_first_orders),
t1 as (SELECT user_id,
    min(date(time)) as "date_first_orders"
FROM   user_actions
GROUP BY user_id
ORDER BY user_id),
t2 as (SELECT user_id,
  date(time) as "date",
  count(order_id) as "new_users_orders"
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
GROUP BY user_id, date
ORDER BY user_id, date), 
day_new_user_order as (SELECT date_first_orders,
  sum(new_users_orders) as "new_users_orders"
FROM (SELECT t1.user_id,
        date_first_orders,
        new_users_orders
     FROM   t1
     LEFT JOIN t2
     ON t2.user_id = t1.user_id
     WHERE  date_first_orders = date
    ) as t1
GROUP BY date_first_orders
ORDER BY date_first_orders)

SELECT date,
  orders,
  first_orders,
  cast(new_users_orders as integer),
  round(cast(first_orders as decimal) / orders * 100, 2) as "first_orders_share",
  round(cast(new_users_orders as decimal) / orders * 100, 2) as "new_users_orders_share"
FROM day_total_orders 
  join day_first_orders ON day_first_orders.date_first_orders = day_total_orders.date 
  join day_new_user_order ON day_new_user_order.date_first_orders = day_total_orders.date
ORDER BY date