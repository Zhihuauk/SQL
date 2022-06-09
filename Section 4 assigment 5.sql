-- Section 4 assigment 5
select 
	-- week(web_s.created_at),
    min(date(web_s.created_at)) as week_start_date,
    -- count(distinct(web_s.website_session_id)),
    count(case when web_s.device_type = 'mobile' then web_s.website_session_id else null end) as dtop, 
    count(case when web_s.device_type = 'desktop' then web_s.website_session_id else null end) as mobile 

from website_sessions as web_s
	left join  orders 
		on web_s.website_session_id = orders.website_session_id

where 
	web_s.created_at between '2012-04-15' and '2012-6-9'
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
group by week(web_s.created_at)
