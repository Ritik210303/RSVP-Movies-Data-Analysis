USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- checking whether all the tables are present along with the data or not

SELECT * 
FROM movie;

SELECT * 
FROM role_mapping;

SELECT * 
FROM names;

SELECT * 
FROM genre;

SELECT *
FROM ratings;

SELECT * 
FROM director_mapping;


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Total number of rows in movie tabel
SELECT Count(*) AS "Total Rows"
FROM   movie; 

-- Total number of rows in role_mapping tabel
SELECT Count(*) AS "Total Rows" 
FROM role_mapping;

-- Total number of rows in names tabel
SELECT Count(*) AS "Total Rows" 
FROM names;

-- Total number of rows in genre tabel
SELECT Count(*) AS "Total Rows" 
FROM genre;

-- Total number of rows in ratings tabel
SELECT Count(*) AS "Total Rows" 
FROM ratings;

-- Total number of rows in director_mapping tabel
SELECT Count(*) AS "Total Rows" 
FROM director_mapping;



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- qurey to find the columns which contains null value in movie table

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS 'ID Null Count',
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           end) AS 'Title Null Count',
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           end) AS 'Year Null Count',
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           end) AS 'date_published Null Count',
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           end) AS 'duration Null Count',
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           end) AS 'country Null Count',
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           end) AS 'worlwide_gross_income Null Count',
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           end) AS 'languages Null Count',
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           end) AS 'production_company Null Count'
FROM   movie; 

-- we have used case statment in sum to get total number of null values in column and if column does not have null value then it will show 0

--  hence counrty, worldwide_gross_income, languages, production_company are the columns in movie table which contain null values.


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- total number of movies released each year

SELECT year     AS 'Year',
       Count(*) AS 'number_of_movies'
FROM   movie
GROUP  BY year; 

-- we have selected year and used count to get number of movies and grouped it by year
-- the highest number of movies where produced in 2017

-- total number of movies released each month
SELECT Month(date_published) AS 'month_num',
       Count(*)              AS 'number_of_movies'
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

-- we have used month() to extract month from date_publish and used count to get number of movies and grouped it by month
-- The highest number of movies were produce in march month



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(DISTINCT id) AS 'number of movies',
       year
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 

-- we have used count function to count number of movies where country is india or usa and year is 2019
-- 1059 movies where produce in india or uas in year 2019




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 

-- there are 13 genres


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(m.id) AS 'number_of_movies'
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY number_of_movies DESC
LIMIT  1; 

/*
we have done the inner join of table movie and genre then grouped it by genre and arraged it in descending order based on number of movies
selected count(m.id) and genre to be displayed and limited output to 1 record to get know which genre had the highest number 
of movies produced overall
*/

-- highest number of movies where produced in Drama which were 4285


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_with_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre; 

/*
we have created the cte named movies_with_one_genre which contains column movie_id from genre table 
grouped it by movied_id and having  Count(DISTINCT genre) equal to  1
then in main query we have used count(*) to dispaly number of movies with one genre
*/

-- 3289 movies belong to only one genre





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
       Round(Avg(duration), 2) AS "avg_duration"
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY avg_duration DESC; 

