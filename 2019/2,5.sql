SELECT b.bandID, b.navn, count(s.sangID) AS antall_sanger
FROM band AS b
    LEFT OUTER JOIN album AS a USING (albumID)
    LEFT OUTER JOIN sang AS s USING (albumID)
GROUP BY b.bandID, b.navn
HAVING antall_sanger < 3
