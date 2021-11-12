#Vi bruker filmdatabasen

#For å komme inn på filmdatabasen

ssh mathige@login.ifi.uio.no

psql -h dbpg-ifi-kurs01 -U mathige -d fdb

#COPY PASTE I GITBASH ER SLIK: SHIFT + INS

#1
SELECT filmtype, count(filmid)
FROM filmitem
GROUP BY filmtype;

#2
SELECT s.maintitle, s.firstprodyear, count(e.seriesid) AS antall_episoder
FROM series AS s INNER JOIN episode as e USING (seriesid)
GROUP BY s.maintitle, s.firstprodyear
ORDER BY s.firstprodyear ASC
LIMIT 15;

#3
SELECT f.title, count(f.title) AS antall_filmer
FROM film AS f
GROUP BY f.title
HAVING count(f.title) > 30
ORDER BY antall_filmer ASC;

#4
SELECT f.title
FROM film as f INNER JOIN filmgenre as g USING (filmid)
WHERE f.title LIKE '%Pirates of the Caribbean%'
GROUP BY f.title
HAVING count(g.genre) > 3;

#5
SELECT p.firstname, count(p.firstname) AS antall_forekomster
FROM person as p
WHERE p.firstname IS NOT NULL
GROUP BY p.firstname
ORDER BY antall_forekomster DESC
LIMIT 30;

#6
SELECT f.filmid, f.title, count(g.genre) AS antall_genre
FROM film as f INNER JOIN filmgenre as g USING (filmid)
GROUP BY f.filmid, f.title
ORDER BY count(g.genre) DESC
LIMIT 25;

#7 LØK
SELECT lastname || ',' || firstname AS navn
FROM filmcountry
  JOIN film USING (filmid)
  JOIN filmparticipation USING (filmid)
  JOIN person USING (personid)
WHERE country = 'Norway' AND parttype = 'director'
GROUP BY lastname, firstname
HAVING count(*) > 5;

#8
SELECT s.seriesid, s.maintitle, s.firstprodyear
FROM series AS s
WHERE s.firstprodyear IS NOT NULL
GROUP BY s.seriesid, s.maintitle, s.firstprodyear
ORDER BY s.firstprodyear DESC
LIMIT 50;

#9
SELECT avg(fr.rank)
FROM filmrating AS fr
WHERE fr.votes > 100000;

#10
SELECT f.title, fr.rank
FROM filmrating AS fr
  JOIN film AS f USING (filmid)
WHERE fr.votes > 100000 AND fr.rank >= (
  SELECT avg(fr.rank)
  FROM filmrating AS fr
  WHERE fr.votes > 100000
)
GROUP BY f.title, fr.rank;

#11
SELECT firstname, count(firstname) AS hyppigst
FROM person
WHERE firstname != ''
GROUP BY firstname
ORDER BY hyppigst DESC
LIMIT 100;

#12
WITH
  ant_fornavn AS (
    SELECT firstname AS fornavn, count(firstname) AS antall
    FROM person
    GROUP BY firstname
    HAVING count(firstname) > 6000
  )
SELECT A.fornavn, A.antall, B.fornavn, B.antall
FROM ant_fornavn AS A INNER JOIN ant_fornavn AS B
  ON A.fornavn != B.fornavn AND A.antall = B.antall;

#13
SELECT p.lastname || ', ' || p.firstname AS navn, count(filmid) AS regissert
FROM person AS p JOIN filmparticipation AS f USING (personid)
WHERE p.firstname = 'Tancred'
  AND p.lastname = 'Ibsen'
  AND f.parttype = 'director'
GROUP BY navn;

#14
SELECT filmid, title
FROM film
  JOIN filmcountry USING (filmid)
  JOIN filmparticipation USING (filmid)
WHERE parttype = 'director'
  AND country = 'Norway'
GROUP BY filmid, title
HAVING count(parttype) > 1;

#15
SELECT lastname || ', ' || firstname AS navn, count(*) AS antall
FROM person
  JOIN filmparticipation USING (personid)
  JOIN filmcountry USING (filmid)
  JOIN film USING (filmid)
WHERE country = 'Norway'
  AND parttype = 'director'
  AND filmid NOT IN (
        SELECT filmid
        FROM person
          JOIN filmparticipation USING (personid)
          JOIN filmcountry USING (filmid)
          JOIN film USING (filmid)
        WHERE country = 'Norway'
          AND parttype = 'director'
        GROUP BY filmid
        HAVING count(*) > 1
  )
GROUP BY navn
HAVING count(filmid) > 5
ORDER BY antall DESC;

#16
SELECT title, prodyear, filmtype
FROM film JOIN filmitem USING (filmid)
WHERE prodyear = 1893;

#17
SELECT lastname || ', ' || firstname AS navn
FROM film
  JOIN filmparticipation USING (filmid)
  JOIN person USING (personid)
WHERE title = 'Baile Perfumado'
  AND parttype = 'cast';

#18
SELECT title, prodyear
FROM film
  JOIN filmparticipation USING (filmid)
  JOIN person USING (personid)
WHERE firstname = 'Ingmar'
  AND lastname = 'Bergman'
  AND parttype = 'director'
ORDER BY prodyear DESC;

