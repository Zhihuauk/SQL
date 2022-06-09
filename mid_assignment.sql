-- Section 6 MID-assiignment

-- 1.monthly trend for  orders and gsearch



select
	min(date(created_at)) as month_start_day,
    count(website_session_id) as sessions_num,
    count(order_id) as order_num

from
	(
		select 
			t1.created_at,
			t1.website_session_id,
			order_id
		from 
			website_sessions t1
			 left join orders t2
				on t1.website_session_id=t2.website_session_id
		where t1.created_at between '2012-03-27' and  '2012-11-27'
	)	temp
group by month(created_at);
	


-- 2. split out nonbrand and brand for 1. analysis
select
	min(date(created_at)) as month_start_day,
    count(case when utm_campaign='brand' then 1 else null end) 'brand_search',
    count(case when utm_campaign='nonbrand' then 1 else null end) 'nonbrand_search',
    count(website_session_id) as sessions_num
    -- count(order_id) as order_num

from
	(
		select 
			t1.created_at,
			t1.website_session_id,
			order_id,
            utm_campaign
		from 
			website_sessions t1
			 left join orders t2
				on t1.website_session_id=t2.website_session_id
		where t1.created_at between '2012-03-27' and  '2012-11-27'
	)	temp
group by 
	month(created_at);
    
-- 3.

select
	min(date(created_at)) as month_start_day,
    count(case when device_type='mobile' then 1 else null end) 'mobile',
    count(case when device_type='desktop' then 1 else null end) 'desktop',
    count(website_session_id) as sessions_num
    -- count(order_id) as order_num

from
	(
		select 
			t1.created_at,
			t1.website_session_id,
			order_id,
            utm_campaign,
            device_type
		from 
			website_sessions t1
			 left join orders t2
				on t1.website_session_id=t2.website_session_id
		where 
			t1.created_at between '2012-03-27' and  '2012-11-27'
            and t1.utm_campaign = 'nonbrand'
            and t1.utm_source = 'gsearch'
        
	)	temp
group by 
	month(created_at);
    
-- 4.

select
	min(date(created_at)) as month_start_day,
    count(case when utm_source='gsearch' then 1 else null end)/count(website_session_id) 'gsearch',
    count(case when utm_source='bsearch' then 1 else null end)/count(website_session_id) 'bsearch',
    count(case when utm_source='socialbook' then 1 else null end)/count(website_session_id) 'socialbook',
    count(case when utm_source is null then 1 else null end)/count(website_session_id) 'null',
    count(website_session_id) as sessions_num
    -- count(order_id) as order_num

from
	(
		select 
			t1.created_at,
			t1.website_session_id,
			order_id,
            utm_campaign,
            utm_source
		from 
			website_sessions t1
			 left join orders t2
				on t1.website_session_id=t2.website_session_id
		where 
			t1.created_at between '2012-03-27' and  '2012-11-27'
            -- and t1.utm_campaign = 'nonbrand'
            -- and t1.utm_source = 'gsearch'
        
	)	temp
group by 
	month(created_at);
    
    
-- 5.
select
	min(date(created_at)) as month_start_day,
    
    count(website_session_id) as sessions_num,
    count(order_id) as order_num,
    count(order_id)/count(website_session_id) as rate
    

from
	(
		select 
			t1.created_at,
			t1.website_session_id,
			order_id,
            utm_campaign,
            utm_source
		from 
			website_sessions t1
			 left join orders t2
				on t1.website_session_id=t2.website_session_id
		where 
			t1.created_at between '2012-03-27' and  '2012-11-27'
            -- and t1.utm_campaign = 'nonbrand'
            -- and t1.utm_source = 'gsearch'
        
	)	temp
group by 
	month(created_at);

-- 6. increatment of revenue from lander test

-- find the start time of lander test -- 2012-06-19/ the first pageview_id
select min(website_pageview_id) from website_pageviews where pageview_url='/lander-1';

-- step1. select started session from lander and home in this period
-- step2. concat session_id with order_id and order price and amount
-- step3. calcualte

drop table if exists filter_session;
create temporary table filter_session

select 
	t1.created_at,
    t1.website_session_id,
    min(website_pageview_id) website_pageview_id,
    t1.pageview_url
	
    
from
	website_pageviews as t1
		left join website_sessions as t2
			on t1.website_session_id=t2.website_session_id
