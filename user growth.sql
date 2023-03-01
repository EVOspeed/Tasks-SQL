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
t2 as (SELECT 
  date,
  count(courier_id) as "new_couriers"
FROM   (
    SELECT 
      courier_id,
      min(date(time)) as "date"
    FROM   courier_actions
    GROUP BY courier_id
    ) as t1
GROUP BY date), 
t3 as (SELECT 
  t1.date,
  new_users,
  cast(sum(new_users) OVER(ORDER BY t1.date) as integer) as "total_users",
  new_couriers,
  cast(sum(new_couriers) OVER(ORDER BY t1.date) as integer) as "total_couriers",
  round(cast(new_users as decimal) / lag(new_users) OVER() * 100 - 100, 2) as "new_users_change",
  --ROUND(CAST(total_users AS decimal) / LAG(total_users) OVER() * 100 - 100, 2) AS "total_users_growth",
  round(cast(new_couriers as decimal) / lag(new_couriers) OVER() * 100 - 100, 2) as "new_couriers_change"
  --ROUND(CAST(total_couriers AS decimal) / LAG(total_couriers) OVER() * 100 - 100, 2) AS "total_couriers_growth" 
FROM   t1 join t2
  ON t2.date = t1.date
ORDER BY date)

SELECT date,
       new_users,
       total_users,
       new_couriers,
       total_couriers,
       new_users_change,
       new_couriers_change,
       round(cast(total_users as decimal) / lag(total_users) OVER() * 100 - 100,
             2) as "total_users_growth",
       round(cast(total_couriers as decimal) / lag(total_couriers) OVER() * 100 - 100,
             2) as "total_couriers_growth"
FROM   t3