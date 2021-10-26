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