/*
we have inner joined genre and movie table then we have grouped it by genre and ordered by avg_duration(which is 'Round(Avg(duration),2)') desc and selected genre and 
Round(Avg(duration), 2) to be displayed
*/
-- action genre movie has the highest avg_duration which is 112.88 followed by Romance






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH rank_info
     AS (SELECT genre,
                Count(movie_id)                    AS 'movie_count',
                Rank()
                  OVER(ORDER BY Count(movie_id) DESC) AS 'genre_rank'
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   rank_info
WHERE  genre = 'Thriller'; 
-- first we have created the cte named rank_info to rank all genre movie based on movie_id count then we have selected the thriller gener from the resulting table or cte
-- total movies in thriller genre are 1484 and its rank is 3






/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT Min(avg_rating)    'min_avg_rating',
       Max(avg_rating)    'max_avg_rating',
       Min(total_votes)   'min_total_votes',
       Max(total_votes)   'max_total_votes',
       Min(median_rating) 'min_median_rating',
       Max(median_rating) 'max_median_rating'
FROM   ratings; 

-- so the values are 1, 10, 100, 725138, 1 and 10 respectively


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH avg_rating_rank
     AS (SELECT m.title,
                r.avg_rating,
                Row_number()
                  OVER(
                    ORDER BY r.avg_rating DESC) AS 'movie_rank'
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id)
SELECT *
FROM   avg_rating_rank
WHERE  movie_rank <= 10; 

/* here we have created the cte named avg_rating_rank which contains title and avg_rating column and ranked it based on avg_rating using row_number 
then we have selected movies rank 10 or less from the resulting cte
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS 'movie_count'
FROM   ratings
GROUP  BY median_rating
order by median_rating asc;

/*
we have grouped ratings by median_rating and organised data in ascending order based on median_rating and 
then selected median_rating,  Count(movie_id) to be displayed
*/
-- 2257 movies have 7 median ratings which is highest



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH hit_movie_production_company
     AS (SELECT m.production_company,
                Count(r.movie_id)                    AS 'movie_count',
                Rank()
                  OVER(
                    ORDER BY Count(r.movie_id) DESC) AS 'prod_company_rank'
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  r.avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY m.production_company)
SELECT *
FROM   hit_movie_production_company
WHERE  prod_company_rank = 1; 

/*
here first we have created the cte hit_movie_production_company which contains production company, number of hit movies produced by company and production companies are
ranked using rank fuction or window based on number of movies in descending order. Then the production company ranked 1 is selected from the cte
*/
-- Dream Warrior Pictures and National Theatre Live are ranked 1.

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
       Count(m.id) AS 'movie_count'
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  Month(m.date_published) = 3
       AND m.country LIKE '%USA%'
       AND r.total_votes > 1000
       AND year = 2017
GROUP  BY g.genre
ORDER  BY movie_count DESC; 

/*
we have done inner join of three tables movie, genre and ratings using movie_id and id columns. 
Then we have extracted month from date_published using month and puted all other necessary conditions in where caluse
After that we have grouped it by genre and used count function to count movies prodced in each gener
then we have oraganised data in descinding order based on number of movies
then we have selected movie count and gener column to display
*/

-- 24 movies were relesed in drama genre which is highest among all genre


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.title,
       r.avg_rating,
       g.genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  r.avg_rating > 8
       AND m.title LIKE 'The%'
ORDER  BY r.avg_rating DESC; 

/*
I have done inner join of three tables movie, genre and ratings using movie_id and id columns. 
Then I have put all necessary conditions in where caluse
then I have oraganised data in descinding order based on avg_ratings
then I have selected title, avg_rating and gener column to display
*/
/*
I have tried group by titel to avoid repitation of title but for some reason it is not working 
I also tried to make cte and group by but it did not work. So I tried distinct that also did not worked
Then I created the view but it also did not worked
*/
-- there are total 8 movies that begin with the and has avg_rating>8
-- The top three movies from the above qurey belong to drama genre which are The Brighton Miracle, The Colour of Darkness and The Blue Elephant 2


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
SELECT m.title,
       r.median_rating,
       g.genre
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  r.avg_rating > 8
       AND m.title LIKE 'The%'
ORDER  BY r.avg_rating DESC; 

-- in medain_rating also we get similar output as previous query 

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT r.median_rating,
       Count(r.movie_id) AS 'Number of movies'
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  ( m.date_published BETWEEN '2018-04-01' AND '2019-04-01' )
       AND r.median_rating = 8; 

/*
we have inner joined movie and ratings table then in where clause we have put data_published should be between 2018-04-01 AND 2019-04-01
and medain rating should be 8
then we have selected median_rating and COUNT(r.movie_id) to be displayed
*/
-- 361 movies has been released between 1 April 2018 and 1 April 2019 with median rating 8



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Using country column 
WITH total_votes_by_country AS (
    SELECT 
        m.country,
        SUM(r.total_votes) AS total_votes
    FROM 
        movie AS m
    INNER JOIN 
        ratings AS r ON m.id = r.movie_id
    WHERE 
        m.country = 'Germany' OR m.country = 'Italy'
    GROUP BY 
        m.country
)

SELECT 
    CASE 
        WHEN (SELECT total_votes FROM total_votes_by_country WHERE country = 'Germany') > 
             (SELECT total_votes FROM total_votes_by_country WHERE country = 'Italy')
        THEN 'Yes, German movies get more votes'
        ELSE 'No, Italian movies get more votes'
    END AS comparison_result;

/*
we have create a cte named total_votes_by_country where we have inner joined ratings and movie table 
and in where clause we have put country should be germany or italy
then we have grouped it by country and selected Sum(r.total_votes) and country to be displayed
then in main query we have used case statment if germany have more votes it shows yes otherwise no
*/
    
-- Using language column 
WITH total_votes_by_languages
     AS (SELECT CASE
                  WHEN m.languages LIKE '%German%' THEN 'German'
                  WHEN m.languages LIKE '%Italian%' THEN 'Italian'
                END                AS primary_language,
                Sum(r.total_votes) AS total_votes
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  m.languages LIKE '%German%' OR m.languages LIKE '%Italian%'
         GROUP  BY primary_language)
SELECT CASE
         WHEN (SELECT total_votes FROM total_votes_by_languages WHERE  primary_language = 'German') > 
         (SELECT total_votes FROM total_votes_by_languages WHERE primary_language = 'Italian') THEN
         'Yes, German movies get more votes'
         ELSE 'No, Italian movies get more votes'
       END AS comparison_result; 

/*
here we have created the cte named total_votes_by_languages where we have inner joined ratings and movie table 
in where clause we have put languages like %german% or languages like %italian%
as a movie can be in multiple languages so in select we have used case statement that if languages like %german% then add german 
as primary language and same for italian then we have grouped it by primary language and also selected um(r.total_votes) 
then in main query we have used case statment if german have more votes it shows yes otherwise no
*/

-- in both country and language we get more number of votes for germany.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           end) AS 'name_nulls',
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           end) AS 'height_nulls',
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           end) AS 'date_of_birth_nulls',
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           end) AS 'known_for_movies_nulls'
FROM   names; 

