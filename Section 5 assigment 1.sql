-- Section 5 assigment 1
-- select * from website_pageviews

select
	pageview_url,
    count(distinct(website_session_id)) sessions
from 
	website_pageviews
where created_at < '2012-06-09'
group by pageview_url
order by sessions desc