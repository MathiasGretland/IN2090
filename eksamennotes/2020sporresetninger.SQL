-- 2
SELECT b.navn, v.nedbør, v.vind
FROM by AS b
    JOIN land AS l USING (lid)
    JOIN værmelding AS v USING (bid)
WHERE l.navn = 'Italia'
    AND v.dato = '2020-12-17'
ORDER BY b.navn ASC;

-- 3
SELECT b.navn, sum(v.nedbør) AS sum_nedbør, avg(v.vind) AS avg_vind
FROM by AS b
    JOIN værmelding AS v USING (bid)
WHERE v.dato >= '2020-12-24' AND v.dato <= '2020-12-31'
GROUP BY b.navn;

-- 4
SELECT b.navn
FROM by AS b
    JOIN værmelding AS v USING (bid)
WHERE v.dato >= '2020-12-24' AND v.dato < '2021-01-01'
GROUP BY b.navn
HAVING count(v.nedbør) = 0 AND count(v.vind) = 0;

-- 5
CREATE VIEW
    Steder AS (
    SELECT b.navn, l.navn AS posisjon, v.nedbør, v.vind
    FROM land AS l
        JOIN by AS b USING (lid)
        JOIN værmelding AS v USING (bid)
    WHERE v.dato = current_date
    UNION ALL
    SELECT p.navn, p.adresse AS posisjon, v.nedbør, v.vind
    FROM poi AS p
        JOIN værmelding AS v USING (bid)
    WHERE v.dato = current_date AND p.adresse IS NOT NULL
);
-- 6
SELECT b.navn
FROM by AS b
    JOIN land AS l USING (lid)
    JOIN værmelding AS v USING (bid)
WHERE l.navn = 'Frankrike'
    AND v.dato = '2020-12-17'
    AND bid IN (
    SELECT p.bid
    FROM poi AS p
    WHERE p.type = 'Kafe'
    GROUP BY p.bid
    HAVING count(p.type) >= 3
) AND bid IN (
    SELECT p.bid
    FROM poi AS p
    WHERE p.type = 'Museer'
    GROUP BY p.bid
    ORDER BY p.type DESC
    LIMIT 1;
)
GROUP BY b.navn
HAVING count(v.nedbør) = 0;

-- løsningsforslaget

WITH
    opphold_og_kafeer AS (
        SELECT b.bid, b.navn
        FROM land AS l
            INNER JOIN by AS b USING (lid)
            INNER JOIN værmelding AS v USING (bid)
            INNER JOIN poi AS p USING (bid)
        WHERE l.navn = 'Frankrike' AND
            v.dato = '2020-12-17' AND
            v.nedbør = 0 AND
            p.type = 'Kafé'
        GROUP BY b.bid, b.navn
        HAVING count(*) >= 3
)
SELECT o.navn, count(*) AS antall_museer
FROM opphold_og_kafeer AS o
    INNER JOIN poi AS p USING (bid)
WHERE p.type = 'Museum'
GROUP BY o.bid, o.navn
ORDER BY antall_museer DESC
LIMIT 1;
