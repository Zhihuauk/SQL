-- section 9 assiginment 4
drop table if exists product_next_page;
create temporary table product_next_page
select
	t1.website_session_id,
    -- t1.website_pageview_id,
    t1.pageview_url,
    case when t1.created_at < '2013-01-06' then 'pro_product_2' else 'post_product_2' end period,
    case when min(t2.website_pageview_id) is null then null else min(t2.website_pageview_id) end as next_page_id
	-- min(t2.website_pageview_id) next_page
    -- t2.pageview_url
from
		(
		select
			website_pageview_id,
			website_session_id,
			pageview_url,
            created_at

		from
				website_pageviews
		where
				created_at   between '2013-1-06' and '2013-04-10'
                and pageview_url = '/products'
		) t1
		left join 
			website_pageviews t2 on t1.website_session_id=t2.website_session_id
            and t1.website_pageview_id < t2.website_pageview_id 

group by 1,2,3;


drop table if exists next_page_url;
create temporary table next_page_url
select
	period,
	t1.website_session_id,
	-- t1.website_pageview_id,
	t1.pageview_url first_page,
	t1.next_page_id ,
	t2.pageview_url next_page_url
			
from
	product_next_page t1
		left join 
			website_pageviews t2 
					on t1.next_page_id = t2.website_pageview_id;
              
select * from next_page_url;

select
		next_page_url,
        count(website_session_id),
        sum(cart),
        sum(shipping),
        sum(billing),
        sum(end_order)

from
        (
	
		select
			t1.website_session_id,
			next_page_url,
			count(case when t2.pageview_url ='/cart' then 1 else null end) cart,
			count(case when t2.pageview_url ='/shipping' then 1 else null end) shipping,
			count(case when t2.pageview_url ='/billing' then 1 else null end) billing,
			count(case when t2.pageview_url ='/thank-you-for-your-order' then 1 else null end) end_order
		from
			next_page_url t1
				left join 
					website_pageviews t2 
						on t1.website_session_id = t2.website_session_id
		where next_page_url is not null
		group by 1,2
        
        ) temp
group by 1
			;
 
    
-- select * from website_pageviews;


            

-- select * from website_pageviews where pageview_url = '/billing';

	
				
-- select website_session_id from orders
-- select pageview_url from website_pageviews where website_session_id=160 order by created_at asc
