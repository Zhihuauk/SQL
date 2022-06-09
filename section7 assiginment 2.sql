-- section7 assiginment 2

select 
	utm_source,
	-- min(date(created_at),
	count(website_session_id),
    count(case when device_type ='mobile' then 1 else null end),
    count(case when device_type ='mobile' then 1 else null end)/count(website_session_id)
    -- count(case when utm_source ='bsearch' then 1 else null end)/count(website_session_id)
from
	website_sessions
where 
	created_at between '2012-08-22' and '2012-11-30'
    and utm_source in ('gsearch','bsearch')
    and utm_campaign = 'nonbrand'
group by 
	utm_source



