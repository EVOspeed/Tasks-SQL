WITH users_ads1 AS (SELECT DISTINCT user_id FROM user_actions WHERE user_id IN (8804, 9828, 9524, 9667, 9165, 10013, 9625, 8879, 9145, 8657, 8706, 9476, 9813, 
8940, 9971, 10122, 8732, 9689, 9198, 8896, 8815, 9689, 9075, 9071, 9528, 9896, 
10135, 9478, 9612, 8638, 10057, 9167, 9450, 9999, 9313, 9720, 9599, 9351, 8638, 
8752, 9998, 9431, 9660, 9004, 8632, 8896, 8750, 9605, 8867, 9535, 9494, 9762, 
8990, 9526, 9786, 9654, 9144, 9391, 10016, 8988, 9009, 9061, 9004, 9550, 8707, 
8788, 8988, 8853, 9836, 8810, 9916, 9660, 9677, 9896, 8933, 8828, 9108, 9180, 
9897, 9960, 9472, 9818, 9695, 9965, 10023, 8972, 9035, 8869, 9662, 9561, 9740, 
8723, 9146, 10103, 9963, 10103, 8715, 9167, 9313, 9679, 9251, 10001, 8867, 8707, 
9945, 9562, 10013, 9020, 9317, 9002, 9838, 9144, 8911, 9505, 9313, 10134, 9197, 
9398, 9652, 9999, 9210, 8741, 9963, 9422, 9778, 8815, 9512, 9794, 9019, 9287, 9561, 
9321, 9677, 10122, 8752, 9810, 9871, 9162, 8876, 9414, 10030, 9334, 9175, 9182, 
9451, 9257, 9321, 9531, 9655, 9845, 8883, 9993, 9804, 10105, 8774, 8631, 9081, 8845, 
9451, 9019, 8750, 8788, 9625, 9414, 10064, 9633, 9891, 8751, 8643, 9559, 8791, 9518, 
9968, 9726, 9036, 9085, 9603, 8909, 9454, 9739, 9223, 9420, 8830, 9615, 8859, 9887, 
9491, 8739, 8770, 9069, 9278, 9831, 9291, 9089, 8976, 9611, 10082, 8673, 9113, 10051)
),
users_ads2 AS (SELECT DISTINCT user_id FROM user_actions WHERE user_id IN (9752, 9510, 8893, 9196, 10038, 9839, 9820, 9064, 9930, 9529, 9267, 9161, 9231, 
8953, 9863, 8878, 10078, 9370, 8675, 9961, 9007, 9207, 9539, 9335, 8700, 9598, 
9068, 9082, 8916, 10131, 9704, 9904, 9421, 9083, 9337, 9041, 8955, 10033, 9137, 
9539, 8855, 9117, 8771, 9226, 8733, 8851, 9749, 10027, 9757, 9788, 8646, 9567, 
9140, 9719, 10073, 9000, 8971, 9437, 9958, 8683, 9410, 10075, 8923, 9255, 8995, 
9343, 10059, 9082, 9267, 9929, 8670, 9570, 9281, 8795, 9082, 8814, 8795, 10067, 
9700, 9432, 9783, 10081, 9591, 8733, 9337, 9808, 9392, 9185, 8882, 8681, 8825, 
9692, 10048, 8682, 9631, 8942, 9910, 9428, 9500, 9527, 8655, 8890, 9000, 8827, 
9485, 9013, 9042, 10047, 8798, 9250, 8929, 9161, 9545, 9333, 9230, 9841, 8659, 
9181, 9880, 9983, 9538, 9483, 9557, 9883, 9901, 9103, 10110, 8827, 9530, 9310, 
9711, 9383, 9527, 8968, 8973, 9497, 9753, 8980, 8838, 9370, 8682, 8854, 8966, 
9658, 9939, 8704, 9281, 10113, 8697, 9149, 8870, 9959, 9127, 9203, 9635, 9273, 
9356, 10069, 9855, 8680, 9912, 8900, 9131, 10058, 9479, 9259, 9368, 9908, 9468, 
8902, 9292, 8742, 9672, 9564, 8949, 9404, 9183, 8913, 8694, 10092, 8771, 8805, 
8794, 9179, 9666, 9095, 9935, 9190, 9183, 9631, 9231, 9109, 9123, 8806, 9229, 
9741, 9303, 9303, 10045, 9744, 8665, 9843, 9634, 8812, 9684, 9616, 8660, 9498, 
9877, 9727, 9882, 8663, 9755, 8754, 9131, 9273, 9879, 9492, 9920, 9853, 8803, 
9711, 9885, 9560, 8886, 8644, 9636, 10073, 10106, 9859, 8943, 8849, 8629, 8729, 
9227, 9711, 9282, 9312, 8630, 9735, 9315, 9077, 8999, 8713, 10079, 9596, 8748, 
9327, 9790, 8719, 9706, 9289, 9047, 9495, 9558, 8650, 9784, 8935, 9764, 8712)
),
cac_ads1 AS (SELECT 
  COUNT(DISTINCT user_id) AS "active_users",
  CAST(250000 AS decimal) / COUNT(DISTINCT user_id) AS "cac"
FROM 
  user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
AND user_id IN (SELECT user_id FROM users_ads1)
),
revenue_ads1 AS (SELECT 
  DATE(time) AS "date",
  SUM(order_price) AS "revenue"
FROM user_actions
LEFT JOIN (SELECT 
              order_id,
              SUM(price) AS "order_price"
            FROM (SELECT 
                      order_id,
                      UNNEST(product_ids) AS "prod_id"
                    FROM orders
                ) AS t1
            JOIN products ON products.product_id=t1.prod_id
            GROUP BY order_id
        ) AS t1 
    ON t1.order_id=user_actions.order_id
WHERE user_actions.order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
  AND user_id IN (SELECT user_id FROM users_ads1)
GROUP BY date
),
cac_ads2 AS (SELECT 
  COUNT(DISTINCT user_id) AS "active_users",
  CAST(250000 AS decimal) / COUNT(DISTINCT user_id) AS "cac"
FROM 
  user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
AND user_id IN (SELECT user_id FROM users_ads2)
),
revenue_ads2 AS (SELECT 
  DATE(time) AS "date",
  SUM(order_price) AS "revenue"
FROM user_actions
LEFT JOIN (SELECT 
              order_id,
              SUM(price) AS "order_price"
            FROM (SELECT 
                      order_id,
                      UNNEST(product_ids) AS "prod_id"
                    FROM orders
                ) AS t1
            JOIN products ON products.product_id=t1.prod_id
            GROUP BY order_id
        ) AS t1 
    ON t1.order_id=user_actions.order_id
WHERE user_actions.order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
  AND user_id IN (SELECT user_id FROM users_ads2)
GROUP BY date
)
SELECT *
FROM (
SELECT 
  'Кампания № 1' AS "ads_campaign",
  CONCAT('Day ', ROW_NUMBER() OVER(ORDER BY date) - 1) AS "day",
  ROUND(SUM(revenue) OVER(ORDER BY date) / (SELECT MAX(active_users) FROM cac_ads1), 2) AS "cumulative_arppu",
  ROUND((SELECT MAX(cac) FROM cac_ads1), 2) AS "cac"
FROM revenue_ads1
UNION ALL
SELECT 
  'Кампания № 2' AS "ads_campaign",
  CONCAT('Day ', ROW_NUMBER() OVER(ORDER BY date) - 1) AS "day",
  ROUND(SUM(revenue) OVER(ORDER BY date) / (SELECT MAX(active_users) FROM cac_ads2), 2) AS "cumulative_arppu",
  ROUND((SELECT MAX(cac) FROM cac_ads2), 2) AS "cac"
FROM revenue_ads2
) AS t1
--WHERE ads_campaign = 'Кампания № 2'
ORDER BY ads_campaign, day