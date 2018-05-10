USE sakila;

#1
SELECT first_name, last_name 
	FROM actor a1 
		WHERE EXISTS(
			SELECT * 
				FROM actor a2 
					WHERE a1.last_name = a2.last_name 
					AND a1.actor_id <> a2.actor_id)
		ORDER by last_name;

#2

#DELETE FROM film_actor WHERE actor_id=148;

SELECT first_name ,last_name
	FROM actor a1 
		WHERE a1.actor_id NOT IN (
			SELECT DISTINCT fa.actor_id 
				FROM film_actor fa);
			

#3
SELECT c.customer_id, c.first_name, c.last_name
	FROM customer c, rental r1
		WHERE r1.customer_id = c.customer_id
		AND NOT EXISTS (
			SELECT * 
				FROM rental r2 
					WHERE r2.customer_id = r1.customer_id
					AND r1.rental_id <> r2.rental_id);
					
#4
SELECT c.customer_id, c.first_name, c.last_name
	FROM customer c, rental r1
		WHERE r1.customer_id = c.customer_id
		AND EXISTS (
			SELECT * 
				FROM rental r2 
					WHERE r2.customer_id = r1.customer_id
					AND r1.rental_id <> r2.rental_id)
	GROUP BY customer_id;

#5
SELECT a.actor_id, a.first_name, a.last_name
	FROM actor a
		WHERE EXISTS(
		SELECT * 
			FROM film_actor fa, film f 
				WHERE fa.actor_id = a.actor_id
				AND f.film_id = fa.film_id
				AND f.title IN ( 'BETRAYED REAR','CATCH AMISTAD'));

 -- OR --

SELECT DISTINCT actor.actor_id, first_name, last_name
FROM film_actor, actor, film
	WHERE actor.actor_id = film_actor.actor_id
	  AND film.film_id = film_actor.film_id
	  AND title IN ('BETRAYED REAR', 'CATCH AMISTAD')

#6
SELECT a.actor_id, a.first_name, a.last_name
	FROM actor a
		WHERE EXISTS(SELECT * 
					 FROM film_actor fa, film f 
							WHERE fa.actor_id = a.actor_id
							  AND f.film_id = fa.film_id
							  AND f.title = 'BETRAYED REAR')
		  AND NOT EXISTS(SELECT * 
					 FROM film_actor fa, film f 
							WHERE fa.actor_id = a.actor_id
							  AND f.film_id = fa.film_id
							  AND f.title = 'CATCH AMISTAD');
#7
SELECT a.actor_id, a.first_name, a.last_name
	FROM actor a
		WHERE EXISTS(
		SELECT * 
			FROM film_actor fa, film f 
				WHERE fa.actor_id = a.actor_id
				AND f.film_id = fa.film_id
				AND f.title = 'BETRAYED REAR')
		AND NOT EXISTS (		
		SELECT * 
			FROM film_actor fa, film f 
				WHERE fa.actor_id = a.actor_id
				AND f.film_id = fa.film_id
				AND f.title = 'CATCH AMISTAD');
#8
SELECT a.actor_id, a.first_name, a.last_name
	FROM actor a
		WHERE NOT EXISTS(
		SELECT * 
			FROM film_actor fa, film f 
				WHERE fa.actor_id = a.actor_id
				AND f.film_id = fa.film_id
				AND f.title IN ( 'BETRAYED REAR','CATCH AMISTAD'));
