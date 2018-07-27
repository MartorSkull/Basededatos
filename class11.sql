#1 
SELECT country.country, count(*) as cities
FROM country INNER JOIN city USING (country_id)
GROUP BY country.country_id
ORDER BY 2;

#2
SELECT country.country, count(*) as cities
FROM country INNER JOIN city USING (country_id)
GROUP BY country.country_id
HAVING cities > 10
ORDER BY 2 DESC;

#3
SELECT CONCAT(customer.last_name, " ", customer.first_name) as name, address.address, COUNT(*) as rented, SUM(payment.amount) as payed
FROM customer 
	INNER JOIN address USING (address_id)
	INNER JOIN rental USING (customer_id)
	INNER JOIN payment USING (rental_id)
GROUP BY customer.customer_id
ORDER BY payed DESC;

#4
SELECT DISTINCT film.title
FROM film LEFT JOIN inventory USING (film_id)
	WHERE inventory.inventory_id IS NULL;
	
#5
SELECT film.title, inventory_id
FROM film 
	INNER JOIN inventory USING (film_id)
	LEFT JOIN rental USING (inventory_id)
WHERE rental_id IS NULL;
	
#6
SELECT CONCAT(c.last_name, " ",c.first_name) as name, c.store_id, film.title, rental.rental_date, rental.return_date
FROM rental 
	INNER JOIN customer c USING (customer_id)
	INNER JOIN inventory USING (inventory_id)
	INNER JOIN film USING (film_id)
WHERE return_date IS NOT NULL
ORDER BY store_id, c.last_name;


