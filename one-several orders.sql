with t1 as (SELECT 
  date(time) as "date",
  user_id,
  count(user_id) as "actions"
FROM   user_actions
WHERE  action = 'create_order'
  and order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
GROUP BY date, user_id
ORDER BY date, user_id)

SELECT date,
       --COUNT(user_id) AS "paying_users",
       --COUNT(user_id) FILTER (WHERE actions=1) AS "single_order",
       --COUNT(user_id) FILTER (WHERE actions>1) AS "severel_orders",
       round(count(user_id) filter (WHERE actions = 1) / cast(count(user_id) as decimal) * 100,
             2) as "single_order_users_share",
       round(count(user_id) filter (WHERE actions > 1) / cast(count(user_id) as decimal) * 100,
             2) as "several_orders_users_share"
FROM   t1
GROUP BY date
ORDER BY date