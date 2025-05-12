# Netflix_Sql_Project
This repository is useful for:  Practicing advanced SQL - Preparing for data analyst interviews -  Performing exploratory data analysis (EDA) - Building insights dashboards for streaming platforms

# Netflix Movies And TV Shows Data Analysis using SQL
![Netflix Logo](https://github.com/Issita/Netflix_Sql_Project/blob/main/logo.png)

## Overview
Welcome to my Netflix SQL Analysis project.

In this project, I’ve taken a deep dive into Netflix’s massive catalog of movies and TV shows using SQL Server. The idea was simple — treat the dataset like a treasure chest of stories and see what we can learn from it. Whether it's figuring out what kind of content dominates the platform, which countries produce the most, or spotting patterns in ratings, I wanted to turn raw data into meaningful insights.

Think of this as a behind-the-scenes look at the world of Netflix — powered by SQL queries!

## Objectives
Here’s what I set out to explore:
- Movies vs TV Shows: Which one rules Netflix's content library?
- Content Ratings: What are the most common audience ratings, and how do they differ between movies and shows?
- Yearly Trends: How has Netflix’s content evolved over the years? What was released in key years like 2020?
- Geographic Focus: Which countries are contributing the most to Netflix’s content?
- Hidden Gems: Find the longest movie, content without directors, or works by specific creators like Rajiv Chilaka or Salman Khan.
- Genre Deep Dive: How is content distributed across different genres?
- Keyword Classification: Classify content as “Good” or “Bad” based on the presence of words like kill or violence in the descriptions.
- India Spotlight: Zoom in on Indian content trends over the years — and find out which years were most productive!

This project not only sharpened my SQL skills but also gave me the chance to think like a data storyteller — turning numbers into answers, and answers into insight

## Dataset
Here is the dataset from kaggle 
[Netflix_dataset_link] (https://github.com/Issita/Netflix_Sql_Project/blob/main/netflix_titles.csv)

## Technologies Used
- SQL Server Management Studio (SSMS)
- SQL Queries: JOINs, GROUP BY, CROSS APPLY, STRING_SPLIT, XML, DATE functions
- Data cleaning and transformation logic

## Business Problems and Solutions

### 1. TOTAL NUMBER OF CONTENT
```sql
SELECT
COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX_TITLES;
```

### 2. HOW MANY TYPE OF CONTENT PRESENT HERE 
```sql
SELECT 
DISTINCT TYPE
FROM NETFLIX_TITLES;
```

### 3. Count the number of Movies vs TV Shows
```sql
SELECT
TYPE,
COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX_TITLES
GROUP BY TYPE;
```

### 4. Find the most common rating for movies and TV shows
```sql
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
```

### 5. List all movies released in a specific year (e.g., 2020)
```sql
--FILTER 2020
--FILTER MOVIES
SELECT  * FROM NETFLIX_TITLES
WHERE TYPE = 'MOVIE' AND RELEASE_YEAR = 2020;
```

### 6. Find the top 5 countries with the most content on Netflix
```sql
SELECT TOP 5 
TRIM(value) AS country,
COUNT(*) AS total_content
FROM NETFLIX_TITLES
CROSS APPLY STRING_SPLIT(country, ',')
WHERE value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY total_content DESC;
```

### 7. Identify the longest movie
```sql
SELECT * FROM NETFLIX_TITLES
WHERE TYPE = 'MOVIE' AND 
	DURATION = (SELECT MAX(DURATION) FROM NETFLIX_TITLES);
```

### 8. Find content added in the last 5 years
```sql
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
```

### 9. Find all the movies/TV shows by director 'Rajiv Chilaka'!
```sql
SELECT * FROM NETFLIX_TITLES
WHERE LOWER(DIRECTOR) LIKE '%Rajiv Chilaka%';
```

### 10. List all TV shows with more than 5 seasons
```sql

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

```


### 11. Count the number of content items in each genre
```sql
SELECT 
TRIM(VALUE)AS GENER,
COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM NETFLIX_TITLES
CROSS APPLY STRING_SPLIT(LISTED_IN,',') 
GROUP BY TRIM(VALUE)
ORDER BY TOTAL_CONTENT DESC;
```

### 12. Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
```sql
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
```

### 13. List all movies that are documentaries
```sql
SELECT * FROM NETFLIX_TITLES
WHERE LOWER(LISTED_IN) LIKE '%documentaries%';
```

### 14. Find all content without a director
```sql
SELECT * FROM NETFLIX_TITLES
WHERE director IS NULL;
```

### 15. Find how many movies actor 'Salman Khan' appeared in last 10 years!
```sql
SELECT * FROM NETFLIX_TITLES
WHERE LOWER(casts) LIKE '%Salman Khan%'
	AND RELEASE_YEAR > YEAR(GETDATE()) - 10;
```

### 16. Find the top 10 actors who have appeared in the highest number of movies produced in India.
```sql
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
```

### 17.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
```sql
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
```

