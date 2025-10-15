/*
Name: Michelle Galinsky
Student ID: 0399259
Submission Date: 2025-03-28
*/


USE mysql;

DROP DATABASE IF EXISTS
    mg_0399259_comp_e;

CREATE DATABASE IF NOT EXISTS
    mg_0399259_comp_e
    CHARSET='utf8mb4'
    COLLATE='utf8mb4_unicode_ci';

USE mg_0399259_comp_e;




DROP TABLE IF EXISTS company_people;

CREATE TABLE IF NOT EXISTS company_people (
    p_id          INT(11)      AUTO_INCREMENT,
    full_name     VARCHAR(100) NULL,
    email         VARCHAR(50)  NOT NULL UNIQUE,
    phone_number  VARCHAR(15)  NULL,
    date_of_birth DATE         NULL,
    date_joined   DATE         NOT NULL DEFAULT CURRENT_DATE,
    is_employee   BOOLEAN      NOT NULL DEFAULT TRUE,
    CONSTRAINT company_people_PK PRIMARY KEY (p_id),
    CONSTRAINT email_UK UNIQUE (email)
);


INSERT INTO company_people (full_name, email, phone_number, date_of_birth, date_joined, is_employee)
VALUES 
('Leslie Knope',  'leslie.knope@example.com',  '123-456-7890', '1975-01-18', '2014-09-01', TRUE),
('Jake Peralta',  'jake.peralta@example.com',  '987-654-3210', '1981-06-20', '2013-09-17', FALSE),
('Liz Lemon',     'liz.lemon@example.com',     '555-555-5555', '1970-10-14', '2006-10-11', FALSE),
('Jessica Day',   'jessica.day@example.com',   '444-444-4444', '1982-01-13', '2011-09-20', TRUE),
('Pam Beesly',    'pam.beesly@example.com',    '333-333-3333', '1979-03-25', '2005-03-24', FALSE);



DROP TABLE IF EXISTS employees;

CREATE TABLE IF NOT EXISTS employees (
    e_id       INT(11)     AUTO_INCREMENT,
    p_id       INT(11),
    job_title  VARCHAR(30) NOT NULL,
    department VARCHAR(50) NULL,
    salary     INT         NULL,
    CONSTRAINT employees_PK PRIMARY KEY (e_id),
    CONSTRAINT company_people_employees_FK FOREIGN KEY (p_id) REFERENCES company_people(p_id)
);


INSERT INTO employees (p_id, job_title, department, salary)
VALUES 
(1, 'Parks Director',         'Parks and Rec',   80000),
(2, 'Detective',              'Police',          95000),
(3, 'Head Writer',            'Media',           85000),
(4, 'School Teacher',         'Education',       65000),
(5, 'Receptionist',           'Office Admin',    40000);




DROP TABLE IF EXISTS customers;

CREATE TABLE IF NOT EXISTS customers (
    c_id              INT(11)  AUTO_INCREMENT,
    p_id              INT(11),
    loyalty_points    SMALLINT NULL,
    membership_status BOOLEAN  NOT NULL DEFAULT TRUE,
    CONSTRAINT customers_PK PRIMARY KEY (c_id),
    CONSTRAINT company_people_customers_FK FOREIGN KEY (p_id) REFERENCES company_people(p_id)
);


INSERT INTO customers (p_id, loyalty_points, membership_status)
VALUES 
(1, 100, FALSE),
(2, 200, TRUE),
(3, 150, TRUE),
(4, 50,  FALSE),
(5, 300, TRUE);



DROP TABLE IF EXISTS customer_destinations;

CREATE TABLE IF NOT EXISTS customer_destinations (
    destination_id INT(11)      AUTO_INCREMENT,
    c_id           INT(11),
    location       VARCHAR(100) NOT NULL,
    country        VARCHAR(100) NULL,
    visited        BOOLEAN      DEFAULT TRUE,
    rating         TINYINT,
    CONSTRAINT destinations_pk PRIMARY KEY(destination_id),
    CONSTRAINT c_id_FK FOREIGN KEY (c_id) REFERENCES customers(c_id)
);



INSERT INTO customer_destinations (c_id, location, country, visited, rating)
VALUES 
(1, 'Pawnee',            'USA',    TRUE,  5),
(2, 'Brooklyn',          'USA',    TRUE,  4),
(3, 'Rockefeller Plaza', 'USA',    FALSE, 3),
(4, 'Portland',          'USA',    FALSE, 4),
(5, 'Paris',             'France', FALSE, 5);


/*
Write (at least) 5 SELECT statements that retrieve data from your database.
You must include (at least) 1 of each of the following types of JOIN clauses:
INNER
LEFT
RIGHT
Two (or more) chained JOINs for data “further away”.
Each SELECT statement should have a comment explaining what it’s fetching.
 */


/*** The following are the 5 SELECT statements ***/
-- Num1
SELECT e.e_id AS 'ID', cp.full_name AS 'Name'
FROM employees e
INNER JOIN company_people cp ON e.p_id = cp.p_id;

-- Num2
SELECT cp.full_name AS 'Name', e.job_title AS 'Job', cd.location AS 'Location'
FROM company_people cp
JOIN employees e ON cp.p_id = e.p_id
JOIN customers c ON e.p_id = c.p_id
JOIN customer_destinations cd ON c.c_id = cd.c_id
ORDER BY cp.full_name ASC;

-- Num3
SELECT c.membership_status AS 'Membership', cd.location AS 'Destination', cd.rating AS 'Rating'
FROM customers c
LEFT JOIN customer_destinations cd ON c.c_id = cd.c_id
WHERE cd.rating = 5 OR cd.rating = 4 AND cd.visited = TRUE;


-- Num4
SELECT cp.full_name AS 'Name', cp.is_employee 'Employee Status', c.membership_status 'Membership Status'
FROM company_people cp
RIGHT JOIN customers c ON cp.p_id = c.p_id
WHERE cp.is_employee = FALSE AND c.membership_status = TRUE;

-- Num5
SELECT cp.full_name AS 'Name', e.job_title AS 'Job Title', c.loyalty_points AS 'Points', cd.location AS 'Destination'
FROM company_people cp
RIGHT JOIN employees e ON cp.p_id = e.p_id
LEFT JOIN customers c ON e.p_id = c.p_id
JOIN customer_destinations cd ON c.c_id = cd.c_id
WHERE c.loyalty_points >= 150
ORDER BY c.loyalty_points DESC;




