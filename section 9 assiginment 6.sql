-- section 9 assiginment 6


-- select all columns that we needed assosiated with website_pageviews table
drop table if exists websission_page;
create temporary table websission_page
select 
	distinct(website_session_id) website_session_id,
	case when created_at < '2013-12-12' then 'pro' else 'post' end create_time

from
	website_pageviews
where
	created_at between '2013-11-12' and '2014-1-12'
-- group by 1,4
;



-- link to order table
drop table if exists session_orders;
create temporary table session_orders
select
	websission_page.website_session_id,
    create_time,
    order_id,
    items_purchased,
    price_usd
    
    
    
from
	websission_page left join orders
		on websission_page.website_session_id = orders.website_session_id
-- where cart=1
;

select * from session_orders;

-- aggregate data and group dat
select
	 create_time,
     count(order_id)/count(website_session_id),
     sum(price_usd)/count(order_id),
     sum(items_purchased)/count(order_id),
     
     sum(price_usd)/count(website_session_id)
from
	session_orders
     
group by 1