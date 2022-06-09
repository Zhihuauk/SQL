-- Section 4 assigment 4

select
	web_s.device_type,
    count(web_s.website_session_id) as sessions,
    count(orders.order_id) as orders,
    count(orders.order_id)/count(web_s.website_session_id) as session_to_order_conv_rate
    

from website_sessions as web_s
	left join orders 
		on web_s.website_session_id = orders.website_session_id
        
where 
	web_s.created_at < '2012-5-11'
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
group by web_s.device_type