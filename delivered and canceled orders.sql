with t1 as (SELECT date_part('hour', creation_time) as "hour",
  count(order_id) as "orders"
FROM   orders
GROUP BY hour
ORDER BY hour),
t2 as (SELECT date_part('hour', creation_time) as "hour",
  count(order_id) as "deliver_orders"
FROM   orders
WHERE  order_id in (SELECT order_id
                    FROM   courier_actions
                    WHERE  action = 'deliver_order')
GROUP BY hour
ORDER BY hour), 
t3 as (SELECT date_part('hour', creation_time) as "hour",
  count(order_id) as "cancel_orders"
FROM   orders
WHERE  order_id in (SELECT order_id
                    FROM   user_actions
                    WHERE  action = 'cancel_order')
GROUP BY hour
ORDER BY hour)

SELECT cast(t1.hour as integer),
  --orders,
  deliver_orders as "successful_orders",
  cancel_orders as "canceled_orders",
  round(cast(cancel_orders as decimal) / orders, 3) as "cancel_rate"
FROM t1 
  join t2 ON t2.hour = t1.hour
  join t3 ON t3.hour = t1.hour