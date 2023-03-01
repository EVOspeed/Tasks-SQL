SELECT 
  DATE(start_month) AS "start_month",
  start_date,
  ROW_NUMBER() OVER(PARTITION BY start_date ORDER BY date) - 1 AS "day_number",
  ROUND(CAST(users_ret AS decimal) / MAX(users_ret) OVER(PARTITION BY start_date), 2) AS "retention"
FROM (SELECT 
          COUNT(t1.user_id) AS "users_ret",
          date_trunc('month', start_date) AS "start_month",
          start_date,
          date
        FROM (SELECT DISTINCT
                  user_id,
                  --date_trunc('month', DATE(time)) AS "start_month",
                  MIN(DATE(time)) AS "start_date"
                FROM user_actions
                GROUP BY user_id
            ) AS t1
        JOIN (SELECT DISTINCT
                  user_id,
                  DATE(time) AS "date"
                FROM user_actions
            ) AS t2 ON t2.user_id=t1.user_id
        GROUP BY start_month, start_date, date
        ORDER BY start_month, start_date, date
    ) AS t1