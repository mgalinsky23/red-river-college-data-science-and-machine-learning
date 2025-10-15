/*
Name: Michelle Galinsky
Student ID: 0399259
Submission Date: 2025-03-28
*/

-- Drop the database if it exists
DROP DATABASE IF EXISTS mg_0399259_comp_e;

-- Create a new database
CREATE DATABASE mg_0399259_comp_e
    WITH ENCODING 'UTF8'
    LC_COLLATE='en_US.UTF-8'
    LC_CTYPE='en_US.UTF-8'
    TEMPLATE template0;


-- Drop the tables if exists
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customer_destinations;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS company_people;

-- Create the company_people table
CREATE TABLE company_people (
    p_id          SERIAL      PRIMARY KEY,
    full_name     VARCHAR(100),
    email         VARCHAR(50) NOT NULL UNIQUE,
    phone_number  VARCHAR(15),
    date_of_birth DATE,
    date_joined   DATE        NOT NULL DEFAULT CURRENT_DATE,
    is_employee   BOOLEAN     NOT NULL DEFAULT TRUE
);

-- Insert values into company_people
INSERT INTO company_people (full_name, email, phone_number, date_of_birth, date_joined, is_employee)
VALUES 
('Leslie Knope',  'leslie.knope@example.com',  '123-456-7890', '1975-01-18', '2014-09-01', TRUE),
('Jake Peralta',  'jake.peralta@example.com',  '987-654-3210', '1981-06-20', '2013-09-17', FALSE),
('Liz Lemon',     'liz.lemon@example.com',     '555-555-5555', '1970-10-14', '2006-10-11', FALSE),
('Jessica Day',   'jessica.day@example.com',   '444-444-4444', '1982-01-13', '2011-09-20', TRUE),
('Pam Beesly',    'pam.beesly@example.com',    '333-333-3333', '1979-03-25', '2005-03-24', FALSE);



-- Create the employees table
CREATE TABLE employees (
    e_id       SERIAL      PRIMARY KEY,
    p_id       INT         REFERENCES company_people(p_id),
    job_title  VARCHAR(30) NOT NULL,
    department VARCHAR(50),
    salary     INT
);

-- Insert values into employees
INSERT INTO employees (p_id, job_title, department, salary)
VALUES 
(1, 'Parks Director', 'Parks and Rec',   80000),
(2, 'Detective',      'Police',          95000),
(3, 'Head Writer',    'Media',           85000),
(4, 'School Teacher', 'Education',       65000),
(5, 'Receptionist',   'Office Admin',    40000);



-- Create the customers table
CREATE TABLE customers (
    c_id              SERIAL  PRIMARY KEY,
    p_id              INT     REFERENCES company_people(p_id),
    loyalty_points    SMALLINT,
    membership_status BOOLEAN NOT NULL DEFAULT TRUE
);

-- Insert values into customers
INSERT INTO customers (p_id, loyalty_points, membership_status)
VALUES 
(1, NULL, FALSE),
(2, 200,  TRUE),
(3, 150,  TRUE),
(4, NULL, FALSE),
(5, 300,  TRUE);



-- Create the customer_destinations table
CREATE TABLE customer_destinations (
    destination_id SERIAL       PRIMARY KEY,
    c_id           INT          REFERENCES customers(c_id),
    location       VARCHAR(100) NOT NULL,
    country        VARCHAR(100),
    visited        BOOLEAN      DEFAULT TRUE,
    rating         SMALLINT
);

-- Insert values into customer_destinations
INSERT INTO customer_destinations (c_id, location, country, visited, rating)
VALUES 
(1, 'Pawnee',            'USA',    TRUE,  5),
(2, 'Brooklyn',          'USA',    TRUE,  4),
(3, 'Rockefeller Plaza', 'USA',    FALSE, 3),
(4, 'Portland',          'USA',    FALSE, 4),
(5, 'Paris',             'France', FALSE, 5);



/*** The following are the 5 SELECT statements ***/
-- Num1: Fetching the ID of the employees in the employees table, and their names from the company_people table.
SELECT e.e_id AS "ID", cp.full_name AS "Name"
FROM employees e
INNER JOIN company_people cp ON e.p_id = cp.p_id;

-- Num2: Fetching The names of the people in the company_people table, their job titles from the employees table, 
-- and, the locations associated with them in the customer_destinations table.
SELECT cp.full_name AS "Name", e.job_title AS "Job", cd.location AS "Location"
FROM company_people cp
JOIN employees e ON cp.p_id = e.p_id
JOIN customers c ON e.p_id = c.p_id
JOIN customer_destinations cd ON c.c_id = cd.c_id
ORDER BY cp.full_name ASC;

-- Num3: Fetching the membership status (True or False) from the customers table, the locations from the customer_destinations
-- table, and the rating given for each location from the customer_destinations table as well.
SELECT c.membership_status AS "Membership", cd.location AS "Destination", cd.rating AS "Rating"
FROM customers c
LEFT JOIN customer_destinations cd ON c.c_id = cd.c_id
WHERE (cd.rating = 5 OR cd.rating = 4) AND cd.visited = TRUE;


-- Num4: Fetching names of the people from the company_people table, the employee status (True or False) from this table too,
-- and the membership status (True or False) from the customers table.
SELECT cp.full_name AS "Name", cp.is_employee "Employee Status", c.membership_status "Membership Status"
FROM company_people cp
RIGHT JOIN customers c ON cp.p_id = c.p_id
WHERE cp.is_employee = FALSE AND c.membership_status = TRUE;

-- Num5: Fetching the names of the people in the company_people table, their job titles from the employees table, the number of 
-- loyalty points they have, and the destination they have listed on their account.
SELECT cp.full_name AS "Name", e.job_title AS "Job Title", c.loyalty_points AS "Points", cd.location AS "Destination"
FROM company_people cp
RIGHT JOIN employees e ON cp.p_id = e.p_id
LEFT JOIN customers c ON e.p_id = c.p_id
JOIN customer_destinations cd ON c.c_id = cd.c_id
WHERE c.loyalty_points >= 150
ORDER BY c.loyalty_points DESC;





