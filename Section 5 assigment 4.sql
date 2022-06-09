-- Section 5 assigment 4

drop table if exists start_time;
create temporary table start_time
-- result 2012-06-19
select
	pageview_url,
    min(created_at) start_time
from 
	website_pageviews
where 
	pageview_url = '/lander-1'
group by pageview_url;

drop table if exists website_sessions_limit_id;
create temporary table website_sessions_limit_id

select 
	website_session_id
from
	website_sessions
where 
	created_at between '2012-06-19' and '2012-07-28'
    and utm_source='gsearch'
    and utm_campaign='nonbrand';


drop table if exists sessions_pageurl;
create temporary table sessions_pageurl

select 
	t1.landing_page_id,
    t1.website_session_id,
    t2.pageview_url
from
	(
		select 
			min(website_pageview_id) as landing_page_id,
			website_session_id
		from 
			website_pageviews
		where created_at between '2012-06-19' and '2012-07-28'
			
        group by website_session_id
	) t1
    left join 
    website_pageviews t2 on t1.landing_page_id = t2.website_pageview_id
;

drop table if exists pageview_num_bounce;
create temporary table pageview_num_bounce

select
	website_session_id,
    pageview_num,
    case 
		when pageview_num=1 then 1 
        else 0 
	end  as bounce_or_not
    
from
	(
		select
			website_session_id,
			count(website_session_id) as pageview_num
		from
			website_pageviews
		where 
			created_at between '2012-06-19' and '2012-07-28' 
		group by website_session_id
	) temp;


select 
	t1.pageview_url,
    count(t1.website_session_id) as sessions,
    sum(t2.bounce_or_not) as bounce_page,
    sum(t2.bounce_or_not)/count(t1.website_session_id) as bonced_rate
    
    
from 
	sessions_pageurl t1
		left join pageview_num_bounce t2
			on t1.website_session_id = t2.website_session_id
where 
	t1.website_session_id in 
    (
		select 
			website_session_id
		from
			website_sessions_limit_id
	)
			
group by 
	pageview_url;
    



	

