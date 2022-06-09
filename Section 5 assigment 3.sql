-- Section 5 assigment 3

-- step1: create a table contents session_id and pageview_num
-- step2: create a table contents first_webpageview_id ,session_id and  first pageview_url
-- step3: calculate total num of fist_webpageview and bounce pageview_num
-- step4:

drop table if exists session_pageviews ;
create temporary table session_pageviews

select 
	website_session_id,
	count(website_session_id) as session_pv_num
from
	website_pageviews
-- where  created_at<'2012-06-14'

group by 
	website_session_id;

drop table if exists first_pageview ;
create temporary table first_pageview

select 
	min(website_pageview_id) first_pv_id,
	website_session_id
from 
	website_pageviews t1
where created_at <'2012-06-14'
		
group by 
	website_session_id;


drop table if exists first_pageview_url ;
create temporary table first_pageview_url
select 
	first_pageview.first_pv_id as first_pv_id,
	first_pageview.website_session_id as website_session_id,
    website_pageviews.pageview_url as pageview_url
from 
	first_pageview 
    left join website_pageviews 
    on first_pageview.first_pv_id = website_pageviews.website_pageview_id;
    


SELECT 
    first_pageview_url.pageview_url AS pageview_url,
    COUNT(first_pageview_url.website_session_id) AS sessions,
    COUNT(CASE
        WHEN session_pageviews.session_pv_num = 1 THEN 1
        ELSE NULL
    END) bounced_session,
    COUNT(CASE
        WHEN session_pageviews.session_pv_num = 1 THEN 1
        ELSE NULL
    END) / COUNT(first_pageview_url.website_session_id) AS bounced_rate
FROM
    session_pageviews
        LEFT JOIN
    first_pageview_url ON session_pageviews.website_session_id = first_pageview_url.website_session_id
GROUP BY pageview_url


