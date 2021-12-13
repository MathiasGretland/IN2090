-- 1
SELECT filmtype, count(filmtype)
FROM filmitem
GROUP BY filmtype;

-- 2
SELECT s.maintitle, s.firstprodyear, count(s.seriesid) AS antall_episoder
FROM series AS s
    JOIN episode AS e USING (seriesid)
GROUP BY s.maintitle, s.firstprodyear
ORDER BY s.firstprodyear ASC
LIMIT 15;

-- 3
SELECT title, count(title) AS title_brukt
FROM film
GROUP BY title
HAVING count(title) > 30
ORDER BY count(title) DESC;

-- 4
SELECT title
FROM film
WHERE title IN (
    SELECT title
    FROM film AS f
        JOIN filmgenre AS g USING (filmid)
    WHERE title LIKE '%Pirates of the Caribbean%'
    GROUP BY title
    HAVING count(genre) > 3
);

-- 5
SELECT p.firstname, count(p.firstname) AS antall_forekomster
FROM person AS p
WHERE p.firstname != '' --Fjerner også NULLs
GROUP BY p.firstname
ORDER BY antall_forekomster DESC
LIMIT 20;

-- 6
SELECT f.filmid, f.title, count(fg.genre) AS antall_genre
FROM film AS f
    JOIN filmgenre AS fg USING (filmid)
GROUP BY f.filmid, f.title
ORDER BY antall_genre DESC
LIMIT 25;

-- 7
SELECT firstname, lastname
FROM filmparticipation AS fp
    JOIN person AS p USING (personid)
    JOIN filmcountry AS fc USING (filmid)
    JOIN film AS f USING (filmid)
WHERE parttype = 'director'
    AND fc.country = 'Norway'
GROUP BY firstname, lastname
HAVING count(*) > 5;

-- 8
SELECT s.seriesid, s.maintitle, s.firstprodyear
FROM series AS s
WHERE s.firstprodyear IS NOT NULL
ORDER BY s.firstprodyear DESC
LIMIT 50;

-- 9
SELECT avg(fr.rank)
FROM filmrating AS fr
WHERE votes > 100000;

-- 10
SELECT f.title, fr.rank
FROM film AS f
    JOIN filmrating AS fr USING (filmid)
WHERE fr.votes > 100000 AND fr.rank >= (
    SELECT avg(fr.rank)
    FROM filmrating AS fr
    WHERE votes > 100000
);

-- 11
SELECT firstname, count(firstname) AS ant
FROM person
WHERE firstname != ''
GROUP BY firstname
ORDER BY ant DESC
LIMIT 100;

-- 12
WITH
    ant_fornavn AS (
        SELECT firstname, count(firstname) AS antall
        FROM person
        GROUP BY firstname
        HAVING count(firstname) > 6000
    )
SELECT A.firstname, B.firstname
FROM ant_fornavn AS A
    JOIN ant_fornavn AS B ON A.antall = B.antall AND A.firstname != B.firstname;

-- 13
SELECT count(filmid) AS antall_filmer
FROM film
WHERE filmid IN (
    SELECT filmid
    FROM film AS f
        JOIN filmparticipation AS fp USING (filmid)
        JOIN person AS p USING (personid)
    WHERE fp.parttype = 'director'
        AND p.firstname = 'Tancred'
        AND p.lastname = 'Ibsen'
);

-- 14
SELECT title
FROM film
WHERE filmid IN (
    SELECT filmid
    FROM film AS f
        JOIN filmcountry AS fc USING (filmid)
        JOIN filmparticipation AS fp USING (filmid)
    WHERE fc.country = 'Norway'
        AND fp.parttype = 'director'
    GROUP BY filmid
    HAVING count(fp.parttype) > 1
);

-- 15
SELECT lastname || ', ' || firstname AS navn, COUNT(*) AS antall
FROM filmcountry
     JOIN film USING (filmid)
     JOIN filmparticipation USING (filmid)
     JOIN person USING (personid)
WHERE country = 'Norway' AND
      parttype = 'director' AND
      filmid NOT IN ( -- Norske filmer med mer enn én regissør
           SELECT filmid
           FROM filmcountry
                JOIN film USING (filmid)
                JOIN filmparticipation USING (filmid)
                JOIN person USING (personid)
           WHERE country = 'Norway' AND
                 parttype = 'director'
           GROUP BY filmid, title
           HAVING COUNT(*) > 1
        )
GROUP BY lastname, firstname
HAVING COUNT(*) > 5
ORDER BY antall DESC;

-- 16
SELECT title, prodyear, filmtype
FROM film AS f
    JOIN filmitem AS fi USING (filmid)
WHERE prodyear = 1893
    AND filmtype = 'C';

-- 17
SELECT firstname, lastname
FROM person
WHERE personid IN (
    SELECT personid
    FROM filmparticipation AS fp
        JOIN film AS f USING (filmid)
    WHERE parttype = 'cast'
        AND title = 'Baile Perfumado'
);

-- 18
SELECT title, prodyear
FROM film
WHERE filmid IN (
    SELECT filmid
    FROM film AS f
        JOIN filmparticipation AS fp USING (filmid)
        JOIN person AS p USING (personid)
    WHERE p.firstname = 'Ingmar'
        AND p.lastname = 'Bergman'
        AND fp.parttype = 'director'
)
ORDER BY prodyear ASC;

-- 19
WITH
    IngmarBergman AS (
        SELECT filmid, title, prodyear
        FROM film AS f
            JOIN filmparticipation AS fp USING (filmid)
            JOIN person AS p USING (personid)
        WHERE p.firstname = 'Ingmar'
            AND p.lastname = 'Bergman'
            AND fp.parttype = 'director'
    )
SELECT MIN(prodyear), MAX(prodyear)
FROM IngmarBergman;

