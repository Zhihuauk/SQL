-- section7 assiginment 1
-- step1 select data in website_sessions where specefic utm_source  and utm-campagin
-- step1

select
	min(date(created_at)),
    count(case when utm_source = 'gsearch' then 1 else null end),
	count(case when utm_source = 'bsearch' then 1 else null end)
from
	(
		select
			website_session_id,
			created_at,
			utm_source
		from
			website_sessions
		where 
			utm_source in ('gsearch','bsearch')
			and created_at between '2012-08-22' and '2012-11-29'
            and utm_campaign='nonbrand'
	)t

group by week(created_at)


