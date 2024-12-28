## Normalisation and
## CTE queries
## Assignment Questions

## Q1 - U First Normal Form (1NF)>
## Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NFa

## ans. actor_award table of sakila DB voilates the rule of 1NF
## according to 1NF rule every coloumn have a atomic value but in actor_award table there are multiple values in 
## award coloumn for normalize in 1NF we have to creat a new table for awards coloumn.


## Q no. (2) - Second Normal Form (2NF)>
## Choose a table in Sakila DB and describe how you would determine whether it is in 2NF. If it violates 2NF,
## explain the steps to normalize it

## Ans -
select * from film 
## film table from sakila database violates 2nf because of the special features coloumn, special feature column on the 
## table violate 1NF and 2NF has a rule that table is in 1Nf
## identify partial dependencies all the non-prime attributes like
## title discription, release_year etc are fully dependent on the primary key
## which is film_id, we can create a another table and make them columns 
## foreign keys and these foreign keys make reference to that film_id table
## by using these steps we can avoid 2NF


## 3 Identify a table in Sakila that violates 3NF Describe the transitive dependencies present and outline the 
-- steps to normalize the table to 3NF

-- ans - 
-- if we saw the customer table in the sakila database we get to know that the column name address_id is linked with store_id
-- and both are non key attribute and 3NF says that table is in 2NF from and it ensure that all the non key attribute column on the
-- table are not related with each other (one non key attribute column related to other non key attribute column) so because of that violate 2 and 3 NF

-- STEIPS TO PREVENT 3NF --
-- 1. analyse the violation, 2. create new table to store date
-- 3. update customer table (make store id as foreign key)
-- 4. upadate address info ( so it reference to the foreign key)


## 4. Take a specific table in sakila and guide through the process of normalizing it from the initial
-- unnormalized form up to at least 2NF

-- ans --
-- In this database "film" table semms like unnomalize form so we discuss the normalization process up to 2NF
-- This table may not be in 1st normal form because it has repeating groups (like special_features)
-- and multiple values in a single column, to normalize it, we can follow these steps

-- Step 1: 
-- Identify the Primary key
-- The film_id column seems suitbale as the primary key for the film table.

-- Step 2:
-- Eliminate Repeating Groups --
-- The special features column contains multiple values, violating 1NF. We can create a new table for special features.

-- Step 3:
-- Eliminate Partial Dependencies --
-- Now, let's check for partial dependencies. If there are any,We need to create separate tables for those.

-- In this case, it seems like language_id and original_language_id are partially dependent on film_id. We can create a new table for languages

-- Step 3:
-- Ensure No Transitive Dependencies __
-- Now, let's check for transitive dependencies, if any are found. create separate tables for those

-- In this example, there are no apparent transitive dependencies. The table is now in 2nd Normal For 2NF.

## 5. 5 Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have 
-- acted in from the "actor"  and "film_actor tables"

-- Ans --
WITH ActorFilm_Counts AS (
    SELECT 
        a.actor_id, 
        CONCAT(a.first_name, ' ', a.last_name) AS full_name, 
        COUNT(fa.film_id) AS film_count
    FROM 
        actor a
    JOIN 
        film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY 
        a.actor_id, 
        a.first_name, 
        a.last_name
)
SELECT 
    full_name, 
    film_count
FROM 
    ActorFilmCounts
ORDER BY 
    film_count DESC;


## 6. Recursive CTE>
-- Use a recursive CTE to generate a hierarchical list of categories and their subcategories from the
-- table in Sakila DB

-- Ans --
WITH RECURSIVE CategoryHierarchy AS (
    SELECT 
        c.category_id, 
        c.name, 
        CAST(AS TEXT) AS parent_path, 
        0 AS depth
    FROM 
        category c
    WHERE 
        c.parent_id IS NULL
    UNION ALL
    SELECT 
        c.category_id, 
        c.name, 
        CONCAT(ch.parent_path, '/', c.name), 
        ch.depth + 1
    FROM 
        category c
    JOIN 
        CategoryHierarchy ch ON c.parent_id = ch.category_id
)
SELECT 
    category_id, 
    name, 
    parent_path, 
    depth
