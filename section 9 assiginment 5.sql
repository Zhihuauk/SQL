-- section 9 assiginment 5

-- select all columns that we needed assosiated with website_pageviews table
drop table if exists cart_page;
create temporary table cart_page
select 
	website_session_id,
    count(case when pageview_url = '/cart' then 1 else null end) cart ,
    count(case when pageview_url = '/shipping' then 1 else null end) next_page ,
	case when created_at < '2013-09-25' then 'pro' else 'post' end create_time

from
	website_pageviews
where
	created_at between '2013-08-25' and '2013-10-25'
group by 1,4;



-- link to order table
drop table if exists cart_orders;
create temporary table cart_orders
select
	cart_page.website_session_id,
    create_time,
    cart,
    next_page,
    order_id,
    items_purchased,
    price_usd
    
    
    
from
	cart_page left join orders
		on cart_page.website_session_id = orders.website_session_id
where cart=1
;

select * from cart_orders;

-- aggregate data and group dat
select
	 create_time,
     sum(cart),
     sum(next_page),
     sum(next_page)/sum(cart),
     sum(items_purchased)/count(order_id),
     sum(price_usd)/count(order_id),
     sum(price_usd)/sum(cart)
from
	cart_orders
     
group by 1