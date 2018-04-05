DROP DATABASE IF EXISTS imdb;
CREATE DATABASE imdb;

USE imdb;

CREATE TABLE film (
	film_id INT PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(20) NOT NULL,
	description TEXT,
	release_year YEAR
);

CREATE TABLE actor (
	actor_id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL
);

CREATE TABLE film_actor (
	actor_id INT NOT NULL,
	film_id INT NOT NULL,
	CONSTRAINT actor_fk FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE NO ACTION,
	CONSTRAINT film_fk FOREIGN KEY (film_id) REFERENCES film(film_id) ON DELETE NO ACTION
);

INSERT INTO film (title, description, release_year) VALUES 
("Ready Player One", "A kid a laptop a game", "2018"),
("Hola soy Simon", "Simon", "2018"),
("Amari", "Dulce", "2003");

INSERT INTO actor (first_name, last_name) VALUES
("ROBBIE", "williams"),
("robert", "deniro"),
("totoro", "tonari"),
("Javier","Guignard");

INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 2),
(4, 1),
(3, 3),
(1, 1),
(1, 3);
