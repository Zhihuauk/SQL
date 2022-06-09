-- Section 5 assigment 5

drop table if exists website_sessions_limit_id;
create temporary table website_sessions_limit_id

select 
	website_session_id
from
	website_sessions
where 
	created_at between '2012-06-01' and '2012-08-31'
    -- and utm_source='gsearch'
    and utm_campaign='nonbrand';


drop table if exists sessions_pageurl;
create temporary table sessions_pageurl
select 
	t1.landing_page_id,
    t1.website_session_id,
    t2.pageview_url,
    t2.created_at
from
	(
		select 
			min(website_pageview_id) as landing_page_id,
			website_session_id
		from 
			website_pageviews
		where 
			created_at between '2012-06-01' and '2012-08-31'
            and pageview_url in ('/home','/lander-1')
			
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
		when pageview_num=1 
        then 1 
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
			created_at between '2012-06-01' and '2012-08-31' 
            -- and pageview_url in ('/home','/lander-1')
		group by website_session_id
	) temp;
    
    
drop table if exists time_session_bounce;
create temporary table time_session_bounce

select 
	landing_page_id,
	t1.website_session_id,
	pageview_url,
	created_at,
	pageview_num,
	bounce_or_not
	
from
	sessions_pageurl t1
		left join pageview_num_bounce t2
			on t1.website_session_id = t2.website_session_id
where 
	t1.website_session_id in 
    (
		select website_session_id from website_sessions_limit_id
    )
;
   -- and pageview_url = '/lander-1';



select
	
    min(date(created_at)) as start_day,
    sum(case
			when pageview_url='/home'
            then 1 
            else 0
		end) as home_session,
	sum(case
			when pageview_url='/lander-1'
            then 1 
            else 0
		end) as lander_session,
	sum(case
			when bounce_or_not=1 
            then 1 
            else 0
		end) as all_bounce_num,
	(sum(case
			when bounce_or_not=1 
            then 1 
            else 0
		end))/
	(count(website_session_id)) as bounced_rate
    
from
	time_session_bounce
group by
	week(created_at) 
    

		



        