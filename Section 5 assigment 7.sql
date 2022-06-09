-- Section 5 assigment 7
-- not complete

-- step1: find the first /billing-2 start time
-- step2: create a temp table content: website_session_id,website_pageview_id,created_at,pageview_url
-- step3: filter the temp table
-- step4: 

select
	min(created_at),
    pageview_url
from 
	website_pageviews
where 
	pageview_url = '/billing-2';

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
	t2.created_at between '2012-09-10' and '2012-11-10'
    and t1.pageview_url in ('/billing','/billing2','/thank-you-for-your-order')
;


select * from conversion_funnel;

select
			website_session_id,
			case
				when  pageview_url =  '/billing'
                 
				then '/billing'
				else '/billing-2'
			end as 'billing',
			case
				when ('/thank-you-for-your-order') in pageview_url
				then 1
				else null
			end as 'order'

		from
			conversion_funnel;
            
            
            
Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'pageview_url      then '/billing'     else '/billing-2'    end as 'billing',    ' at line 4



select

	billing,
	count(billing),
    count(case when make_order = 1 then 1 else null end)
	
   
    
from

	(
		select
			website_session_id,
			case
				when pageview_url = '/billing'
				then '/billing'
				else '/billing-2'
			end as 'billing',
			case
				when pageview_url = '/thank-you-for-your-order'
				then 1
				else null
			end as 'make_order'

		from
			conversion_funnel
    
    ) temp

group by billing


