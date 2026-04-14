USE sakila;

-- 3. 
SELECT *
FROM CUSTOMER 
WHERE customer_id NOT IN (SELECT customer_id
FROM PAYMENT);     -- 3.

 -- 4.
SELECT *
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate)
					 FROM film);    -- 4.

-- 8.
SELECT title, rental_duration
FROM film
WHERE rental_duration > (SELECT AVG(rental_duration)
						 FROM film);                  -- 8.
                         
-- 9.
SELECT * 
FROM CUSTOMER
WHERE address_id = (SELECT address_id
                 FROM CUSTOMER
                 WHERE customer_id = 1);     -- 9.
                 
-- 10.
SELECT *
FROM payment
WHERE amount > (SELECT AVG(amount)
                FROM PAYMENT);           -- 10.

-- 1. 
WITH details_customer AS ( SELECT customer_id, 
						   COUNT(*) AS no_payments
                           FROM payment
                           GROUP BY customer_id)
SELECT * 
FROM customer
WHERE customer_id IN (SELECT customer_id
					  FROM details_customer
                      WHERE no_payments > 5);
                      

-- 2. 

WITH actor_names AS ( SELECT actor_id, count(*) AS film_count
                      FROM film_actor
                      GROUP BY actor_id)
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id
                   FROM actor_names
                   WHERE film_count > 10);
                   
                   
-- 6.
WITH customers_rented AS ( SELECT DISTINCT MONTH(rental_date)  
						   AS rental_month
                           FROM rental
                           WHERE customer_id = 5)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id
					  FROM rental
                      WHERE MONTH(rental_date) IN (SELECT rental_month
												   FROM customers_rented);
                                                   
												
-- 5. 
CREATE TEMPORARY TABLE films_rented AS 
SELECT  DISTINCT film_id 
FROM inventory
WHERE inventory_id IN (SELECT inventory_id
                       FROM rental);
SELECT title 
FROM film
WHERE film_id NOT IN (SELECT film_id
					  FROM films_rented);
                      
DROP TEMPORARY TABLE films_rented;


-- 7. 

CREATE VIEW avg_amount AS
SELECT AVG(amount) AS avg_amt
FROM payment;
SELECT s. first_name, s. last_name
FROM staff s
WHERE s. staff_id IN ( SELECT staff_id
					   FROM payment
                       WHERE amount > (SELECT avg_amt
                                       FROM avg_amount));
                      
