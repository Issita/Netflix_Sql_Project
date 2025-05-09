CREATE DATABASE NETFLIX_DB;

USE NETFLIX_DB;

--Netflix Projet

CREATE TABLE NETFLIX(
show_id VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
castS VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);

SELECT * FROM [dbo].[netflix_titles];

--TOTAL NUMBER OF CONTENT

SELECT
COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX_TITLES;

--HOW MANY TYPE OF CONTENT PRESENT HERE 

SELECT 
DISTINCT TYPE
FROM NETFLIX_TITLES;

-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

SELECT
TYPE,
COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX_TITLES
GROUP BY TYPE;


--2. Find the most common rating for movies and TV shows

SELECT 
TYPE,
RATING
FROM
(
	SELECT 
	TYPE,
	RATING,
	COUNT(*) AS TOTAL_CONTENT,
	RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
	FROM NETFLIX_TITLES
	GROUP BY TYPE,RATING
) AS T1
WHERE RANKING = 1;


--3. List all movies released in a specific year (e.g., 2020)

--FILTER 2020
--FILTER MOVIES
SELECT  * FROM NETFLIX_TITLES
WHERE TYPE = 'MOVIE' AND RELEASE_YEAR = 2020;


--4. Find the top 5 countries with the most content on Netflix


SELECT TOP 5 
TRIM(value) AS country,
COUNT(*) AS total_content
FROM NETFLIX_TITLES
CROSS APPLY STRING_SPLIT(country, ',')
WHERE value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY total_content DESC;


--5. Identify the longest movie

SELECT * FROM NETFLIX_TITLES
WHERE TYPE = 'MOVIE' AND 
	DURATION = (SELECT MAX(DURATION) FROM NETFLIX_TITLES);


--6. Find content added in the last 5 years

SELECT * FROM NETFLIX_TITLES
WHERE DATE_ADDED >= DATEADD(YEAR,-5,GETDATE());

--ANOTHER APPORACH

SELECT *
FROM NETFLIX_TITLES
WHERE CONVERT(DATE, DATE_ADDED) >= DATEADD(YEAR, -5, GETDATE());

--OR

SELECT *
FROM NETFLIX_TITLES
WHERE CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM NETFLIX_TITLES
WHERE LOWER(DIRECTOR) LIKE '%Rajiv Chilaka%';


--8. List all TV shows with more than 5 seasons

SELECT *,
SUBSTRING(DURATION,1,CHARINDEX(' ',DURATION)-1) AS SEASONS
FROM NETFLIX_TITLES
WHERE TYPE = 'TV Show'
	AND 
	SUBSTRING(DURATION,1,CHARINDEX(' ',DURATION)-1)>5 ;

--ANOTHER METHOD

SELECT * FROM NETFLIX_TITLES
CROSS APPLY STRING_SPLIT(DURATION,' ') AS SPLIT_SEASONS
WHERE TYPE= 'TV Show'
	AND TRY_CAST(SPLIT_SEASONS.VALUE AS INT) > 5; --SPLIT_SEASONS.VALUE IT ACCESS THE INDIVIDUAL PARTS OF THE SPLIT DURATION 
												-- TRY_CAST - CONVERT THE SPLIT PART INTO  AN INTEGER FOR COMPARISON



--9. Count the number of content items in each genre

SELECT 
TRIM(VALUE)AS GENER,
COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM NETFLIX_TITLES
CROSS APPLY STRING_SPLIT(LISTED_IN,',') 
GROUP BY TRIM(VALUE)
ORDER BY TOTAL_CONTENT DESC;


--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

SELECT 
	COUNTRY,
	YEAR (DATE_ADDED) AS YEAR,
	COUNT(*) AS YEARLY_CONTENT,
	ROUND(
		CAST(COUNT(*) AS FLOAT)/ 
		CAST((SELECT COUNT(*) FROM NETFLIX_TITLES WHERE COUNTRY ='India') AS FLOAT) *100,2) AS AVG_RELEASE
FROM NETFLIX_TITLES
WHERE COUNTRY ='India' AND YEAR (DATE_ADDED) IS NOT NULL
GROUP BY COUNTRY, YEAR (DATE_ADDED)
ORDER BY AVG_RELEASE DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;



--11. List all movies that are documentaries


SELECT * FROM NETFLIX_TITLES
WHERE LOWER(LISTED_IN) LIKE '%documentaries%';


--12. Find all content without a director

SELECT * FROM NETFLIX_TITLES
WHERE director IS NULL;


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!


SELECT * FROM NETFLIX_TITLES
WHERE LOWER(casts) LIKE '%Salman Khan%'
	AND RELEASE_YEAR > YEAR(GETDATE()) - 10;



--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.


SELECT
--SHOW_ID,
--CASTS,
TRIM(VALUE) AS ACTORS,
COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM NETFLIX_TITLES
CROSS APPLY STRING_SPLIT(CASTS, ',')
WHERE COUNTRY LIKE '%India%'
GROUP BY TRIM(VALUE)
ORDER BY COUNT(SHOW_ID) DESC 
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;



--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.


SELECT
CATEGORY,
COUNT(*) AS TOTAL_CONTENT
FROM
(
SELECT *,
CASE
	WHEN LOWER(DESCRIPTION) LIKE '%Kill%'  OR
		LOWER(DESCRIPTION) LIKE'%violence%' THEN 'Bad'
		else 'Good'
	END AS CATEGORY
FROM NETFLIX_TITLES) AS T1
GROUP BY CATEGORY;

