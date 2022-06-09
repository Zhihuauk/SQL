-- section 8 assiginment 4

select 
	min(date(t1.created_at)),
    count( case when device_type='desktop' and utm_source='gsearch' then 1 else null end),
    count( case when device_type='mobile' and utm_source='gsearch' then 1 else null end),
    count( case when device_type='desktop' and utm_source='bsearch' then 1 else null end),
    count( case when device_type='mobile' and utm_source='bsearch' then 1 else null end)

from
	website_sessions t1
		left join orders t2
			on t1.website_session_id = t2. website_session_id

where
	t1.created_at between '2012-11-04' and '2012-12-22'
    -- and utm_source in ('gsearch','bsearch')
    and utm_campaign = 'nonbrand'
group by yearweek(t1.created_at)
	