FROM 
    CategoryHierarchy
ORDER BY 
    parent_path;
    
    
    
## 7. CTE with Joins>
-- Create a CTE that combines information from the and tables to display the film title, language
-- name, and rental ratea
    
 -- Ans --
WITH FilmLanguage AS (
    SELECT 
        f.title, 
        l.name AS language_name, 
        f.rental_rate
    FROM 
        film f
    JOIN 
        language l ON f.language_id = l.language_id
)
SELECT * FROM FilmLanguage;


## 8. CTE for Aggregation>
-- Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer
--  and payment tables.

-- Ans --
WITH CustomerRevenue AS (
    SELECT 
        c.customer_id, 
        c.first_name, 
        c.last_name, 
        SUM(p.amount) AS total_revenue
    FROM 
        customer c
    JOIN 
        rental r ON c.customer_id = r.customer_id
    JOIN 
        payment p ON r.rental_id = p.rental_id
    GROUP BY 
        c.customer_id, 
        c.first_name, 
        c.last_name
)
SELECT * FROM CustomerRevenue;


## 9. CTE with Window Functions>
-- Utilize a CTE with a window function to rank films based on their rental duration from the film table

-- ans -- 
WITH FilmRentalDuration AS (
    SELECT 
        film_id, 
        title, 
        rental_duration, 
        DENSE_RANK() OVER (ORDER BY rental_duration DESC) AS rental_rank
    FROM 
        film
)
SELECT * FROM FilmRentalDuration;


## 10.CTE and Filtering>
-- Create a CTE to list customers who have made more than two rentals, and then join this CTE with the CUSTOMER
-- table to retrieve additional customer details

-- Ans --
WITH FrequentRenters AS (
    SELECT 
        customer_id
    FROM 
        rental
    GROUP BY 
        customer_id
    HAVING 
        COUNT(*) > 2
)
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.email, 
    c.address 
FROM 
    customer c
JOIN 
    FrequentRenters fr ON c.customer_id = fr.customer_id;


## 11. CTE for Date Calculations>
-- Write a query using a CTE to find the total number of rentals made each month, considering the
-- rental_date from the rental table.

-- Ans --

with Monthly_rentals as(

SELECT date_format(rental_date,"%y-%m") as rental_month,
  count(rental_id) as total_rental 
  from rental GROUP BY rental_month ) 
  SELECT rental_month ,total_rental 
  FROM Monthly_rentals 
  ORDER BY rental_month ;


## 12. CTE for Pivot Operations>
-- Use a CTE to pivot the data from the payment table to display the total payments made by each customer in
-- separate columns for different payment methods.

-- Ans --

-- In this mavenmovies database there is no any column name as payments mothod so 
-- we use amount in the place of payments method

with customer_payments as( select c.customer_id , 
sum(p.amount) as payment_amount 
from payment p join customer c on c.customer_id = p. customer_id 
group by customer_id ) select customer_id , payment_amount from customer_payments 
ORDER BY customer_id


## 13. CTE and Self-Join>
-- Create a CTE to generate a report showing pairs of actors who have appeared in the same film together,
-- using the film_actor table

-- Ans --

WITH ActorPairs AS(
    SELECT 
        fa1.actor_id AS actor1_id, 
        fa2.actor_id AS actor2_id
    FROM 
        film_actor fa1
    JOIN 
        film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT 
    a1.first_name || ' ' || a1.last_name AS actor1, 
    a2.first_name || ' ' || a2.last_name AS actor2
FROM 
    ActorPairs ap
JOIN 
    actor a1 ON ap.actor1_id = a1.actor_id
JOIN 
    actor a2 ON ap.actor2_id = a2.actor_id;


## 14. CTE for Recursive Search>
-- Implement a recursive CTE to find all employees in the staff table who report to a specific manager,
-- considering the reports_to column.

-- Ans -- 
-- The reports_to column is not available in sakila database
