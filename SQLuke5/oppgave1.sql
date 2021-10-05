#For å komme inn på filmdatabasen

ssh mathige@login.ifi.uio.no

psql -h dbpg-ifi-kurs01 -U mathige -d fdb

#COPY PASTE I GITBASH ER SLIK: SHIFT + INS
#1
SELECT *
FROM genre;

#2
SELECT f.filmid, f.title
FROM film AS f
WHERE f.prodyear = 1892;

#3
SELECT f.filmid, f.title
FROM film AS f
WHERE (f.filmid >= 2000 AND f.filmid <= 2030);

#4
SELECT f.filmid, f.title
FROM film AS f
WHERE f.title LIKE '%Star Wars%';

#5
SELECT p.firstname, p.lastname
FROM person AS p
WHERE p.personid = 465221;

#6
SELECT DISTINCT f.parttype
FROM filmparticipation AS f

#7
SELECT f.title, f.prodyear
FROM film AS f
WHERE f.title LIKE '%Rush Hour%';

#8
SELECT f.filmid, f.title, f.prodyear
FROM film AS f
WHERE f.title LIKE '%Norge%';

#9
SELECT f.filmid
FROM film AS f, filmitem AS i
WHERE f.title = 'Love' AND i.filmtype = 'C';
