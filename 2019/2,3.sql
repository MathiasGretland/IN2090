SELECT sum(s.spilletid)/3600.0 AS antall_timer
FROM band AS b
    JOIN sjanger AS sj USING (sjangerID)
    JOIN album AS al USING (albumID)
    JOIN sang AS s USING (albumID)
WHERE b.sjangerID = 0
    AND b.startet >= '1990-01-01'
    AND b.startet < '2000-01-01';
