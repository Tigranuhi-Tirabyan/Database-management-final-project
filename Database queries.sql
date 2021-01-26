-- overview of tables
SELECT * FROM movies;
SELECT * FROM directors;
SELECT * FROM ratings;
SELECT * FROM profits;

-- find movies which were produced in same date (using self join)
SELECT l.title AS film1, r.title AS film2, l.release_date
FROM movies l, movies r
WHERE l.title <> r.title AND
r.release_date = l.release_date
GROUP BY l.release_date, l.title, r.title 
ORDER BY l.release_date desc;

-- A query to list the directors whose films have ratings higher than 8 

--- by inner join 
SELECT name AS director, title AS film, vote_average AS rating  
FROM directors d 
JOIN movies m ON d.id = m.director_id 
JOIN ratings r ON r.film_id = m.id
WHERE r.vote_average > 8
GROUP BY director, title, rating
ORDER BY rating;

--- by inner join, displaying only distinct names
SELECT DISTINCT name AS director
FROM directors d 
JOIN movies m ON d.id = m.director_id 
JOIN ratings r ON r.film_id = m.id
WHERE r.vote_average > 8;

--- by subquery in where statement
SELECT name AS director   
FROM directors d
WHERE d.id IN
(SELECT m.director_id  
 FROM movies m where m.id IN
 (SELECT film_id 
  FROM ratings WHERE vote_average > 8))
ORDER BY director;

-- A query to create view for names and profits of all the films which have positive profit
DROP VIEW IF EXISTS Movies_View;
CREATE VIEW Movies_View AS
SELECT m.title as film, m.release_date AS date, revenue - budget AS profit
FROM profits p
JOIN movies m ON p.film_id = m.id AND m.director_id = p.dir_id  
WHERE revenue - budget > 0
ORDER BY profit desc;

SELECT * FROM Movies_View;
SELECT AVG(profit) FROM Movies_View;

-- A query to display average revenue and average rating of films for each director
--- left join to display all names of directors, even if we have no data about their films
SELECT name AS director, AVG(revenue) AS average_revenue, AVG(vote_average) AS average_rating
FROM directors d 
LEFT JOIN profits p 
ON d.id = p.dir_id 
LEFT JOIN ratings r
ON p.film_id = r.film_id
GROUP BY name
ORDER BY name;

--- by subqueries
SELECT name AS director, profit.average_revenue, rating.average_rating
FROM directors d 
LEFT JOIN (SELECT dir_id, AVG(revenue) AS average_revenue 
 FROM profits 
 GROUP BY dir_id) AS profit
ON d.id = profit.dir_id 
LEFT JOIN (SELECT dir_id, AVG(vote_average) AS average_rating
 FROM profits p  JOIN ratings r ON r.film_id = p.film_id
 GROUP BY dir_id) AS rating  
ON profit.dir_id = rating.dir_id 
ORDER BY name;

-- Find films with maximum and minimum budget (higer 1000$)
SELECT film_id, budget, title
FROM movies, profits
WHERE budget = (SELECT MAX(budget) FROM profits)
AND film_id = id
UNION ALL
SELECT film_id, budget, title
FROM movies, profits
WHERE budget = (SELECT MIN(budget) FROM profits WHERE budget > 1000) AND film_id = id;

-- List ids, maximum, minimum, average ratings, maximum profits for films and count of films
---of every director (over partition) 
SELECT dir_id,name, max_rating, min_rating, average_rating, max_profit, films_count
FROM directors d JOIN 
(SELECT DISTINCT(dir_id), MAX(vote_average) OVER(PARTITION BY dir_id) AS max_rating, 
  MIN(vote_average) OVER(PARTITION BY dir_id) AS min_rating,
  AVG(vote_average) OVER(PARTITION BY dir_id) AS average_rating,
  MAX(revenue - budget) OVER(PARTITION BY dir_id) AS max_profit,
  COUNT(dir_id) OVER(PARTITION BY dir_id) AS films_count
 FROM profits p  JOIN ratings r ON r.film_id = p.film_id) AS agg 
ON d.id = agg.dir_id
ORDER BY dir_id;

-- find movies for weekend, which were produced after 2010 and have rating higher than 5
SELECT title AS film, release_date, vote_average AS rating
FROM movies JOIN ratings ON movies.id = ratings.film_id
WHERE (release_date >= '2010-12-31') AND (vote_average >5)
GROUP BY rating, title,  release_date
ORDER BY rating desc;






 
 