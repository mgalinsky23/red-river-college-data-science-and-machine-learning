/*
*	Name: Michelle Galinsky
*	Student ID: 0399259
*	Updates: 2025-01-13: Create file. Add "CREATE DATABASE" command
*			 2025-01-14: Added syntax for dropping database first
*			 2025-01-24: Added content for Competency B 
*						 -> data about MariaDB and basic database navigation
*						 -> lessons 1-2 and DEFINITIONS section
*			 2025-01-30: Started Competency C 
*						 -> added lessons 3-5
*			 2025-02-06: Added lesson 6 with the changes implemented to the 
*						 boxstore file and the examples deleted from the file
*			 2025-02-12: Started Competency D
*						 -> Added lesson 7 with changes to the boxstore added
*						 -> Details on how to import files into the database added below 
*							the data about MariaDB and basic database navigation
*			 2025-03-13: Started Competency E
*						 -> Added lesson 8 with updated boxstore and JOIN Query practice
*						 -> Added notes on JOIN clauses before the practice and within lesson 8
*/



/* Document MySQL/MariaDB Version */
-- MariaDB version: 11.6.2

/* Paths */ 
-- Path to bin directory: C:\Program Files\MariaDB 11.6.2\bin 
-- Path to data directory: C:\Program Files\MariaDB 11.6.2\data 
-- Path to my.ini: C:\Program Files\MariaDB 11.6.2\data\my.ini

/* Research how to restart MariaDB */ 
-- Restart command: net stop MariaDB && net start MariaDB

/* Starting MySQL in Command Prompt */ 
-- Command: mysql -u root -p
-- Sample response from terminal: 
-- Welcome to the MariaDB monitor.  Commands end with ; or \g.
-- Your MariaDB connection id is 6
-- Server version: 11.6.2-MariaDB mariadb.org binary distribution


/*************************************/
-- HOW TO IMPORT FILES INTO A DATABASE:
/*************************************/
/*
1. Open DBeaver
2. Connect to Your Database
3. Open the Target Database
4. Open the File
5. Import Data from Other File Formats
	Right-click on the target table or database in the Database Navigator.
	Select "Import Data".
	In the wizard, choose the file format (e.g., CSV, XLSX).
	Click "Next".
6. Select the File
7. Map the Columns
	Ensure the columns in the file are correctly mapped to the columns in the target database table.
8. Preview the Data
	Review the data to ensure everything is correctly mapped.
	Click "Next".
9. Execute the Import:
	Click "Finish" to start the import process.
	DBeaver will show a progress bar and any potential errors.
	
-- ANOTHER WAY TO IMPORT DIRECTLY INTO A FILE/COLUMN:
-- Load data from a CSV file into a table, specifying field and line delimiters and skipping the first line.
LOAD DATA LOCAL INFILE 'path_to_your_file.csv'
INTO TABLE your_table_name
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES -- or could be IGNORE 1 ROWS
(column_name);
*/


/********** Lesson 8: **********/
-- FULL UPDATED BOXSTORE:
/************************** START: **************************/
/*
Name: Michelle Galinsky
Updates:
	2025-01-15: Created file
				Added CREATE DATABASE command
	2025-02-06: Added DROP CREATE TABLE 'people' command
	            Added multiple columns and rows into the table
	            And inserted instructor and myself
	2025-02-12: Added ALTER TABLE and UPDATE TABLE
	2025-03-06: Created 4 tables: geo_address_type, geo_country, geo_region, geo_towncity
	            Added values to each table
*/

USE mysql;

DROP DATABASE IF EXISTS
	mg_0399259_boxstore;

CREATE DATABASE IF NOT EXISTS
	mg_0399259_boxstore
	CHARSET='utf8mb4'
	COLLATE='utf8mb4_unicode_ci';

USE mg_0399259_boxstore;



