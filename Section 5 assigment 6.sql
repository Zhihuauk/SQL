-- Section 5 assigment 6

drop table if exists conversion_funnel;
create  temporary table conversion_funnel

select
	t1.website_session_id,
    t1.website_pageview_id,
    t1.created_at,
    t1.pageview_url


from
	website_pageviews t1
		left join website_sessions t2
			on t1.website_session_id = t2.website_session_id
            
where
	t2.created_at between '2012-08-05' and '2012-09-05'
	and t2.utm_source = 'gsearch'
;

select
	count(lander_1) num_lander_1,
    count(products)  num_products,
    count(cart) num_cart ,
    count(shipping) num_shipping ,
    count(billing) num_billing ,
    count(thank_you_for_your_order) num_thank_you_for_your_order 

from
	(
		select 
			website_session_id,
			created_at,
			case 
				when pageview_url= '/lander-1'
				then 1
				else null
			end as 'lander_1',
			case 
				when pageview_url= '/products'
				then 1
				else null
			end as 'products',
			case 
				when pageview_url= '/cart'
				then 1
				else null
			end as 'cart',
			case 
				when pageview_url= '/shipping'
				then 1
				else null
			end as 'shipping',
			case 
				when pageview_url= '/billing'
				then 1
				else null
			end as 'billing',
			case 
				when pageview_url= '/thank-you-for-your-order'
				then 1
				else null
			end as 'thank_you_for_your_order'
			
		from
			conversion_funnel
    ) temp;

	
