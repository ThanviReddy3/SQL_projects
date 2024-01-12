create database museum;
use museum;
CREATE TABLE met (
    ID INT PRIMARY KEY,
    Department VARCHAR(100),
    Category VARCHAR(100),
    Title VARCHAR(100),
    Artist VARCHAR(100),
    Date VARCHAR(100),
    Medium VARCHAR(100),
    Country VARCHAR(100)
);
use museum;

SELECT 
    *
FROM
    met;

-- Select the top 10 rows in the met table.
SELECT 
    *
FROM
    met
LIMIT 10;

-- How many pieces are in the American Metropolitan Art collection? [count(*)]
SELECT
    COUNT(*) AS Pieces
FROM
    met;

-- Count the number of pieces where the category includes ‘celery’.
SELECT 
    COUNT(*) as celerycount
FROM
    met
WHERE
    Category LIKE 'celery%';

-- Find the title and medium of the oldest piece(s) in the collection.
SELECT 
    Title, Medium, Date
FROM
    met
WHERE
    Date BETWEEN 1600 AND 1670
limit 1;

-- or 
SELECT 
    Title, Medium, Date
FROM
    met
WHERE
    DATE = (SELECT MIN(Date) FROM met);
    
-- Find the top 10 countries with the most pieces in the collection.
SELECT 
    Country, COUNT(*) AS countpiece
FROM
    met
GROUP BY Country
ORDER BY countpiece DESC
LIMIT 10;

-- Find the categories which have more than 100 pieces.
SELECT 
    Category, COUNT(*) AS countpiece
FROM
    met
GROUP BY Category
HAVING countpiece > 100;

-- or 

SELECT 
    Category, COUNT(*) AS countpiece
FROM
    met
GROUP BY Category
order by countpiece desc
limit 1;

-- Count the number of pieces where the medium contains ‘gold’ or ‘silver’ and sort in descending order.
SELECT medium, COUNT(medium) AS countpiece
FROM met
WHERE Medium LIKE '%gold%'
        OR Medium LIKE '%silver%'
group by medium
order by count(medium) desc;
