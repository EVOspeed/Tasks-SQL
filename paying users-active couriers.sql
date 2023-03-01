with t1 as (SELECT 
  date,
  count(user_id) as "new_users"
FROM (
    SELECT 
      user_id,
      min(date(time)) as "date"
    FROM   user_actions
    GROUP BY user_id
    ) as t1
GROUP BY date), 
t2 as (SELECT date,
  count(courier_id) as "new_couriers"
FROM (
    SELECT courier_id,
      min(date(time)) as "date"
    FROM courier_actions
    GROUP BY courier_id
    ) as t1
GROUP BY date), 
t3 as (SELECT date,
  count(user_id) as "paying_users"
FROM (
    SELECT DISTINCT
      date(time) as "date",
      user_id
    FROM   user_actions
    WHERE  action = 'create_order'
      and order_id not in (SELECT order_id
                            FROM   user_actions
                            WHERE  action = 'cancel_order')
    ORDER BY date, user_id
    ) as t1
GROUP BY date
ORDER BY date),
t4 as (SELECT date,
  count(courier_id) as "active_couriers"
FROM (
    SELECT DISTINCT date(time) as "date",
      courier_id
    FROM   courier_actions
    WHERE  order_id in (SELECT order_id
                        FROM   courier_actions
                        WHERE  action = 'deliver_order')
    ORDER BY date, courier_id
    ) as t1
GROUP BY date
ORDER BY date)

SELECT t1.date,
  round(paying_users / sum(new_users) OVER(ORDER BY t1.date) * 100, 2) as "paying_users_share",
  round(active_couriers / sum(new_couriers) OVER(ORDER BY t1.date) * 100, 2) as "active_couriers_share",
  paying_users,
  active_couriers
FROM t1 
join t2 ON t2.date = t1.date 
join t3 ON t3.date = t1.date
join t4 ON t4.date = t1.date
ORDER BY t1.date