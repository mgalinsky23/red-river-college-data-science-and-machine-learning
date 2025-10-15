/*
Name: Michelle Galinsky
Student ID: 0399259
*/

-- This command can be used to create the boxstore database. 
-- We begin by first connecting to an arbitrary database to prevent 
-- disconnection errors. Then we drop the database in its entirety,
-- and fully recreate it afterwards. Then, finally, we connect to this 
-- database for further operations.
USE mysql;

DROP DATABASE IF EXISTS
    mg_0399259_comp_d;

CREATE DATABASE IF NOT EXISTS
    mg_0399259_comp_d
    CHARSET='utf8mb4'
    COLLATE='utf8mb4_unicode_ci';

USE mg_0399259_comp_d;



-- We first drop the table to ensure not complications arise if a table 
-- with that name exists. Then, create a table by name 'destinations' with 5 columns.
-- This table values destination_id which tracks the id values for each destination by
-- using AUTO_INCREMENT, it automatically assigns a value to each destination
-- location and country are both 100-max-length strings. visited is a boolean which
-- tracks whether the person has visted the location by assigning a TRUE or FALSE.
-- Lastly rating is an int for tracking the rating given to a location.
-- Finally, we define 'destination_id' as the primary key of the table.
-- This ensures each row in the table has a unique and non-null identifier.
DROP TABLE IF EXISTS destinations;

CREATE TABLE IF NOT EXISTS destinations (
    destination_id INT(11) AUTO_INCREMENT,
    location VARCHAR(100) NOT NULL,
    country VARCHAR(100) NULL,
    visited BOOLEAN,
    rating TINYINT,
    CONSTRAINT destinations_pk PRIMARY KEY(destination_id)
);


-- After creating the table 'destinations', we then insert values into it using INSERT_INTO
-- and specifying the table and the parameters we choose to insert.
INSERT INTO destinations (location, country, visited, rating)
VALUES ('New York', 'USA', TRUE, 7),
       ('Toronto', 'Canada', TRUE, 9),
       ('London', 'England', FALSE, 10),
       ('Barcelona', 'Spain', TRUE, 8),
       ('Paris', 'France', FALSE, 6);

/*** The following is the 10 SELECT statements ***/
-- Num1
SELECT location
FROM destinations
WHERE visited = TRUE
ORDER BY visited ASC;

-- Num2
SELECT rating
FROM destinations
WHERE rating > 8
ORDER BY rating DESC;

-- Num3
SELECT country
FROM destinations
WHERE country = 'USA'
ORDER BY country ASC;

-- Num4
SELECT location
FROM destinations
WHERE visited = False
ORDER BY country ASC;

-- Num5
SELECT location
FROM destinations
WHERE visited = TRUE AND rating <= 9
ORDER BY rating DESC;

-- Num6
SELECT location, country
FROM destinations
WHERE location LIKE 'n%' OR rating != 8
ORDER BY rating DESC
LIMIT 2;

-- Num7
SELECT location, rating AS 'rating out of 10'
FROM destinations
WHERE country IN ('England', 'Canada')
ORDER BY country DESC;

-- Num8
SELECT country
FROM destinations
WHERE rating BETWEEN 5 AND 8
ORDER BY rating ASC;

-- Num9
SELECT location
FROM destinations
WHERE visited = TRUE 
ORDER BY country AND rating DESC;

-- Num10
SELECT location
FROM destinations
WHERE location LIKE 'r%' OR rating <= 7
ORDER BY rating ASC;


-- Here we alter the table by adding a new column called 'year'
ALTER TABLE destinations
    ADD COLUMN year INT NULL;

-- We update the table indicating spicifically what we want to update
-- In this case, where the country is Canada, we change the location to 'Banff',
-- and the year to 2021.
UPDATE destinations
SET location = 'Banff', year = 2021
WHERE country = 'Canada';

-- In this UPDATE statement, we change the name of the location to 'Washington', year
-- to 2019, and rating to 8 when the country is USA.
UPDATE destinations
SET location = 'Washington', year = 2019, rating = 8
WHERE country = 'USA';

-- Lastly, we call all the columns of the destinations table using SELECT *
-- and indicating we want the table to be 'destinations'
SELECT * FROM destinations;



























