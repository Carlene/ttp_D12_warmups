-- Find the mean, min, max, stdev for the interval of time (in days) between purchases for each customer, 
-- as a way of measuring purchasing-frequency for each customer. Also calculate the number of orders for each 
-- customer.
-- (See the *hints* and expected results files for ideas)

WITH time_between as (
select
 customer_id
 ,coalesce(order_date - lag(order_date) over (partition by customer_id order by order_id), 0) as date_diff

from 
 orders)

,amount_order as (
select
 customer_id
 ,count(order_id) as order_count
 
from
 orders

group by 
 customer_id)


SELECT
 ao.customer_id
 ,order_count
 ,round(avg(date_diff), 2) as average_datediff
 ,min(date_diff) as min_datediff
 ,max(date_diff) as max_datediff
 ,round(stddev(date_diff), 2) as standard_deviation

from 
 time_between as tb
join amount_order as ao
 on tb.customer_id = ao.customer_id


group by
 ao.customer_id
 ,order_count