DROP TABLE IF EXISTS geo_address_type;
CREATE TABLE IF NOT EXISTS geo_address_type (
    addr_type_id TINYINT     AUTO_INCREMENT,
    addr_type    VARCHAR(15) NOT NULL,
    active       BIT         NOT NULL DEFAULT 1,
    CONSTRAINT gat_PK PRIMARY KEY (addr_type_id),
    CONSTRAINT gat_UK UNIQUE (addr_type)
);

INSERT INTO geo_address_type (addr_type)
VALUES ('Apartment'),
       ('Building'),
       ('Condominium'),
       ('Head Office'),
       ('Townhouse'),
       ('Warehouse'),
       ('Other');


DROP TABLE IF EXISTS geo_country;
CREATE TABLE IF NOT EXISTS geo_country (
    co_id   TINYINT     AUTO_INCREMENT,
    co_name VARCHAR(60) NOT NULL,
    co_abbr CHAR(2)     NOT NULL,
    active  BIT         NOT NULL DEFAULT 1,
    CONSTRAINT gco_PK PRIMARY KEY (co_id),
    CONSTRAINT gco_UK_name UNIQUE (co_name),
    CONSTRAINT gco_UK_abbr UNIQUE (co_abbr)
);

INSERT INTO geo_country (co_name, co_abbr)
VALUES ('Canada',                   'CA'),
       ('Japan',                    'JP'),
       ('South Korea',              'KR'),
       ('United States of America', 'US');


DROP TABLE IF EXISTS geo_region;
CREATE TABLE IF NOT EXISTS geo_region (
    rg_id   SMALLINT    AUTO_INCREMENT,
    rg_name VARCHAR(50) NOT NULL,
    rg_abbr CHAR(2),
    co_id   TINYINT     NOT NULL,
    active  BIT         NOT NULL DEFAULT 1,
    CONSTRAINT grg_PK PRIMARY KEY (rg_id),
    CONSTRAINT grg_UK UNIQUE (co_id, rg_name)
);

INSERT INTO geo_region (rg_name, rg_abbr, co_id)
VALUES ('Manitoba',   'MB', 1),
       ('Tokyo',      '',   2),
       ('Osaka',      '',   2),
       ('Gyeonggi',   '',   3),
       ('California', '',   4),
       ('Texas',      '',   4),
       ('Washington', '',   4);


DROP TABLE IF EXISTS geo_towncity;
CREATE TABLE IF NOT EXISTS geo_towncity (
    tc_id   MEDIUMINT   AUTO_INCREMENT,
    tc_name VARCHAR(15) NOT NULL,
    rg_id   SMALLINT    NOT NULL,
    active  BIT         NOT NULL DEFAULT 1,
    CONSTRAINT gtc_PK PRIMARY KEY (tc_id),
    CONSTRAINT gtc_UK UNIQUE (rg_id, tc_name)
);

INSERT INTO geo_towncity (tc_name, rg_id)
VALUES ('Winnipeg',    1),
       ('Chiyoda',     2),
       ('Minato',      2),
       ('Kadoma',      3),
       ('Suwon',       4),
       ('Seoul',       4),
       ('Los Altos',   5),
       ('Santa Clara', 5),
       ('Round Rock',  6),
       ('Redmond',     7);



DROP TABLE IF EXISTS people;

CREATE TABLE IF NOT EXISTS people (
    p_id      INT(11)      AUTO_INCREMENT,
    full_name VARCHAR(100) NULL,
    CONSTRAINT people_pk PRIMARY KEY(p_id)
);

INSERT INTO people (full_name)
VALUES ('Alex Gilmer'),
       ('Michelle Galinsky');


LOAD DATA LOCAL INFILE 'C:/_data/_imports/mg_0399259_boxstore_people_10k.csv'
INTO TABLE people
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(full_name);

ALTER TABLE people
    ADD COLUMN first_name VARCHAR(40) NULL,
    ADD COLUMN last_name  VARCHAR(60) NULL;


UPDATE people
SET first_name = MID(full_name, 1, INSTR(full_name, ' ') - 1),
    last_name  = MID(full_name, INSTR(full_name, ' ') + 1, 100);

