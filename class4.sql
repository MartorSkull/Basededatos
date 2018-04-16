USE sakila;
SELECT title, special_features FROM film WHERE rating="PG-13";

SELECT DISTINCT film.`length` 
	FROM film ORDER BY `length`;

SELECT  title, rental_rate, replacement_cost 
	FROM film 
		WHERE replacement_cost BETWEEN 20.0 AND 24.0;

SELECT film.title, category.name,film.rating
	FROM film, film_category, category
		WHERE special_features RLIKE 'Behind the Scenes' 
		AND film.film_id=film_category.film_id
		AND film_category.category_id = category.category_id;
		
SELECT a.first_name, a.last_name 
	FROM actor a, film_actor, film 
		WHERE film_actor.film_id = film.film_id
		AND film_actor.actor_id = a.actor_id
		AND film.title = 'ZOOLANDER FICTION';
		
SELECT address.address, city.city, country.country
	FROM address, city, country, store
		WHERE store.store_id = 1
		AND store.address_id = address.address_id
		AND city.city_id = address.city_id
		AND country.country_id = city.country_id;
		
SELECT f1.title, f1.rating, f2.title, f2.rating 
	FROM film f1, film f2
		WHERE f1.rating = f2.rating
		AND f1.film_id != f2.film_id;

SELECT film.title,  count(*) AS quantity, staff.first_name, staff.last_name
	FROM film, store, inventory, staff
		WHERE inventory.film_id = film.film_id
		AND inventory.store_id = 2
		AND store.store_id = 2
		AND store.manager_staff_id = staff.staff_id
	GROUP BY film.title;
