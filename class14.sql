#1

SELECT CONCAT(last_name, ", ", first_name) as Name, address, city, country
FROM customer
	INNER JOIN address USING (address_id)
	INNER JOIN city USING (city_id)
	INNER JOIN country USING (country_id)
WHERE country = "Argentina";

#2

SELECT title, `language`.name, 
CASE rating
	WHEN "PG" THEN "Parental Guidance Suggested"
	WHEN "G" THEN "General Audiences"
	WHEN "NC-17" THEN "Adults Only"
	WHEN "PG-13" THEN "Parents Strongly Cautioned"
	WHEN "R" THEN "Restricted"
END
FROM film
	INNER JOIN `language`;

#3


SELECT title, release_year, last_name, first_name
FROM film
	INNER JOIN film_actor USING (film_id)
	INNER JOIN actor USING (actor_id)
WHERE last_name RLIKE UPPER((@inp:="penelope")) OR first_name RLIKE UPPER(@inp);

#4

SELECT title, CONCAT(last_name, ", ", first_name) AS name, 
CASE
	WHEN return_date IS NULL THEN "No"
	ELSE "Yes"
END AS returned, rental_date
FROM rental
	INNER JOIN customer USING (customer_id)
	INNER JOIN inventory USING (inventory_id)
	INNER JOIN film USING (film_id)
WHERE MONTH(rental_date) BETWEEN 5 AND 6 AND YEAR(rental_date) = 2017;

#5

#They both do the same thing, they convert some datatype A to other Datatype B
#Examples:
SELECT CAST(amount AS INT) FROM payment;

SELECT CONVERT(release_year, CHAR CHARACTER SET UTF8) FROM film;

#6

#This functions are used to set a default value incase a value is null to avoid errors.
#Only the IFNULL() and COALESCE() functions exist within mysql.

#this example will return all the unreturned films with a text that says not returned instead of 
#the default null
SELECT IFNULL(return_date, "not returned") from rental;

#This query will update all the non returned films and set the return_date to today
UPDATE rental
	SET return_date = COALESCE(return_date, NOW());