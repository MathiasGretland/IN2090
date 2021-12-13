-- 2.2
SELECT navn, startet
FROM band
WHERE startet >= '2020-01-01'
UNION
SELECT navn, startet
FROM band
WHERE navn LIKE '%King%';

-- 2.3
SELECT b.navn, sum(s.spilletid)/3600 AS antall_timer
FROM band AS b
    JOIN album AS a USING (bandID)
    JOIN sang AS s USING (albumID)
    JOIN sjanger AS sj USING (sjangerID)
WHERE sj.navn = 'Pop'
    AND b.startet >= '1990-01-01'
    AND b.startet < '2000-01-01'

-- 2.4
SELECT navn
FROM person
WHERE født IN (
    SELECT startet
    FROM band
)  OR født IN (
    SELECT utgitt
    FROM album
);

-- 2.5
SELECT b.bandID, b.navn, count(s.sangID) AS antall_sanger
FROM band AS b
    LEFT OUTER JOIN album AS a USING (bandID)
    LEFT OUTER JOIN sang AS s USING (sangID)
GROUP BY b.bandID, b.navn
HAVING count(s.sangID) < 3;

-- 2.6
DELETE FROM
    album
    WHERE albumID NOT IN (
        SELECT albumID FROM sang
    );

-- 2.7
CREATE VIEW
    nyeste_album AS (
        SELECT a.navn, b.navn, b.startet, count(s.sangID) AS antall_sanger
        FROM album AS a
            JOIN band AS b USING (albumID)
            JOIN sang AS s USING (albumID)
        GROUP BY a.albumID, a.navn, b.navn, b.startet
        ORDER BY a.utgitt DESC
        LIMIT 10;
    );

-- 2.8
WITH
    superAlbum AS (
        SELECT albumID
        FROM sang
        GROUP BY albumID
        HAVING sum(spilletid) > 3600
    )
SELECT b.bandID, b.navn, count(sa.bandID) AS antall_superAlbum
FROM superAlbum AS sa
    JOIN album AS a USING (bandID)
    JOIN band AS b USING (albumID)
GROUP BY b.bandID, b.navn;
