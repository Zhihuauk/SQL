-- section 9 assiginment 3
-- diffcult !!! need to learn again
-- select * from website_pageviews where  website_session_id = 100
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
				created_at   between '2012-10-06' and '2013-04-06'
                and pageview_url = '/products'
		) t1
		left join 
			website_pageviews t2 on t1.website_session_id=t2.website_session_id
            and t1.website_pageview_id < t2.website_pageview_id 

group by 1,2,3;

select count(*) from product_next_page ;

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

select distinct(next_page_url) from next_page_url;

select
	period,
    count(website_session_id),
    count(next_page_url),
    count(case when next_page_url = '/the-forever-love-bear' then 1 else null end),
    count(case when next_page_url = '/the-original-mr-fuzzy' then 1 else null end)
from
	next_page_url

group by period



