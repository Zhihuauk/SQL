-- section8 assiginment 1
select 
	year(t1.created_at) yr,
    month(t1.created_at) mo,
	count(t1.website_session_id),
    count(order_id)
from
	website_sessions t1
		left join orders t2
			on t1.website_session_id = t2.website_session_id
			
where
	t1.created_at <= '2012-12-31'
group by 1,2

