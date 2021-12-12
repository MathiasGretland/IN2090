-- 2.2
SELECT b.navn, b.startet
FROM Band as b
WHERE b.navn LIKE '%King%' OR b.startet >= '2000-01-01';

-- 2.3
SELECT SUM(s.spilletid)/3600 AS timer
FROM Band AS b
    JOIN Sjanger AS sj USING (sjangerID)
    JOIN Album AS a USING (bandID)
    JOIN Sang AS s USING (albumID)
WHERE b.startet >= '1990-01-01'
    AND b.startet <= '2000-01-01'
    AND sj.navn = 'Pop';

-- 2.4
SELECT navn
FROM Person
WHERE født IN
    (SELECT startet
    FROM Band
    UNION
    SELECT utgitt
    FROM Album);

-- 2.5
SELECT b.bandID 
