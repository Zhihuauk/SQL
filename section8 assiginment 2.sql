-- section8 assiginment 2
select
	hr,
    count(case when weekday = 0 then 1 else null end) as mon,
    count(case when weekday = 1 then 1 else null end) as tue,
    count(case when weekday = 2 then 1 else null end) as wen,
    count(case when weekday = 3 then 1 else null end) as thu,
    count(case when weekday = 4 then 1 else null end) as fri,
    count(case when weekday = 5 then 1 else null end) as sta,
    count(case when weekday = 6 then 1 else null end) as sun
    
    -- count(website_session_id)
    
from
	(
	select
		weekday(created_at) weekday,
		hour(created_at) hr,
		website_session_id
	from
		website_sessions
	where
		created_at between '2012-09-15' and '2012-11-15'
		) t
group by hr