#19
WITH
  ingmarbergman AS (
    SELECT *
    FROM film
      JOIN filmparticipation USING (filmid)
      JOIN person USING (personid)
    WHERE firstname = 'Ingmar'
      AND lastname = 'Bergman'
      AND parttype = 'director'
  )
SELECT MIN(prodyear) AS forste_film, MAX(prodyear) AS siste_film
FROM ingmarbergman;


#20
SELECT title, prodyear, count(personid) AS deltatt
FROM film
  JOIN filmparticipation USING (filmid)
GROUP BY title, prodyear
HAVING count(DISTINCT personid) > 300
ORDER BY deltatt DESC;

#21
SELECT lastname || ', ' || firstname AS regissor, count(filmid) AS antall_filmer, MIN(prodyear), MAX(prodyear), MAX(prodyear) - MIN(prodyear) AS tidsperiode
FROM film
  JOIN filmparticipation USING (filmid)
  JOIN filmitem USING (filmid)
  JOIN person USING (personid)
WHERE parttype = 'director' AND filmtype = 'C' -- C står for Cinema, altså at det er en kinofilm
GROUP BY regissor, personid  -- Trenger å gruppere på personid i tillegg siden to regissører kan ha samme navn.
HAVING (MAX(prodyear) - MIN(prodyear) > 49)
ORDER BY tidsperiode DESC;

#22
WITH
  ingmarbergmanmovies AS (
    SELECT filmid
    FROM filmparticipation JOIN person USING (personid)
    WHERE firstname = 'Ingmar'
      AND lastname = 'Bergman'
      AND parttype = 'director'
  ),
  ant_regissorer AS (
    SELECT filmid, count(parttype) AS ant
    FROM filmparticipation
    WHERE filmid IN (SELECT * FROM ingmarbergmanmovies)
    AND parttype = 'director'
    GROUP BY filmid
  )
SELECT f.filmid, f.title, (ar.ant - 1) AS ant_medregissorer
FROM film AS f JOIN ant_regissorer AS ar USING (filmid);

#23
WITH
  ingmarbergmanmovies AS (
    SELECT filmid
    FROM filmparticipation JOIN person USING (personid)
    WHERE firstname = 'Ingmar'
      AND lastname = 'Bergman'
      AND parttype = 'director'
  ),
  crew AS (
    SELECT filmid, count(*) AS ant
    FROM filmparticipation AS fr
    WHERE filmid IN (SELECT * FROM ingmarbergmanmovies)
    GROUP BY filmid
  )

SELECT filmid, ant, prodyear, rank
FROM film
  JOIN crew USING (filmid)
  JOIN filmrating USING (filmid)
WHERE filmid IN (SELECT * FROM ingmarbergmanmovies)
ORDER BY prodyear ASC;

#24
SELECT f.title, f.prodyear
FROM film AS f
    JOIN filmparticipation AS fp USING (filmid)
    JOIN person AS p USING (personid)
WHERE p.firstname = 'Angelina' AND p.lastname = 'Jolie'
    AND fp.filmid IN (
        SELECT fp2.filmid
        FROM filmparticipation AS fp2 JOIN person AS p USING (personid)
        WHERE p.firstname = 'Antonio' AND p.lastname = 'Banderas'
    );

#25
SELECT f.title, p.lastname || ', ' || p.firstname AS navn, fp.parttype
FROM film as f
    JOIN filmparticipation AS fp USING (filmid)
    JOIN person AS p USING (personid)
    JOIN (
        SELECT fp.personid, fp.filmid
        FROM filmparticipation AS fp
            JOIN film AS f USING (filmid)
            JOIN filmitem AS fi USING (filmid)
         WHERE f.prodyear = 2003 AND fi.filmtype = 'C'
         GROUP BY fp.personid, fp.filmid
         HAVING count(parttype) > 1
    ) AS q ON q.filmid = fp.filmid AND q.personid = fp.personid
    ORDER BY navn ASC;

#26
SELECT p.lastname || ', ' || p.firstname AS navn, count(DISTINCT f.filmid) AS ant_filmer --Viktig å bruke DISTINCT slik at den ikke tar med filmid duplikater
FROM film AS f
    JOIN filmparticipation AS fp USING (filmid)
    JOIN person AS p USING (personid)
WHERE f.prodyear IN (2008,2009,2010) AND fp.personid NOT IN (
    SELECT personid
    FROM filmparticipation AS fp JOIN film AS f USING (filmid)
    WHERE f.prodyear = 2005
)
GROUP BY p.lastname, p.firstname
HAVING count(DISTINCT f.filmid) > 15;

#27
SELECT p.lastname || ', ' || p.firstname AS regissor, f.title
FROM film AS f
    JOIN filmparticipation AS fp USING (filmid)
    JOIN person AS p USING (personid)
WHERE fp.parttype = 'director'
    AND
        f.filmid IN (
            SELECT f.filmid
            FROM film AS f JOIN filmparticipation AS fp USING (filmid)
            GROUP BY f.filmid
            HAVING count(fp.personid) > 200
        )
    AND
        f.filmid NOT IN (
    SELECT f.filmid
    FROM film as f JOIN filmparticipation AS fp USING (filmid)
    WHERE fp.parttype = 'director'
    GROUP BY f.filmid
    HAVING count(fp.parttype) > 1
);
