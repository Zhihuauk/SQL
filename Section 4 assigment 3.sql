-- Section 4 assigment 3
select
	-- year(created_at),
	-- week(created_at),
    min(date(created_at)) AS week_start_day,
    count(distinct(website_session_id)) AS sessions
from
	website_sessions
where 
	created_at < '2012-05-10'
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
group by week(created_at)

