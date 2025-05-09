# Netflix_Sql_Project
This repository is useful for:  Practicing advanced SQL - Preparing for data analyst interviews -  Performing exploratory data analysis (EDA) - Building insights dashboards for streaming platforms

# Netflix Movies And TV Shows Data Analysis using SQL
![Netflix Logo](https://github.com/Issita/Netflix_Sql_Project/blob/main/logo.png)

## Overview
Hey there! 👋
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
Netflix_dataset_link (https://github.com/Issita/Netflix_Sql_Project/blob/main/netflix_titles.csv)

## Technologies Used
- SQL Server Management Studio (SSMS)
- SQL Queries: JOINs, GROUP BY, CROSS APPLY, STRING_SPLIT, XML, DATE functions
- Data cleaning and transformation logic

## Business Problems and Solutions

### TOTAL NUMBER OF CONTENT
SELECT
COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX_TITLES;