ALTER TABLE people
    DROP COLUMN full_name;

/************************** END **************************/

-- Details on the different types of JOIN statements:
/*
-- INNER JOIN:
Returns rows from both tables where the variables match. 
When writing 'JOIN...' it is the default for the inner join.
Ex: INNER JOIN table2 ON table1.column = table2.column;

+-----------------------+     +-----------------------+
|            -----------------------------            |
|            |          |     |          |            |
|   Table1   |  column1 |-----|  column2 |   Table2   |
|            |          |     |          |            |
|            ----------------------------             |
+-----------------------+     +-----------------------+

-- LEFT JOIN:
Returns all rows of the table on the left side of the join statement
and the matched rows of the right table. 
If no match, returns NULL for the columns of the right table.
Ex: LEFT JOIN table2 ON table1.column = table2.column;
Output: The rows and columns of table1, and rows of the column 'column' in table2

+------------+     +---------------------+
| -----------------------------          |
| |          |     |  column2 |          |
| |  Table1  |-----|     /    |  Table2  |
| |          |     |    NULL  |          |
| -----------------------------          |
+------------+     +---------------------+


-- RIGHT JOIN:
Returns all rows of the table on the right side of the join statement
and the rows of the left table where the values match.
If no matches are found, returns NULL for columns from the left table.
Ex: RIGHT JOIN table2 ON table1.column = table2.column;
Output: The rows and columns of table2, and rows of the column 'column' in table1

+-----------------------+     +------------+
|            ----------------------------- |
|            | column1  |     |          | |
|   Table1   |    /     |-----|  Table2  | |
|            |   NULL   |     |          | |
|            ----------------------------  |
+-----------------------+     +------------+
*/

-- JOIN QUERY PRACTICE:
-- 1. Find the names of countries along with thier region names.
SELECT c.name AS country_name, r.name AS region_name
FROM countries c
JOIN regions r ON c.region_id = r.region_id;


-- 2. List all countries and their corresponding continent names.
SELECT c.name AS country_name, con.name AS continent_name
FROM countries c
JOIN regions r ON c.region_id = r.region_id
JOIN continents con ON r.continent_id = con.continent_id;


-- 3. Show the names of countries that speak English and the status 
-- (official or not) of the language in those countries
SELECT c.name AS country_name, cl.official AS official_language
FROM countries c
JOIN country_languages cl ON c.country_id = cl.country_id
JOIN languages l ON cl.language_id = l.language_id
WHERE l.`language` = 'English';


-- 4. Find the countries with their population and GDP for the year 2000.
SELECT c.name AS country_name, cs.population AS country_population, cs.gdp AS country_GDP
FROM countries c
JOIN country_stats cs ON c.country_id = cs.country_id
WHERE cs.`year` = 2000;


-- 5. List the names of countries along with the names of their 
-- official languages.
SELECT c.name AS country_name, l.`language` AS official_language
FROM countries c
JOIN country_languages cl ON c.country_id = cl.country_id
JOIN languages l ON cl.language_id = l.language_id
WHERE cl.official = TRUE;