-- we have used case statment in sum to get total number of null values in column and if column does not have null value then it will show 0
-- height, date of birth and known for movies contains the null vales 17335, 13431 and 15226, respectively.



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_three_genre
AS
  (
             SELECT     genre
             FROM       movie AS m
             INNER JOIN genre AS g
             ON         m.id=g.movie_id
             INNER JOIN ratings AS r
             ON         r.movie_id=m.id
             WHERE      avg_rating> 8
             GROUP BY   genre
             ORDER BY   count(m.id) DESC
             LIMIT      3 )
  SELECT     name,
             count(m.id)      AS 'movie_count'
  FROM       names            AS n
  INNER JOIN director_mapping AS d
  ON         n.id=d.name_id
  INNER JOIN movie AS m
  ON         d.movie_id=m.id
  INNER JOIN genre AS g
  ON         m.id=g.movie_id
  INNER JOIN ratings AS r
  ON         m.id=r.movie_id
  WHERE      (g.genre IN(SELECT genre FROM top_three_genre))
  AND        r.avg_rating>8
  GROUP BY   name
  ORDER BY   count(m.id) DESC
  LIMIT      3;

/*
we have created cte named top_three_genre to fetch top 3 genres 
Then in manin query we have joined director_mapping, movie, names, genre, ratings
Then we have put where caluse to get the movies from top three genres and whose avg_rating is greater than 8
After that we have grouped it by name 
then we have selected movie count and name column to display
then we have organized data in descending order based on movie_count and limit the output to three records or rows
*/