-- 20
SELECT title, prodyear
FROM film
WHERE filmid IN (
    SELECT filmid
    FROM filmparticipation AS fp
    GROUP BY filmid
    HAVING count(DISTINCT personid) > 300
);

-- 21
SELECT firstname || ' ' || lastname AS regissor, count(filmid) AS antall, MIN(prodyear) AS forste_film, MAX(prodyear) AS siste_film
FROM person AS p
    JOIN filmparticipation AS fp USING (personid)
    JOIN film AS f USING (filmid)
    JOIN filmitem AS fi USING (filmid)
WHERE parttype = 'director'
    AND filmtype = 'C'
GROUP BY personid, firstname, lastname
HAVING (MAX(prodyear) - MIN(prodyear) > 49)
ORDER BY (MAX(prodyear) - MIN(prodyear)) DESC;

-- 22
WITH ingmarbergmanmovies AS (
  SELECT fp.filmid
  FROM filmparticipation AS fp
       INNER JOIN person AS p ON fp.personid = p.personid
  WHERE fp.parttype = 'director' AND
        p.firstname = 'Ingmar' AND
        p.lastname = 'Bergman'
),
ant_regissorer AS (
  SELECT fp.filmid, COUNT(*) ant
  FROM filmparticipation AS fp
  WHERE fp.filmid IN (SELECT * FROM ingmarbergmanmovies)
        AND fp.parttype = 'director'
  GROUP BY fp.filmid
)
SELECT f.filmid, f.title, (ar.ant - 1) AS ant_medregissorer
FROM film AS f INNER JOIN ant_regissorer AS ar ON f.filmid = ar.filmid;

-- 23
WITH
    IngmarBergman AS (
        SELECT filmid, title, prodyear, personid
        FROM film AS f
            JOIN filmparticipation AS fp USING (filmid)
            JOIN person AS p USING (personid)
        WHERE p.firstname = 'Ingmar'
            AND p.lastname = 'Bergman'
            AND fp.parttype = 'director'
    )
SELECT filmid, count(personid) AS antall_personer, prodyear, rank
FROM IngmarBergman AS i
    JOIN filmrating AS fr USING (filmid)
GROUP BY filmid, prodyear, rank
ORDER BY prodyear ASC;

-- 24
WITH
    AngelinaJolie AS(
        SELECT filmid, prodyear, title
        FROM film AS f
            JOIN filmparticipation AS fp USING (filmid)
            JOIN person AS p USING (personid)
        WHERE firstname = 'Angelina'
            AND lastname = 'Jolie'
    ), AntonioBanderas AS (
        SELECT filmid, prodyear, title
        FROM film AS f
            JOIN filmparticipation AS fp USING (filmid)
            JOIN person AS p USING (personid)
        WHERE firstname = 'Antonio'
            AND lastname = 'Banderas'
    )
SELECT A.prodyear, A.title --Spiller ingen rolle om vi gjør det slik eller tar B.prodyear, B.title
FROM AngelinaJolie AS A
    JOIN AntonioBanderas AS B USING (filmid)
WHERE A.filmid = B.filmid;

-- løsningsforslaget:
SELECT f.title, f.prodyear
FROM film AS f
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
WHERE p.firstname = 'Angelina' AND
      p.lastname = 'Jolie' AND
      fp.filmid IN (
        SELECT fp2.filmid
        FROM filmparticipation AS fp2 JOIN person AS p USING (personid)
        WHERE p.firstname = 'Antonio' AND
              p.lastname = 'Banderas'
      );

-- 25 IKKE RIKTIG
SELECT DISTINCT title, firstname, lastname, parttype
FROM person AS p
    JOIN filmparticipation AS fp USING (personid)
    JOIN film AS f USING (filmid)
WHERE filmid IN (
    SELECT filmid
    FROM film AS f
        JOIN filmparticipation AS fp USING (filmid)
        JOIN filmitem AS fi USING (filmid)
    WHERE filmtype = 'C'
        AND prodyear = 2003
)
GROUP BY title, firstname, lastname, parttype
HAVING count(parttype) > 0;

-- 26
SELECT firstname, lastname, count(DISTINCT filmid) AS antall_filmer
FROM person AS p
    JOIN filmparticipation AS fp USING (personid)
    JOIN film AS f USING (filmid)
WHERE prodyear IN (2008,2009,2010)
    AND personid NOT IN (
    SELECT personid
    FROM person AS p
        JOIN filmparticipation AS fp USING (personid)
        JOIN film AS f USING (filmid)
    WHERE prodyear = 2005
)
GROUP BY personid, firstname, lastname
HAVING count(DISTINCT filmid) > 15;

-- 27
SELECT firstname || ' ' || lastname AS regissor, title
FROM person AS p
    JOIN filmparticipation AS fp USING (personid)
    JOIN film AS f USING (filmid)
WHERE parttype = 'director'
    AND filmid IN ( --Filmer hvor mer enn 200 personer har deltatt
        SELECT filmid
        FROM film AS f
            JOIN filmparticipation AS fp USING (filmid)
        GROUP BY filmid
        HAVING count(DISTINCT personid) > 200
    )
    AND filmid NOT IN ( --Filmer hvor det finnes mer enn 1 regissør
    SELECT filmid
    FROM film AS f
        JOIN filmparticipation AS fp USING (filmid)
    WHERE parttype = 'director'
    GROUP BY filmid
    HAVING count(parttype) > 1
);

-- 28



WHERE personid IN (
    SELECT personid
    FROM person AS p
        JOIN filmparticipation AS fp USING (personid)
        JOIN filmitem AS fi USING (filmid)
    WHERE parttype = 'director'
        AND filmtype = 'C'
    GROUP BY personid
    HAVING count(parttype) = 1
)
