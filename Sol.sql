--Q1. Count the number of Movies vs TV Shows
select 
type,
count(*) as type_count
from Netflix
group by type;

--Q2. Find the most common rating for Movies and TV Shows
select 
type, 
rating
from
(select 
type,
rating,
count(*),
rank() over (partition by type order by count(*) desc )as ranking
from Netflix
group by type,rating
) as Te
where ranking=1;

--Q3. List all movies realeased in a specific year 2020
select *from Netflix
where type='Movie' and release_year=2020;

--Q4. Find the top 5 countries with the most content on Netflix
select 
Unnest(string_to_array(country,',')) as new,
Count(show_id) as total
from Netflix
Group by new
order by total desc
limit 5;

--Q5. Identify the longest movie
select
title,
duration
from netflix
where type='Movie'
and duration= (select max(duration)from Netflix)

--Q6. Find content added in the last 5 years
Select * from Netflix
where to_date(date_added,'Month DD,YYYY')>= current_date - INTERVAL '5 years';

--Q7. Find all the movies/ TV shows by director 'Rajiv Chilaka'
Select * from Netflix
where director ilike '%Rajiv Chilaka%'

--Q8. List all TV shows with more than 5 seasons
select * from Netflix
where type='TV Show' and
split_part(duration,' ',1)::numeric>5 ;

--Q9. Count the number of content in each genre
select
unnest(string_to_array( listed_in,',')) as ind,
count(*)
from Netflix
group by ind;

--Q10. Find each year and the average numbers of content released in India on Netflix. Return top 5 with highest avg content release.
--with release_year
select release_year,
round(count(*)::numeric/(select count(*) from Netflix where country='India')::numeric *100,2) as Average
from Netflix
where country='India'
group by release_year
Order by Average desc
Limit 5;

--with date_added
select 
Extract(year from To_date(date_added,'Month DD,YYYY')) as release_year,
round(count(*)::numeric/(select count(*) from Netflix where country='India')::numeric *100,2) as Average
from Netflix
where country='India'
group by 1
order by 2 desc
limit 5;

--Q11. List all movies that are documentaries
Select * from Netflix where type='Movie' and listed_in ilike '%Documentaries%' ;

--Q12. Find all content without a director
select * from Netflix where director is null;

--Q13. Find how many movies actor'Salman Khan' appeared in last 10 years
Select  count(*) from Netflix where type='Movie' and casts ilike '%Salman Khan%' and release_year> extract (year from current_date) - 10;

--Q14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select count(*),unnest(string_to_array(casts,',')) as actors from Netflix where country ilike '%India%' and type='Movie'
group by 2 
order by 1 desc limit 10;

--Q15. Categorize the content based on the presence of the keyword 'kill' and 'voilence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
with cat_table as(
select *,
case
when description ilike '%kill%' or description ilike '%voilence%' then 'Bad'
else 'Good'
end Category
from Netflix)
select
count(*),
category
from cat_table
group by 2 ;