-- James Mangold, Joe Russo, Anthony Russo are the top three directors

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name      AS 'actor_name',
       Count(m.id) AS 'movie_count'
FROM   names AS n
       INNER JOIN role_mapping AS rm
               ON rm.name_id = n.id
       INNER JOIN movie AS m
               ON m.id = rm.movie_id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  r.median_rating >= 8
       AND rm.category = 'Actor'
GROUP  BY n.name
ORDER  BY Count(m.id) DESC
LIMIT  2; 

/*
we have done inner joined names, role_mapping, movie and ratings table
Then in where caluse we have selected rows or record who have median_rating greater than 8 and category actor
then we have grouped it by name
and selected name and count(m.id) to be displayed
we have organised data in descending order based on count(m.id)
and limit the output to two records
*/

-- Mammootty and Mohanlal are top two actors


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_ranking
     AS (SELECT m.production_company,
                Sum(r.total_votes)                    AS 'vote_count',
                Rank()
                  OVER(ORDER BY Sum(r.total_votes) DESC) AS 'prod_comp_rank'
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         GROUP  BY m.production_company)
SELECT *
FROM   production_company_ranking
WHERE  prod_comp_rank < 4; 

/*
here we have created the cte named production_company_ranking to rank all the production houses based on total_votes
then in main query in where caluse we have put prod_comp_rank should be less than 4 to get top three production company
*/

-- Marvel Studios, Twentieth Century Fox and Warner Bros are the top three production companies


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actors_rank
     AS (SELECT n.NAME AS 'actor_name' ,
                Sum(r.total_votes) AS 'total_votes',
                Count(m.id) AS 'movie_count',
                Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2)
                AS 'actor_avg_rating'
         FROM   names AS n
                INNER JOIN role_mapping AS rm
                        ON n.id = rm.name_id
                INNER JOIN movie AS m
                        ON m.id = rm.movie_id
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  rm.category = 'Actor'
                AND m.country LIKE '%india%'
         GROUP  BY rm.name_id
         HAVING Count(DISTINCT m.id) >= 5)
