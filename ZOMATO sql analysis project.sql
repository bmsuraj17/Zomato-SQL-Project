SELECT * from zomato;

#Top 5 most voted hotels in the delivery category

SELECT name, votes from zomato
where online_order="Yes"
order by votes desc
limit 5;

-- Rating of a hotel is a key identifier in determing a restaurant's performance. 
# Top 5 Highly rated hotels in the delivery category

SELECT name, rating 
from zomato 
where online_order = 'Yes' 
order by rating desc 
limit 5;

#Top 5 Highly rated hotels in the delivery category in "Banashankari" location

SELECT * from zomato
where online_order='Yes'
and location='Banashankari'
order by rating desc
limit 5;

#Comparision of cheapest and most expensive hotels in Indiranagar
-- Cheapest Hotel in Indiranagar
SELECT name as 'Cheapest Hotel', location, approx_cost
FROM zomato
WHERE location = 'Indiranagar'
ORDER BY approx_cost ASC
LIMIT 1;

-- Most Expensive Hotel in Indiranagar
SELECT name as 'Most Expensive Hotel', location, approx_cost
FROM zomato
WHERE location = 'Indiranagar'
ORDER BY approx_cost DESC
LIMIT 1;

WITH IndiranagarHotels AS (
  SELECT name, location, approx_cost
  FROM zomato
  WHERE location = 'Indiranagar'
)
-- select * from indiranagarhotels;
SELECT comparison_type, name, location, approx_cost
FROM (
  SELECT 'Cheapest Hotel' AS comparison_type, name, location, approx_cost
  FROM IndiranagarHotels
  ORDER BY approx_cost ASC
  LIMIT 1
) cheapest

UNION ALL

SELECT comparison_type, name, location, approx_cost
FROM (
  SELECT 'Most Expensive Hotel' AS comparison_type, name, location, approx_cost
  FROM IndiranagarHotels
  ORDER BY approx_cost DESC
  LIMIT 1
) most_expensive;

-- Online Ordering of food has exponentially increased over time.
#Comparison of total votes of restuarants that provide online ordering services and those who don't provide online ordering services

-- Total votes of restuarants that provide online ordering services

SELECT 'Online Ordering' AS ordering_service, SUM(votes) AS total_votes
FROM zomato
WHERE online_order = 'Yes'

UNION ALL

-- Total Votes for Restaurants without Online Ordering
SELECT 'No Online Ordering' AS ordering_service, SUM(votes) AS total_votes
FROM zomato
WHERE online_order = 'No';

SELECT
  rest_type,
  COUNT(*) AS number_of_restaurants,
  SUM(votes) AS total_votes,
  AVG(rating) AS average_rating
FROM zomato
GROUP BY rest_type
ORDER BY number_of_restaurants DESC;

# Number of restaurants, total votes, and average rating for each restaurant type

SELECT
  rest_type,
  COUNT(*) AS number_of_restaurants,
  SUM(votes) AS total_votes,
  AVG(rating) AS average_rating
FROM zomato
GROUP BY rest_type
ORDER BY number_of_restaurants DESC;

#Most liked dish of the most voted restaurant on zomato
SELECT name,dish_liked from zomato
where votes=(select max(votes) from zomato);

WITH MostVotedRestaurant AS (
  SELECT max(votes) as max_votes
  FROM zomato
)
SELECT z.name, z.dish_liked
FROM zomato z
JOIN MostVotedRestaurant mvr on z.votes = mvr.max_votes;

/* To increase the maximum profit, Zomato is in need to expand its business. 
For doing so Zomato wants the list of the top 15 restuarants which have min 150 votes, have a rating
greater than 3, and is currently not providing online ordering.*/

SELECT * from zomato
where votes>=150 and rating>3 
and online_order="No"
order by votes desc
limit 15 ;

# Total number and average rating of restaurants in each location
SELECT location, COUNT(*) as restaurant_count ,round(avg(rating),2) as Avg_rating
from zomato 
group by location
order by restaurant_count desc;

# Number of restaurants that offer online ordering
SELECT COUNT(*) as online_order_count FROM zomato WHERE online_order = 'Yes';

#Percentage of restaurants that allow table booking
SELECT (count(*)*100/(select count(*) from zomato)) as booking_percentage 
from zomato
where book_table='Yes';

# Most popular cuisines in bangalore

SELECT cuisines, count(*) as cuisine_count 
from zomato 
group by cuisines 
order by cuisine_count desc
limit 5;

# Restaurants that offer a specific cuisine (e.g., Chinese, Italian)
SELECT name,cuisines,location from zomato
where cuisines like '%chinese%';

# Average rating for each cuisine
SELECT cuisines, round(AVG(rating),2) as avg_rating 
from zomato 
group by cuisines 
order by avg_rating desc
limit 5;

# Distribution of approximate costs for two people

SELECT approx_cost, COUNT(*) as cost_count 
from zomato 
group by approx_cost 
order by approx_cost;

# Distribution of ratings for all restaurants
SELECT rating, COUNT(*) as rating_count 
from zomato 
group by rating 
order by rating desc ;

# Location with the most Biryani-serving restaurants.
SELECT location, COUNT(*) as biryani_count 
from zomato 
where cuisines like '%Biryani%' 
group by location
order by  biryani_count desc 
limit 1;

# Top 5 Restaurants with the Highest Ratings in Each Location
WITH RankedRestaurants AS (
  SELECT name, location, rating, row_number() over (partition by location order by rating desc) as ranking
  from zomato
)
SELECT name, location, rating
from RankedRestaurants
where ranking <= 5
order by 2;

SELECT location, online_order_percentage
from 
( SELECT location, round(COUNT(case when online_order = 'Yes' then 1 end) * 100 / COUNT(*),2)
AS online_order_percentage
from zomato
group by location)temp
order by online_order_percentage desc;

# Rank Restaurants Based on Votes Within Each Location
WITH RankedRestaurantsByVotes as (
  SELECT name, location, votes, dense_rank() over (partition by location order by votes desc) as ranking
  from zomato
)
SELECT name, location, votes
from RankedRestaurantsByVotes
where ranking <= 5
order by 2;











