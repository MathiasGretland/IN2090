-- 1
-- 1
SELECT genre
FROM genre;

-- 2
SELECT filmid, title
FROM film
WHERE prodyear = 1892;

-- 3
SELECT filmid, title
FROM film
WHERE filmid > 2000 AND filmid < 2030;

-- 4
SELECT filmid, title
FROM film
WHERE title LIKE '%Star Wars%';

-- 5
SELECT firstname, lastname
FROM person
WHERE personid = 465221;

-- 6
SELECT DISTINCT parttype
FROM filmparticipation;

-- 7
SELECT title, prodyear
FROM film
WHERE title LIKE '%Rush Hour%';

-- 8
SELECT filmid, title, prodyear
FROM film
WHERE title LIKE '%Norge%';

-- 9
SELECT fi.filmid
FROM filmitem AS fi
    JOIN film AS f USING (filmid)
WHERE fi.filmtype = 'C' AND f.title = 'Love';

-- 10
SELECT count(filmid) AS antall_filmer
FROM filmcountry
WHERE country = 'Norway';

-- 2
-- 1
SELECT filmid, fi.filmtype
FROM film AS f
    JOIN filmitem AS fi USING (filmid)
WHERE f.prodyear = 1894;

-- 2
SELECT p.firstname, p.lastname
FROM person AS p
WHERE p.gender = 'F' AND p.personid IN (
    SELECT fp.personid
    FROM filmparticipation AS fp
    WHERE fp.filmid = 357076 AND fp.parttype = 'cast'
    )
ORDER BY p.lastname;

-- alternativ løsning
SELECT p.firstname, p.lastname
FROM person AS p
    JOIN filmparticipation AS fp USING (personid)
WHERE p.gender = 'F'
    AND fp.filmid = 357076
    AND fp.parttype = 'cast';


-- 3
-- 1
SELECT g.genre
FROM filmgenre as g
WHERE g.filmid IN (
    SELECT filmid
    FROM film
    WHERE title = 'Pirates of the Caribbean: The Legend of Jack Sparrow'
);

-- 2
SELECT g.genre
FROM filmgenre as g
WHERE g.filmid IN (
    SELECT filmid
    FROM film
    WHERE filmid = 985057
);

-- 3
SELECT f.title, f.prodyear, fi.filmtype
FROM film AS f
    JOIN filmitem AS fi USING (filmid)
WHERE f.prodyear = 1894;

-- 4
SELECT p.firstname, p.lastname, filmid, f.title
FROM filmparticipation AS fp
    JOIN person AS p USING (personid)
    JOIN film AS f USING (filmid)
WHERE p.gender = 'F'
    AND fp.parttype = 'cast'
    AND filmid = 357076;

-- 5
-- i
SELECT p.firstname, p.lastname
FROM person AS p
    JOIN filmparticipation AS fp USING (personid)
    JOIN series AS s ON s.seriesid = fp.filmid
WHERE s.maintitle = 'South Park';

-- iii
SELECT p.firstname, p.lastname
FROM person AS p
    NATURAL JOIN filmparticipation AS fp
    NATURAL JOIN series AS s
WHERE s.maintitle = 'South Park';

-- iv
Se begrunelse på NATURAL JOIN i løsningsforslaget

-- 6
SELECT DISTINCT p.firstname, p.lastname, fp.parttype, f.title
FROM filmparticipation AS fp
    JOIN person AS p USING (personid)
    JOIN film as f USING (filmid)
WHERE fp.parttype = 'cast'
    AND f.title = 'Harry Potter and the Goblet of Fire';

-- 7
SELECT p.firstname, p.lastname
FROM person AS p
    JOIN filmparticipation AS fp USING (personid)
    JOIN film AS f USING (filmid)
WHERE fp.parttype = 'cast'
    AND f.title = 'Baile Perfumado';

-- 8
SELECT f.title, p.firstname || ' ' || p.lastname AS fullname
FROM person AS p
    JOIN filmparticipation AS fp USING (personid)
    JOIN film AS f USING (filmid)
    JOIN filmcountry AS fc USING (filmid)
WHERE fp.parttype = 'director'
    AND fc.country = 'Norway'
    AND f.prodyear < 1960;
