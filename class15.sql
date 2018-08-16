#1
CREATE OR REPLACE VIEW list_of_customers AS
	SELECT customer_id,
		CONCAT(c.last_name,", ",c.first_name) as Name, 
		address,
		postal_code,
		phone,
		city,
		country,
		CASE c.active
			WHEN 1 THEN "active"
			ELSE "inactive"
		END AS "status",
		store_id
	FROM customer c
		INNER JOIN address USING (address_id)
		INNER JOIN city USING (city_id)
		INNER JOIN country USING (country_id);
	
#2
CREATE OR REPLACE VIEW film_details AS
	SELECT film_id,  
		title, 
		description,  
		category.name as category,  
		rental_rate as price,  
		`length`,  
		rating, 
		GROUP_CONCAT(CONCAT(a.last_name," ",a.first_name) SEPARATOR ", ") as actors
	FROM film
		INNER JOIN film_actor USING (film_id)
		INNER JOIN actor a USING (actor_id)
		INNER JOIN film_category USING (film_id)
		INNER JOIN category USING (category_id)
	GROUP BY film.title;

#3
CREATE OR REPLACE VIEW sales_by_film_category AS
	SELECT category.name as category,
		SUM(payment.amount)
	FROM payment
		INNER JOIN rental USING (rental_id)
		INNER JOIN inventory USING (inventory_id)
		INNER JOIN film USING (film_id)
		INNER JOIN film_category USING (film_id)
		INNER JOIN category USING (category_id)
	GROUP BY category.name;
	
#4
CREATE OR REPLACE VIEW actor_information AS
	SELECT  actor.actor_id, first_name, last_name,
		COUNT(film_actor.film_id) as Films
	FROM actor
		INNER JOIN film_actor USING (actor_id)
	GROUP BY actor.actor_id;
	
#5
#we select id, firstname, lastname  del actor 
SELECT a.actor_id AS actor_id, a.first_name AS first_name, a.last_name AS last_name,
	# then we concatenate the category name and 
    group_concat(
    DISTINCT concat(
    	c.name, ': ', (
    	# the movies that have that category and the actor in it
    	SELECT group_concat(f.title ORDER BY f.title ASC separator ', ')
                FROM sakila.film f 
                # here we join the tables
                	JOIN sakila.film_category fc ON(f.film_id = fc.film_id)
                    JOIN sakila.film_actor fa ON(f.film_id = fa.film_id)
                #and check that the actor and the category are the saem
                WHERE fc.category_id = c.category_id
                    AND fa.actor_id = a.actor_id)
        )
    	ORDER BY c.name ASC SEPARATOR '; ') AS film_info 
    # we add all the tables
    FROM sakila.actor a
    	LEFT JOIN sakila.film_actor fa ON(a.actor_id = fa.actor_id)
        LEFT JOIN sakila.film_category fc ON(fa.film_id = fc.film_id)
    	LEFT JOIN sakila.category c ON(fc.category_id = c.category_id)
# group by actors so that we can group concat
GROUP BY a.actor_id, a.first_name, a.last_name

SELECT * FROM actor_info

#6
#Materialized views are views that write the result of the query they run in a temporary table.
#this allows the search to be quicker but if data changes and the view is not refreshed the data will
#be out of date. This is used for data that doesn't change and to take statistics of the day before. They exist in 
# Oracle - PostgreSQL - SQL Server - Apache Kafkaand and Apache Spark -  Sybase SQL - IBM DB2 - Microsoft SQL Server 