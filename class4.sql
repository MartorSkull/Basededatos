SELECT title, special_features FROM film WHERE rating="PG-13";

SELECT DISTINCT film.`length` 
	FROM film ORDER BY `length`;

SELECT  title, rental_rate, replacement_cost 
	FROM film 
		WHERE replacement_cost BETWEEN 20.0 AND 24.0;

SELECT film.title, film_category.category_id,film.rating
	FROM film, film_category, category
		WHERE special_features RLIKE 'Behind the Scenes' 
		AND film.film_id=film_category.film_id
		AND film_category.category_id=category.category_id;