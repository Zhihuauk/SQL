-- Section 5 assigment 2Section 5 assigment 2


create temporary table first_website_pageview_id 
select
	min(website_pageview_id) website_pageview_id,
    created_at,
    website_session_id,
    pageview_url
from 
	website_pageviews
where created_at < '2012-06-12'
group by 2,3,4;


select 
	pageview_url,
    count(distinct(website_session_id)) sessions
from
	first_website_pageview_id 
group by 1
order by sessions desc