/********** Lesson 7: **********/
-- Added lots of examples to the boxstore file (this is only the added commands
-- The final version follows the example:
/************************** START OF EXAMPLE **************************/
ALTER TABLE people
    ADD COLUMN first_name VARCHAR(40) NULL,
    ADD COLUMN last_name VARCHAR(60) NULL;

-- INSTR
-- Function that takes (haystack, needle) => number
-- searches the haystack (string) for the needle (also a string)
-- When it finds it, return the _position_ of that text
-- INSTR('Hello World', 'W') => 7
-- INSTR('Hello World', 'l') => 3

-- MID
-- Function that takes (string, start, length) => string
-- MID takes a 'slice' out of your starting string
-- It starts at the start position, and counts out _length_
-- characters to return back to you.
-- MID ('Hello World', 3, 5) => 'llo W'

UPDATE people
SET first_name = MID(full_name, 1, INSTR(full_name, ' ') - 1),
    last_name  = MID(full_name, INSTR(full_name, ' ') + 1, 100);

ALTER TABLE people
    DROP COLUMN full_name;


SELECT 
    full_name, 
    INSTR(full_name, ' ') AS 'Where is the space?',
    MID(full_name, 1, INSTR(full_name, ' ') - 1) AS 'New first name',
    MID(full_name, INSTR(full_name, ' ') + 1, 100) AS 'New last name'
FROM people;

UPDATE people
SET first_name = 'Alex',
    last_name = 'Gilmer'
WHERE p_id = 1;

UPDATE people
SET first_name = 'StudentFirstName',
    last_name = 'StudentLastName'
WHERE p_id = 2;


ALTER TABLE people
    ADD COLUMN col3 BIT NULL,
    ADD COLUMN col4 VARCHAR(6) DEFAULT 'Hello',
    ADD COLUMN col5 INT(11);

-- When modifying a column, the default takes on Null automatically
ALTER TABLE people
    MODIFY COLUMN col4 varchar(8),
    MODIFY COLUMN col5 INT(16);

ALTER TABLE people
    DROP COLUMN col5;
	
DESCRIBE people;
SELECT * FROM people;
/************************** END OF EXAMPLE **************************/

/************************** FINAL VERSION: **************************/
/*
Name: Michelle Galinsky
Updates:
	2025-01-15: Created file
				Added CREATE DATABASE command
	2025-02-06: Added DROP CREATE TABLE 'people' command
	            Added multiple columns and rows into the table
	            And inserted instructor and myself
	2025-02-12: Added ALTER TABLE and UPDATE TABLE
*/

USE mysql;

DROP DATABASE IF EXISTS
	mg_0399259_boxstore;

CREATE DATABASE IF NOT EXISTS
	mg_0399259_boxstore
	CHARSET='utf8mb4'
	COLLATE='utf8mb4_unicode_ci';

USE mg_0399259_boxstore;



DROP TABLE IF EXISTS people;

CREATE TABLE IF NOT EXISTS people (
    p_id int(11) AUTO_INCREMENT,
    full_name VARCHAR(100) NULL,
    CONSTRAINT people_pk PRIMARY KEY(p_id)
);

INSERT INTO people (full_name)
VALUES ('Alex Gilmer'),
       ('Michelle Galinsky');


ALTER TABLE people
    ADD COLUMN first_name VARCHAR(40) NULL,
    ADD COLUMN last_name VARCHAR(60) NULL;


UPDATE people
SET first_name = MID(full_name, 1, INSTR(full_name, ' ') - 1),
    last_name  = MID(full_name, INSTR(full_name, ' ') + 1, 100);

ALTER TABLE people
    DROP COLUMN full_name;







/********** Lesson 6: **********/
-- Created an example table called people (later changed but with the same name)
-- Here is this example with all the comments:
/************************** START OF EXAMPLE **************************/
/* Example Table Creation */
 
-- This table will be created with 3 columns
-- person_id is an integer that will track
-- the id values for the people
-- first_name and last_name are 50-max-length strings
-- AUTO_INCREMENT is a way of automatically assigning
-- values without having to manually insert them
CREATE TABLE IF NOT EXISTS people (
    person_id  INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NULL,
    last_name  VARCHAR(50) DEFAULT 'Doe',
    
    CONSTRAINT people_PK PRIMARY KEY(person_id)
    CONSTRAINT people_unique_fn UNIQUE(first_name)
);
-- The NULL after the datatype allows the default value to be null
-- DEFAULT allows you to specify what value you want as the default


-- A "primary key" is a type of _constraint_
-- It forces the selected column to adhere to 
-- some specific rules:
--		The column may NOT be null EVER
--		All the values in the column must be unique
-- The values are 'clustered', meaning 'stored in THIS order'

-- A "unique key" is another type of _constraint_
-- Similar to the primary key, but different:
-- 		Does not require non-null values
--		Data is not clustered


INSERT INTO people (first_name, last_name)
VALUES ('Michelle', 'Galinsky'), ('John', 'Doe'), ('Jane', 'Doe'),
('Superman', NULL), ('Clark', 'Kent'), ('A', 'Person'), ('The', 'Flash');

INSERT INTO people (first_name)
VALUES ('Possum'), ('Bunny'), ('Frog');

-- List of CONSTRAINTs used:
--      PRIMARY KEY
--      UNIQUE

-- VARCHAR -> variable length char (ex: VARCHAR(50) - input has to be less than 50 char)
-- CHAR -> fixed length (ex: CHAR(20) - input has to be 20 char)


DROP TABLE IF EXISTS people;

CREATE TABLE IF NOT EXISTS people (
    p_id int(11) AUTO_INCREMENT,
    full_name VARCHAR(100) NULL,
    CONSTRAINT people_pk PRIMARY KEY(p_id)
);

INSERT INTO people (full_name)
VALUES ('Alex Gilmer'),
       ('Michelle Galinsky');
	   
	   
INSERT INTO people (full_name)
VALUES ('Michelle Galinsky'), 
       ('John Doe'), 
       ('Joe Somebody'),
       ('Jane Doe');

DELETE FROM people
WHERE p_id = 3;

-- Use primary key identifiers to delete rows/records
-- This is used because primary key identifiers uniquely 
-- identify each row/record in a table, ensuring that only the 
-- intended data is deleted without affecting other records.


INSERT INTO people (full_name)
VALUES ('New Person');
-- This uses the next available id (not the id just deleted)

-- Truncate table does TWO THINGS: 
--      - Delete ALL the data(rows) from the table
--      - Resets the auto-increment
TRUNCATE TABLE people;

INSERT INTO people (full_name)
VALUES ('Fallout guy'),
       ('Radiated Zombie');


CREATE TABLE IF NOT EXISTS users(
    user_id INT,
    active BIT DEFAULT TRUE
);
/************************** END OF EXAMPLE **************************/





-- Here is the final look at the added info to the boxstore file (no previous):
/*
Name: Michelle Galinsky
Updates:
	2025-01-15: Created file
				Added CREATE DATABASE command
	2025-02-06: Added DROP CREATE TABLE 'people' command
	            Added multiple columns and rows into the table
	            And inserted instructor and myself
*/

DROP TABLE IF EXISTS people;

CREATE TABLE IF NOT EXISTS people (
    p_id int(11) AUTO_INCREMENT,
    full_name VARCHAR(100) NULL,
    CONSTRAINT people_pk PRIMARY KEY(p_id)
);

INSERT INTO people (full_name)
VALUES ('Alex Gilmer'),
       ('Michelle Galinsky');



/********** Lesson 5: **********/
-- Topics discussed in class:
/*
Topics:
	SELECT query syntax
		SUBQUERY w/1 row returned using column labels and table alias
	Data Types:
		BIT: 0&1 (FALSE & TRUE, OFF & ON, toggling boolean type)
		INT Types: (TINYINT|SMALLINT|MEDIUMINT|INT|BIGINT)
		NUMERIC: (DOUBLE, DECIMAL, FLOAT)
		'String' Types (CHAR vs VARCHAR vs TEXT)
		'Date-Time' Types (DATETIME vs DATE vs TIME)
		'YYYY-MM-DD HH:MM:SS' (19 characters)
		NULL value type (cell empty, row not exists, and not ='' empty string)
	WHERE (Conditionals / Filtering): 
		1=1 (placeholder that indicates TRUE or show rows)
		column_name
		Standard Operators (=, <, >, <>, >=, <=)
		LIKE: parameters: '_' vs. '%'
		IN (list,of,values)
		BETWEEN small_range_val AND large_range_val
		IS NULL vs IS NOT NULL (for NULL checks)
		using AND and/or OR w/brackets
	Mathematics (+, -, *, /, %)
	SQL Functions:
		String: TRIMs, CONCAT, LENGTHs, IFNULL
		Date: QUARTER, YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, WEEKDAY, MONTHNAME, DAYNAME, DATE_FORMAT
*/



/********** Lesson 4: **********/
-- Practiced different commands in MariaDB
-- Here is the code obtained, along with the questions used:

-- Avoid the use of JOIN statements
-- Num1: Show me the continents in alphabetical order
SELECT name
FROM continents
ORDER BY name ASC;

-- Num2: How many regions are there?
SELECT COUNT(DISTINCT name)
FROM regions;

-- Num3: Show me the ids and names of guests with odd ids
SELECT guest_id, name
FROM guests
WHERE guest_id % 2 != 0;

-- Num4: Which countries are in region 6?
SELECT name
FROM countries
WHERE region_id = 6;

-- Num5: Show me the countries with no national day in region 6
SELECT name
FROM countries
WHERE national_day IS NULL AND region_id = 6;

-- Num6: Show me the countries that share a region with China
SELECT name
FROM countries
WHERE region_id = (
    SELECT region_id
    FROM countries
    WHERE name = 'China'
);

-- Num7: What is the GDP of Cuba in the 1980's?
SELECT `year`, gdp
FROM country_stats
WHERE country_id =(
    SELECT country_id
    FROM countries
    WHERE name = 'Cuba'
)
AND `year` BETWEEN 1980 AND 1989;

-- Num8: Add a column with the country name, and aliases to the previous query
SELECT 'Cuba' AS 'Country', `year` AS 'Year', gdp AS 'Gross Domestic Product'
FROM country_stats
WHERE country_id =(
    SELECT country_id
    FROM countries
    WHERE name = 'Cuba'
)
AND `year` BETWEEN 1980 AND 1989;

-- Num9: What is the latest recorded population of Bolivia?
SELECT population
FROM country_stats
WHERE country_id =(
    SELECT country_id
    FROM countries
    WHERE name = 'Bolivia'
)
ORDER BY year DESC
LIMIT 1;

-- Num10: Which languages are spoken in Canada?
SELECT `language`
FROM languages
WHERE language_id IN (
    SELECT language_id
    FROM country_languages
    WHERE country_id = (
        SELECT country_id
        FROM countries
        WHERE name = 'Canada'
    )
);


/********** Lesson 3: **********/

-- Removes leading and trailing spaces from a string
SELECT TRIM ('  Hello World!  ') AS TrimmedValue;
-- Output: 'Hello World!'

--Concatenates two or more strings
SELECT CONCAT('Hello', ' ', 'World!') AS ConcatenatedValue;
-- Output: 'Hello World!'

-- Returns the length of a string
SELECT LENGTH('Hello World!') AS StringLength;
-- Output: 12

-- Returns a specified value if the expression is NULL; 
-- otherwise, it returns the expression
-> SELECT IFNULL(NULL, 'Default Value') AS Result;
-- Output: 'Default Value'
-> SELECT IFNULL(NULL, 'Alternative Value') AS Result;
-- Output: 'Alternative Value'
-> SELECT IFNULL('Hello', 'Default Value') AS Result;
-- Output: 'Hello'
-> SELECT IFNULL(NULL, NULL) AS Result;
-- Output: NULL

-- Returns the quarter of the year from a date
SELECT QUARTER('2025-01-22') AS QuarterOfYear;
-- Output: 1

-- Returns the year from a date
SELECT YEAR('2025-01-22') AS YearValue;
-- Output: 2025

-- Returns the month from a date
SELECT MONTH('2025-01-22') AS MonthValue;
-- Output: 1

-- Returns the day from a date
SELECT DAY('2025-01-22') AS DayValue;
-- Output: 22

-- Returns the hour from a time or datetime value
SELECT HOUR('18:30:45') AS HourValue;
-- Output: 18

-- Returns the minute from a time or datetime value
SELECT MINUTE('18:30:45') AS MinuteValue;
-- Output: 30

-- Returns the second from a time or datetime value
SELECT SECOND('18:30:45') AS SecondValue;
-- Output: 45

-- Return the day of the week from a date
SELECT WEEKDAY('2025-01-22') AS WeekDayValue;
-- Output: 2 (where 0 = Monday, 1 = Tuesday, etc.)

-- Returns the name of the month from a date
SELECT MONTHNAME('2025-01-22') AS MonthName;
-- Output: 'January'

--Returns the name of the day of the week from a date
SELECT DAYNAME('2025-01-22') AS DayName;
-- Output: 'Wednesday'

--Formats a date according to a specified format
SELECT DATE_FORMAT('2025-01-22', '%W, %M %d, %Y') AS Format
-- Output: 'Wednesday, January 22, 2025'



/********** Lesson 2: **********/
/*
Name: Michelle Galinsky
Updates:
	2025-01-15: Created file
				Added CREATE DATABASE command
*/
-- This command can be used to create the boxstore
-- database. We begin by first connecting to an 
-- arbitrary database to prevent disconnection errors.
-- Then we drop the database in its entirety,
-- and fully recreate it afterwards.
-- Then, finally, we connect to this database for
-- further operations.
USE mysql;


DROP DATABASE IF EXISTS
	mg_0399259_boxstore;

CREATE DATABASE IF NOT EXISTS
	mg_0399259_boxstore
	CHARSET='utf8mb4'
	COLLATE='utf8mb4_unicode_ci';

USE mg_0399259_boxstore;



/********** Lesson 1: **********/

--Use this command to show the list of all tables
-- in the current database
SHOW TABLES;

-- Use this command to show all of the databases
-- in the server
SHOW DATABASES;

-- Go into specific database
USE databasename;

-- To check the name of the database
-- we're currently in
SELECT DATABASE;

-- Shows the table and information about it
DESCRIBE tablename;

-- Command for starting mysql in command prompt
-- mysql -u root -p

-- Used to  get data from one or more tables in a database. 
-- It retrieves data from tables within the currently selected database
--An example:
SELECT name,age FROM users WHERE age  > 18;  

SELECT *, columna, columnb, columnc --- specifies the columns to retrieve data from
FROM tablename -- specifies the table to fetch data from.
WHERE condition; -- filters only rows that meet the specified condition.

-- Any command that wants to collect information
-- from the tables in a database begins with SELECT.
-- You add a FROM command to indicate which table
-- (or tables) from which to collect the data.
SELECT *, columna, columnb, columnc
FROM tablename

-- While operating a SELECT statement, you may add
-- one or more conditions through the use of WHERE.
-- Conditions typically use =, <, >, != for equality
-- but can also include other types of conditions.
SELECT * FROM tablename
WHERE condition;

-- While operating a SELECT statement, you may order
-- the results of the data using ORDER BY.
-- Use ASC for when you want the data in ascending order.
-- Use DESC for when you want the data in descending order.
-- You can specify multiple columns for the ORDER BY.
-- Doing so creates a "priority sort" where if two or 
-- more rows match in the primary sort column, it will
-- use the secondary/later columns as the sort.
-- A good example would be:
-- ORDER BY lastname, firstname;

SELECT * FROM tablename
ORDER BY columnA, columnB ASC;

SELECT * FROM tablename
ORDER BY columnc DESC;

-- Use SELECT * to "select everything"
-- Used to retrieve all columns from a table in a database
SELECT *

/* DROP/CREATE/USE DATABASE block */
-- Deletes the database
-- IF EXISTS used to prevent errors if database doesn't exist
DROP DATABASE IF EXISTS databasename;

-- Creates the database if it doesn't exists
-- CHARSET: Specifies the database uses 'utf8mb4' character set
-- COLLATE: Defines the collation 'utf8mb4_unicode_ci' which 
-- is case-insensitive
CREATE DATABASE IF NOT EXISTS databasename
CHARSET = 'utf8mb4'
COLLATE = 'utf8mb4_unicode_ci';

-- Switch to the database
USE databasename;
/* Block End */



/**** DEFINITIONS: ****/
-- UTFA Coding Scheme: character rules
-- UTFA-8: uses 8-bits of database


/**** DATATYPES: ****/
-- BIT: 0&1 (FALSE & TRUE, OFF & ON, toggling boolean type)
-- INT Types: (TINYINT|SMALLINT|MEDIUMINT|INT|BIGINT)
-- NUMERIC: (DOUBLE, DECIMAL, FLOAT)
-- 'String' Types (CHAR vs VARCHAR vs TEXT)
-- 'Date-Time' Types (DATETIME vs DATE vs TIME)
-- 'YYYY-MM-DD HH:MM:SS' (19 characters)
-- NULL value type (cell empty, row not exists, and not ='' empty string)

/* SQL Numeric Data Types
| DATATYPE | FROM                              | TO                           |
|----------|-----------------------------------|------------------------------|
| bit      | 0                                 | 1                            |
| tinyint  | 0                                 | 255                          |
| smallint | -32,768                           | 32,767                       |
| int      | -2,147,483,648                    | 2,147,483,647                |
| bigint   | -9,223,372,036,854,775,808        | 9,223,372,036,854,775,807    |
| decimal  | -10^38 + 1                        | 10^38 - 1                    |
| numeric  | -10^38 + 1                        | 10^38 - 1                    |
| float    | -1.79E + 308                      | 1.79E + 308                  |
| real     | -3.40E + 38                       | 3.40E + 38                   |
*/

																			  
/* SQL Date and Time Data Type
| DATATYPE     | DESCRIPTION                                                  |
|--------------|--------------------------------------------------------------|
| DATE         | Stores data in the format YYYY-MM-DD                         |
| TIME         | Stores time in the format HH:MI:SS                           |
| DATETIME     | Stores date and time information in the format YYYY-MM-DD    |
| TIMESTAMP    | Stores the number of seconds passed since the Unix epoch     |
| YEAR         | Stores year in 2-digit or 4-digit format. Range 1901 to 2155 |
|              | in 4-digit format. Range 70 to 69, representing 1970 to 2069 |
*/


/* SQL Character and String Data Types
| DATATYPE     | DESCRIPTION                                                  |
|--------------|--------------------------------------------------------------|
| CHAR         | Fixed length with a maximum length of 8,000 characters       |
| VARCHAR      | Variable length storage with a maximum length of 8,000 chars |
| VARCHAR(max) | Variable length storage with provided max characters, not    |
|              | supported in MySQL                                           |
| TEXT         | Variable length storage with a maximum size of 2GB data      |
| CLOB         | A Character Large OBject (or CLOB) is a collection of        |
|              | character data in a database management system, usually      |
|              | stored in a separate location that is referenced in the      |
|              | table itself                                                 |
| nchar        | Same as char but additionally supports Unicode               |
| nvarchar(max)| National character varying type, same as varchar but for     |
|              | Unicode characters. If max is specified, the maximum number  |
|              | of characters is 2GB                                         |
| ntext        | It takes up as much as the entered character size of data,   |
|              | supports Unicode                                             |
*/


/****BEST PRACTICES (inserted directly from work): ****/
/*
Best practices when designing your tables:
    - All tables should have a primary key
      This is used to uniquely identify each record in the table
    - If the data you are storing in the table does not have
      some kind of uniquely-identifying feature then it is perfectly
      acceptable (and fully advised) to create your own primary key
      column using a relevant data type
    - All tables should have columns representing data that is
      pertinent to ONLY THAT ENTITY 
      (ex: including a history of leaders in a countries table -> redundant)
*/
/*
Common industry practice is to NEVER delete data -> Data is valuable
Instead, you typically design your tables with a BIT value that
represents some manner of "active" status.
So when a user requests account deletion, you simply flip that BIT 
to 'false' and ensure your system simply doesn't use that data
*/
