-- 1
SELECT p.firstname || ' ' || p.lastname AS navn, count(fp.personid) AS antall_produksjoner
FROM person AS p
    LEFT OUTER JOIN filmparticipation AS fp USING (personid)
WHERE p.lastname = 'Abbott'
GROUP BY p.personid, p.firstname, p.lastname;

-- 2
-- a
SELECT f.title
FROM film AS f
    JOIN filmgenre AS fg USING (filmid)
WHERE f.filmid NOT IN (SELECT filmid FROM filmrating)
    AND f.prodyear > 2007
    AND fg.genre = 'Western';

-- b
SELECT f.title
FROM film AS f
     INNER JOIN filmgenre AS g USING (filmid)
     LEFT OUTER JOIN filmrating AS r USING (filmid)
WHERE r.filmid IS NULL AND
      g.genre = 'Western' AND
      f.prodyear > 2007;

-- c
SELECT title
FROM film
WHERE prodyear > 2007 AND
      filmid IN (
        (SELECT filmid
         FROM filmgenre
         WHERE genre = 'Western')
        EXCEPT
        (SELECT filmid
         FROM filmrating));

-- d
SELECT f.title
FROM film AS f
     INNER JOIN filmgenre AS fg
     USING (filmid)
WHERE f.prodyear > 2007 AND
      fg.genre = 'Western' AND
      NOT EXISTS (
        SELECT *
        FROM filmrating AS r
        WHERE r.filmid = f.filmid);

-- 3
SELECT count(DISTINCT filmid) AS antall_filmer
FROM film
WHERE filmid IN (
    (SELECT filmid
    FROM filmparticipation AS fp
        JOIN person AS p USING (personid)
    WHERE p.firstname = 'Jim'
        AND p.lastname = 'Carrey')
    UNION
    (SELECT filmid
    FROM filmgenre
    WHERE genre = 'Comedy')
);

-- 4
SELECT title
FROM film
WHERE filmid IN (
    (SELECT filmid
    FROM filmparticipation AS fp
        JOIN person AS p USING (personid)
    WHERE p.firstname = 'Jim'
        AND p.lastname = 'Carrey')
    EXCEPT
    (SELECT filmid
    FROM filmgenre
    WHERE genre = 'Comedy')
);

-- 5
SELECT company_name
FROM customers
WHERE country = 'Norway' OR country = 'Sweden'
UNION ALL
SELECT company_name
FROM suppliers
WHERE country = 'Norway' OR country = 'Sweden';

-- 6