where 
	t1.website_pageview_id > 23504
	and t1.created_at < '2012-07-28'
	and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
    and pageview_url in ('/home','/lander-1')
group by 1,2,4;


drop table if exists landing_order_revenue;
create temporary table landing_order_revenue

select
	t1.created_at,
    t1.website_session_id,
    website_pageview_id,
    pageview_url,
    t2.order_id,
    cogs_usd
    
	
from
	filter_session t1
    left join 
		orders t2
			on t1.website_session_id = t2.website_session_id 
				
;

select * from landing_order_revenue;

select
	pageview_url,
	-- min(date(created_at)),
    count(pageview_url) sessions,
    count(order_id) orders,
    count(order_id)/count(pageview_url) as conv_rate
    -- sum(case when pageview_url ='/lander-1' then 1 else 0 end) lander_revenue
from
	landing_order_revenue
group by pageview_url;



-- 7.
-- step1. create a temp table select all sessions which used to look up other steps

drop table if exists session_landing_page;
create temporary table session_landing_page
select
	t1.website_session_id,
    pageview_url as home_page
	
from
	website_pageviews as t1
		left join website_sessions as t2
			on t1.website_session_id=t2.website_session_id
where 

	t1.created_at between '2012-06-19' and '2012-07-28'
	and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
    and pageview_url in ('/home','/lander-1')
    
group by 1,2
having min(website_pageview_id);
-- group by 1,2,4;

-- select pageview_url from website_pageviews where website_session_id=147 order by created_at;


drop table if exists funnel;
create temporary table funnel
select
	t1.website_session_id,
    home_page,
    -- case when pageview_url= '/home' then 1 else null end 'home',
    case when pageview_url= '/products' then 1 else null end 'products',
    case when pageview_url= '/the-original-mr-fuzzy' then 1 else null end 'mr_fuzzy',
    case when pageview_url= '/cart' then 1 else null end 'cart',
    case when pageview_url= '/shipping' then 1 else null end 'shipping',
    case when pageview_url= '/billing' then 1 else null end 'billing',
    case when pageview_url= '/thank-you-for-your-order' then 1 else null end 'end'
	
    
from
	session_landing_page t1
		left join website_pageviews t2
			on t1.website_session_id = t2.website_session_id
;

select
	home_page,
    count(products),
    count(mr_fuzzy),
    count(cart),
    count(shipping),
    count(billing),
    count(end)
from
	funnel
group by home_page;

-- select website_session_id from website_pageviews where pageview_url = '/thank-you-for-your-order';
    
-- select pageview_url from website_pageviews where website_session_id=3040 order by created_at;


-- 8.
-- step1. find all order in requirement conditions(two landing page session_id)
-- step2. join order and calculate the revenue and revenue pre bill
-- step3. calculate lifting  revenue and pull the number of bill  last month  and calculate the impact


	
drop table if exists billing_page;
create temporary table billing_page
select
	t3.website_session_id,
    t3.website_pageview_id,
    pageview_url as home_page
from
(

select
	t1.website_session_id website_session_id,
    -- pageview_url as home_page,
    min(website_pageview_id) website_pageview_id
	
from
	website_pageviews as t1
		left join website_sessions as t2
			on t1.website_session_id=t2.website_session_id
where 

	t1.created_at between '2012-09-10' and '2012-11-10'
	-- and utm_source = 'gsearch'
    -- and utm_campaign = 'nonbrand'
    and pageview_url in ('/billing','/billing-1')
    
group by 1
-- having min(website_pageview_id);
) t3 left join website_pageviews t4 on t3.website_pageview_id = t4.website_pageview_id;

-- step2
select
	t1.website_session_id,
    home_page,
    items_purchased,
	price_usd

from
	billing_page t1
		left join orders t2
			on t1.website_session_id = t2.website_session_id
where cogs_usd is not null
order by price_usd desc;

-- step3

select
	home_page,
    count(website_session_id),
    sum(items_purchased * price_usd),
    sum(items_purchased * price_usd)/count(website_session_id)
from
	(
		select
			t1.website_session_id,
			home_page,
			items_purchased,
            price_usd

		from
			billing_page t1
				left join orders t2
					on t1.website_session_id = t2.website_session_id
		where cogs_usd is not null
	) t
    
group by home_page;


select * from orders where created_at between '2012-09-10' and '2012-11-10' order by items_purchased asc;


