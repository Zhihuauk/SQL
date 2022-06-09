/*
SELECT
	web_s.utm_source
    ,web_s.utm_campaign
    ,web_s.http_referer
    ,count(distinct(web_s.website_session_id)) AS sessions	
    ,count(orders.order_id) orders
    ,count(orders.order_id)/count(distinct(web_s.website_session_id)) session_to_order_conv_rate
from 
	website_sessions as web_s
    left join orders on web_s.website_session_id = orders.website_session_id
    
where 
	web_s.created_at <= '2012-4-12'
group by 1,2,3
order by 6 DESC
*/

select
	count(distinct(web_s.website_session_id)) AS sessions	
    ,count(orders.order_id) orders
    ,count(orders.order_id)/count(distinct(web_s.website_session_id)) session_to_order_conv_rate
from 
	website_sessions as web_s
    left join orders on web_s.website_session_id = orders.website_session_id
    
where 
	web_s.created_at <'2012-4-12' 
    and web_s.utm_source='gsearch' 
    and  web_s.utm_campaign='nonbrand'
-- order by 3 DESC


-- 02:43:00	select  -- count(distinct(web_s.website_session_id)) AS sessions      count(orders.order_id) orders     ,count(orders.order_id)/count(distinct(web_s.website_session_id)) session_to_order_conv_rate from   website_sessions as web_s     left join orders on web_s.website_session_id = orders.website_session_id      where   web_s.created_at <= '2012-4-12'      and web_s.utm_source='gsearch'      and  ,web_s.utm_campaign='nonbrand' -- order by 3 DESC	Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ',web_s.utm_campaign='nonbrand' -- order by 3 DESC' at line 12	0.00031 sec

    
 