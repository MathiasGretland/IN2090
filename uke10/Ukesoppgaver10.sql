#Vi bruker filmdatabasen

#For å komme inn på filmdatabasen

ssh mathige@login.ifi.uio.no

psql -h dbpg-ifi-kurs01 -U mathige -d fdb

#COPY PASTE I GITBASH ER SLIK: SHIFT + INS

#1
SELECT p.personid, p.firstname, p.lastname, count(f.personid)
FROM person AS p LEFT OUTER JOIN filmparticipation AS f USING (personid)
WHERE p.lastname = 'Abbott'
GROUP BY p.firstname, p.lastname, p.personid;

#2
#a)
SELECT title
FROM film AS f INNER JOIN filmgenre AS g USING (filmid)
WHERE f.filmid NOT IN (SELECT filmid FROM filmrating)
  AND g.genre = 'Western'
  AND f.prodyear > 2007;


#b)
SELECT f.title
FROM filmgenre AS fg LEFT OUTER JOIN film AS f USING (filmid)
WHERE fg.genre = 'Western'
GROUP BY f.title, f.prodyear
HAVING f.prodyear > 2007;

#c)
SELECT title
FROM film
WHERE prodyear > 2007
    AND filmid IN (
        (SELECT filmid
        FROM filmgenre
        WHERE genre = 'Western')
        EXCEPT
        (SELECT filmid
        FROM filmrating)
    );

#d) THIS IS WHAT WE CALL AN EPIC VICTORY ROYALE TEAM
SELECT f.title
FROM film AS f
    JOIN filmgenre AS fg USING (filmid)
WHERE f.prodyear > 2007
    AND fg.genre = 'Western'
    AND NOT EXISTS (
        SELECT *
        FROM filmrating AS fr
        WHERE f.filmid = fr.filmid
    );