SELECT *,
       Rank() OVER( ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actors_rank; 
/*
we have created cte named actors_rank where we have joined names, role_mapping, movie, ratings table
then in where caluse we have put category to be actor and counrty to be india
then we have grouped it by name_id and should have m.id greater than or equal to 5
then we have selected name, sum(total_votes), count(m.id)
and calculated actors_avg_rating as avg_rating * total votes divided by sum(total_votes) and rounded it upto 2 decimal values
then in main qurey we have used rank window or function to give rank to each actor based on actor_avg_rating
*/

-- top three actors are Vijay Sethupathi, Fahadh Faasil, Yogi Babu

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actoress_rank
AS
  (
             SELECT     n.name                                                           AS 'actress_name',
                        Sum(r.total_votes)                                               AS 'total_votes',
                        Count(m.id)                                                      AS 'movie_count',
                        Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS 'actress_avg_rating'
             FROM       names                                                            AS n
             INNER JOIN role_mapping                                                     AS rm
             ON         n.id=rm.name_id
             INNER JOIN movie AS m
             ON         m.id=rm.movie_id
             INNER JOIN ratings AS r
             ON         m.id=r.movie_id
             WHERE      rm.category='actress'
             AND        m.languages LIKE '%hindi%'
             AND        m.country = 'india'
             GROUP BY   rm.name_id
             HAVING     Count(DISTINCT m.id)>=3 )
  SELECT   *,
           rank() over(ORDER BY actress_avg_rating DESC) AS actores_rank
  FROM     actoress_rank
  LIMIT    5;
/*
we have created cte name actoress_rank where we have joined names, role_mapping, movie, ratings table
then in where caluse we have put category to be actress and counrty to be india and laguage to be hindi
then we have grouped it by name_id and should have m.id greater than or equal to 3
then we have selected name, sum(total_votes), count(m.id)
and calculated actoress_avg_rating as avg_rating * total votes divided by sum(total_votes) and rounded it upto 2 decimal values
then in main qurey we have used rank window or function to give rank to each actor based on actress_avg_rating
*/

-- the top five actress are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

  

SELECT DISTINCT m.title,
                r.avg_rating,
                CASE
                  WHEN avg_rating > 8 THEN 'Superhit movies'
                  WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
                  WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
                  ELSE 'Flop movies'
                end AS 'avg_rating_category'
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  g.genre = 'Thriller'; 

/*
 we have inner joined tables genre, movie and ratings
 Then in where clause we have put genre equl to thriller to select only thriller genre movies
 then we have selected title and avg_ratings and used case statment to assign appropriate catetgory to each movie or title based on avg_rating
*/

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT genre,
       AVG(duration)   AS  'avg_duration',
       Sum(AVG(duration))
         OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS  'running_total_duration',
       Avg(Avg(duration))
         OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS  'moving_avg_duration'
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 
/*
we have inner joined the table movie and genre
then we have grouped it by genre and organised data in ascending order based on genre 
we have selected genre, then used AVG(duration) to get average duration of each genre 
then used SUM(AVG(duration)) to get running total duration along with unbounded preceding and current row
and used AVG(AVG(duration)) to get moving average duration  alon with rows between 2 preceding and current row
*/


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_3_genre AS (
    SELECT genre
    FROM genre
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),
find_rank AS (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        CASE
            -- Convert INR to USD
            WHEN m.worlwide_gross_income LIKE '%INR%' THEN 
                Concat('$', Round(Cast(REPLACE(Substring(m.worlwide_gross_income, 2, Length(m.worlwide_gross_income) - 5), ',', '') AS DECIMAL(15,2)) / 75, 2))
            -- Keep USD values as they are
            ELSE 
                m.worlwide_gross_income
        END AS worlwide_gross_income,
        RANK() OVER (
            PARTITION BY g.genre, m.year 
            ORDER BY 
                CASE
                    WHEN m.worlwide_gross_income LIKE '%INR%' THEN 
                        Cast(REPLACE(Substring(m.worlwide_gross_income, 2, Length(m.worlwide_gross_income) - 5), ',', '') AS DECIMAL(15,2)) / 75
                    ELSE 
                        Cast(REPLACE(Substring(m.worlwide_gross_income, 2), ',', '') AS DECIMAL(15,2))
                END DESC
        ) AS movie_rank
    FROM 
        movie AS m
    INNER JOIN 
        genre AS g ON m.id = g.movie_id
    WHERE 
        g.genre IN (SELECT genre FROM top_3_genre) and worlwide_gross_income is not null
)
SELECT *
FROM find_rank
WHERE movie_rank <= 5
ORDER BY year, genre, movie_rank;

/*
first we have created top_3_genre cte to get the top three genre based on most number of movies
then we have created find_rank cte to rank the movies from top 3 genre based on there world wide gross income for every particular year
As few movies had gross income in INR so we had converted it to $ for appropriate ranking
then in main query we have used find_rank cte and in where caluse we have put movie_rank less than or equal to 5 and organized data in ascending order based on year, genre and movie_rank
So  the output will provide top five movies of every genre in each year
*/



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_data
AS
  (
             SELECT     m.production_company,
                        Count(m.id) AS 'movie_count'
             FROM       movie       AS m
             INNER JOIN ratings     AS r
             ON         m.id=r.movie_id
             WHERE      r.median_rating>=8
             AND        Position(',' IN languages)>0
             AND        m.production_company IS NOT NULL
             GROUP BY   m.production_company
             ORDER BY   Count(m.id) DESC )
  SELECT   *,
           rank() over(ORDER BY movie_count DESC) AS 'prod_comp_rank'
  FROM     production_company_data
  LIMIT    2;
  
/*
first we have created the cte name production_company_data in which we have inner joined movie and rating table
Then in where clause we have put  median_rating greater than or equal to 8 and POSITION(',' IN languages)>0 to get m.id which are multilingual movies and production_company should not be null
then we have grouped by production_company and ordered data in descending order based on count(m.id)
and selected production_company and count(m.id) column
Then in main query we have selected all columns from production_company_data cte and used rank() over() window to rank all the production house 
and then we have put limit 2 to get only top 2 production house
*/

-- The top 2 production house are Star Cinema and Twentieth Century Fox with movie count 7 and 4, respectively.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary
AS
  (
             SELECT     n.name,
                        Sum(r.total_votes)                                    AS 'total_votes',
                        Count(m.id)                                           AS 'movie_count',
                        Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS 'actress_avg_rating'
             FROM       names                                                 AS n
             INNER JOIN role_mapping                                          AS rm
             ON         n.id=rm.name_id
             INNER JOIN movie AS m
             ON         rm.movie_id=m.id
             INNER JOIN ratings AS r
             ON         m.id=r.movie_id
             INNER JOIN genre AS g
             ON         m.id=g.movie_id
             WHERE      rm.category='Actress'
             AND        r.avg_rating>8
             AND        g.genre='Drama'
             GROUP BY   n.name
             ORDER BY   Count(m.id) DESC )
  SELECT   *,
           rank() over(ORDER BY movie_count DESC) AS actress_rank
  FROM     actress_summary
  LIMIT    3;

/*
first we have created the cte named actress_summary where we have inner joined names, movie, role_mapping, ratings and genre 
Then in where clause and we have put category to be actress and rating to be greater than 8 and genre to be drama 
then we have grouped it my name and ordered by count(m.id) in descending order
and selected name, sum(total_votes), count(m.id) and used 
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2)  to get actress_avg_rating
Then in main query I have used rank() over() function to rank actrees based on movie_count and limited output to 3 to get top three actress
*/

-- the top three actress are Parvathy Thiruvothu, Susan Brown, Amanda Lawrence


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH next_date
AS
  (
             SELECT     d.name_id,
                        n.name,
                        m.id,
                        m.duration,
                        r.avg_rating,
                        r.total_votes,
                        m.date_published,
                        lead(m.date_published,1) over(partition BY d.name_id ORDER BY m.date_published,m.id) AS 'next_date_published'
             FROM       names                                                                                AS n
             INNER JOIN director_mapping                                                                     AS d
             ON         n.id=d.name_id
             INNER JOIN movie AS m
             ON         d.movie_id=m.id
             INNER JOIN ratings AS r
             ON         m.id=r.movie_id ),
  top_director
AS
  (
         SELECT *,
                Datediff(next_date_published, date_published) AS 'date_difference'
         FROM   next_date )
  SELECT   name_id                  AS 'director_id',
           name                     AS 'director_name',
           Count(id)                AS 'number_of_movies',
           Round(Avg(date_difference),2) AS 'avg_inter_movie_days',
           Round(avg(avg_rating),2) AS 'avg_rating',
           Sum(total_votes)         AS 'total_votes',
           Min(avg_rating)          AS 'min_rating',
           Max(avg_rating)          AS 'max_rating',
           Sum(duration)            AS 'total_duration'
  FROM     top_director
  GROUP BY name_id
  ORDER BY Count(id) DESC
  LIMIT    9;
/*
first we have created the cte named next_date where we have inner joined director_mapping, movie and ratings 
And I have selected name_id, name, id, duration, avg_rating, total_votes, date_published and then we have used lead() function to get the next_date_published 
then in top_director cte we have selected all the columns from next_date cte and then added a column date difference which contain the days between  next_date_published and date_published 
then in main query we have selected top_director cte and grouped it by name_id and ordered by count(id) in descending order and limited output to 9 records or rows to get top 9 director
*/

-- the top 9 directors are Andrew Jones, A.L. Vijay, Sion Sono, Chris Stokes, Sam Liu, Steven Soderbergh, Jesse V. Johnson, Justin Price, Özgür Bakar

-- in this file we have used sql formatter for indentation purpose