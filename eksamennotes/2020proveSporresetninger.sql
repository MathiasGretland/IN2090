-- 5
UPDATE barn
SET snill = false
WHERE bid = 0;

-- 6
SELECT b.navn, g.navn
FROM barn AS b
    JOIN ønskeliste AS ø ON (b.bid = ø.barn)
    JOIN gave AS b USING (ø.gave = g.gid)
WHERE g.navn LIKE 'Sokker%' AND g.nyttig;

-- 7
CREATE VIEW
    oversikt AS (
        SELECT b.bid, b.navn AS barn, g.gid, g.navn AS gave, b.snill, g.nyttig
        FROM barn AS b
            JOIN ønskeliste AS ø ON (b.bid = ø.barn)
            JOIN gave AS b USING (ø.gave = g.gid)
        ORDER BY barn, gave;
    )

-- 8
WITH
    likt_ønske AS (
        SELECT b1.barn AS barn1, b2.barn AS barn2
        FROM ønskeliste AS b1
            JOIN ønskeliste AS b2 USING (gave)
        WHERE b1.barn != b2.barn
    )
SELECT DISTINCT b1.navn, b2.navn
FROM likt_ønske AS l
    JOIN barn as b1 ON (l.barn1 = b1.bid)
    JOIN barn AS b2 ON (l.barn2 = b2.bid)

-- 9
SELECT gave, count(*) AS antall_ønsker, true AS nyttig
FROM oversikt
WHERE nyttig
GROUP BY gave
ORDER BY antall_ønsker DESC
LIMIT 3
UNION
SELECT gave, count(*) as antall_ønsker, false AS nyttig
FROM oversikt
WHERE NOT nyttig
GROUP BY gave
ORDER BY antall_ønsker DESC
LIMIT 3;
