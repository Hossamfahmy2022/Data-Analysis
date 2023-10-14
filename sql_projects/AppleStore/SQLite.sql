CREATE TABLE appleStore_description_combined as 
SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4

-- exploratry data analysis
--check number of unique app in both table appsAppleStore
SELECT COUNT(DISTINCT(id)) as  number_unique_app  from AppleStore

SELECT COUNT(DISTINCT(id)) as  number_unique_app  from appleStore_description_combined

-- ckeck for any missimg values in any key fields
select count(*) as missing_values
from AppleStore
WHERE   track_name isNULL or user_rating ISNULL or prime_genre ISNULL

select count(*) as missing_values
from appleStore_description_combined
WHERE   app_desc isNULL

-- find number of apps per gener
select prime_genre, COUNT(*) as number_of_apps
FROM AppleStore
GROUP by prime_genre
order by number_of_apps DESC
-- GET overview of apps rating
SELECT min(user_rating) as min_rating,
       max(user_rating) as max_rating,
       avg(user_rating) as avg_rating
FROM AppleStore

-- finding insights
-- determine whether paid apps have higher rating than free
SELECT 
CASE WHEN price>0 THEN 'paid'
else 'free'
END as App_type,avg(user_rating) as avg_rating
FROM AppleStore
GROUP by App_type

--ckeck if apps support more languages
SELECT
case 
when lang_num <10 THEN '<10 languages'
WHEN lang_num BETWEEN 10 and 30 THEN '10-30 languages'
ELSE '>30 languages' 
end as languages_number , COUNT(*) as frequency ,avg(user_rating) as avg_rating
FROM AppleStore
GROUP by languages_number
order by avg_rating desc

-- check gener with low rating
SELECT prime_genre,avg(user_rating) as avg_rating
FROM AppleStore
GROUP by prime_genre
order by avg_rating ASC
limit 10

-- check if have corrletion between length of app description and user rating

SELECT 
CASE
when length(B.app_desc) <500 THEN 'short'
WHEN length(B.app_desc) BETWEEN 500 and 1000 THEN 'medium'
ELSE 'long'
END as lenth_description,avg(user_rating) as avg_rating

FROM AppleStore A
INNER join appleStore_description_combined B
on A.id=B.id
GROUP by lenth_description
order by avg_rating DESC

--check on the top rated apps for each gener
SELECT prime_genre,track_name,user_rating
FROM(SELECT prime_genre,track_name,user_rating,
     rank() over (partition by prime_genre order by user_rating DESC ,rating_count_tot DESC) as rank 
     FROM AppleStore) as new_table
 WHERE rank=1    
     
     