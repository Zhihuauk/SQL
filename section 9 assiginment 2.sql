-- section 9 assiginment 2
select
	year(created_at) yr,
    month(created_at) mo,
    count(order_id),
    count(order_id)/count(website_session_id) con_rate,
    sum(price_usd)/count(website_session_id),
    count(case when primary_product_id = 1 then 1 else null end) p_1_orders,
    count(case when primary_product_id = 2 then 1 else null end) p_2_orders
from
	(

		select
			t1.created_at,
			t1.website_session_id,
			order_id,
			items_purchased,
			primary_product_id,
			price_usd,
			cogs_usd

		from	
			website_sessions t1
				left join orders t2
				 on t1.website_session_id = t2.website_session_id

		where	
			t1.created_at between '2012-04-01' and '2013-04-05'

			-- and primary_product_id = 2
	) t
group by 1,2


