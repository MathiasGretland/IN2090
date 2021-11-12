-- Oppgave 1
SELECT filmcharacter, count(filmcharacter) AS antall_forekomster
FROM filmcharacter
GROUP BY filmcharacter
HAVING count(filmcharacter) > 2000
ORDER BY antall_forekomster DESC;

-- Oppgave 2
SELECT country
FROM filmcountry
GROUP BY country
HAVING count(country) = 1;

-- Oppgave 3
SELECT f.title, fp.parttype, count(fp.parttype) AS ant_deltagere
FROM film AS f
  JOIN filmitem AS fi USING (filmid)
  JOIN filmparticipation AS fp USING (filmid)
WHERE f.title LIKE '%Lord of the Rings%'
  AND fi.filmtype = 'C'
GROUP BY f.title, fp.parttype;

-- Oppgave 4
(SELECT title, prodyear
    FROM film JOIN filmgenre USING (filmid)
    WHERE genre = 'Film-Noir')
INTERSECT
(SELECT title, prodyear
    FROM film JOIN filmgenre USING (filmid)
    WHERE genre = 'Comedy');

-- Oppgave 5
WITH
  hoyest AS (
    SELECT MAX(rank)
    FROM filmrating
    WHERE votes > 1000
  )
SELECT s.maintitle
FROM series AS s
    JOIN filmrating AS f ON (s.seriesid = f.filmid)
WHERE f.votes > 1000 AND f.rank IN (SELECT * FROM hoyest)
GROUP BY s.maintitle;

-- Oppgave 6
WITH
  mrbeanfilms AS (
    SELECT filmid
    FROM filmparticipation
      JOIN filmcharacter USING (partid)
      WHERE filmcharacter = 'Mr. Bean'
  )
SELECT f.title, count(fl.language) AS ant_spraak
FROM film AS f
  JOIN mrbeanfilms AS mbf USING (filmid)
  LEFT OUTER JOIN filmlanguage AS fl USING (filmid) -- Bruker LEFT OUTER JOIN for å få med filmer uten språk
GROUP BY f.title;

-- Oppgave 7
SELECT p.lastname || ', ' || p.firstname AS skuespiller, count(filmid) AS antall_filmer
FROM (SELECT DISTINCT filmcharacter FROM filmcharacter GROUP BY filmcharacter HAVING count(filmcharacter) = 1) AS unik -- Finner unike
  JOIN filmcharacter AS fc USING (filmcharacter) --Må da bruke JOIN på filmcharacter for å få med partid
  JOIN filmparticipation AS fp USING (partid)
  JOIN person AS p USING (personid)
GROUP BY p.lastname, p.firstname
HAVING count(filmid) > 199;
