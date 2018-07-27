
#1 Add a new customer
INSERT INTO sakila.customer
(store_id, first_name, last_name, address_id, create_date)
SELECT 1, 'Juan Domingo', 'Peron', address_id, CURRENT_DATE() 
FROM address 
	INNER JOIN city USING (city_id)
	INNER JOIN country USING (country_id)
WHERE country.country = "United States"
ORDER BY address_id DESC
LIMIT 1;

#2 Add a rental
INSERT INTO sakila.rental
(rental_date, inventory_id, customer_id, staff_id)
VALUES(
	CURRENT_DATE(), 
	(SELECT inventory_id FROM inventory INNER JOIN film USING (film_id) WHERE title = "RUNNER MADIGAN" LIMIT 1),
	(SELECT customer_id FROM customer WHERE store_id = 2 LIMIT 1),
	(SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1));

#3 Update film year based on the rating
UPDATE film
SET release_year = CASE
	WHEN rating = 'PG' THEN 2001
	WHEN rating = 'G'  THEN 2002
	WHEN rating = 'NC-17' THEN 2003
	WHEN rating = 'PG-13' THEN 2004
	WHEN rating = 'R' THEN 2005
	END
	
#4 Return a film
UPDATE rental 
SET return_date = CURRENT_DATE()
WHERE rental_id = 16050

UPDATE payment
SET amount = amount+1
payment_date = CURRENT_DATE()
WHERE rental_id = 16050;
	
SELECT rental_id FROM rental WHERE return_date IS NULL

#5 Try to delete a film

DELETE FROM film WHERE film_id = 1;

# When we try to remove films the constraint checks are run to avoid data 
# inconcistencies thus not allowing us to remove the desired film
# to achieve this we must remove any related rows and repeat this any time a 
# constraint error apears.

DELETE payment 
FROM rental 
	INNER JOIN payment USING (rental_id)
	INNER JOIN inventory USING (inventory_id)
WHERE film_id = 1;

DELETE rental 
FROM rental
	INNER JOIN inventory USING (inventory_id)
WHERE film_id = 1;

DELETE inventory
FROM inventory
WHERE film_id = 1;

DELETE film_actor
FROM film_actor
WHERE film_id = 1;

DELETE film_category
FROM film_category
WHERE film_id = 1;

DELETE film
FROM film
WHERE film_id = 1;


# 6 Rent a film
SELECT inventory_id, film_id
FROM inventory
WHERE inventory_id NOT IN (SELECT inventory_id
FROM inventory
	INNER JOIN rental USING (inventory_id)
	WHERE return_date IS NULL)

# ii 10
# fi 2
	
INSERT INTO sakila.rental
(rental_date, inventory_id, customer_id, staff_id)
VALUES(
CURRENT_DATE(),
10,
(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
(SELECT staff_id FROM staff WHERE store_id = (SELECT store_id FROM inventory WHERE inventory_id = 10))
);

INSERT INTO sakila.payment
(customer_id, staff_id, rental_id, amount, payment_date)
VALUES(
(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
(SELECT staff_id FROM staff LIMIT 1),
(SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1) ,
(SELECT rental_rate FROM film WHERE film_id = 2),
CURRENT_DATE());
