-- section7 assiginment 3
-- step1. join website_session with order
-- step2. filter 
-- step3. count and group by


select
	utm_source,
    device_type,
    count(t1.website_session_id),
    count(order_id),
    count(order_id)/count(t1.website_session_id)
from
	website_sessions t1
		left join orders t2
			on t1.website_session_id = t2. website_session_id

where
	t1.created_at between '2012-08-22' and '2012-09-19'
    -- and utm_source in ('gsearch','bsearch')
    and utm_campaign = 'nonbrand'
group by 1,2
    