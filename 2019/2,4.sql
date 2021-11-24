SELECT navn
FROM person
WHERE født IN (SELECT startet
    FROM band
    UNION
    SELECT utgitt
    FROM album);


SELECT navn
FROM person
WHERE født IN (
    SELECT startet
    FROM band)
    OR født IN (SELECT utgitt
    FROM album);






SELECT p.navn
FROM person AS p
    INNER JOIN band AS b ON (p.født = b.startet)
UNION
SELECT p.navn
FROM person AS p
    INNER JOIN album AS a ON (p.født = a.utgitt );
