SELECT b.navn, b.startet
FROM band AS b
WHERE b.navn LIKE "%King%" OR b.startet >= '2000-01-01'; -- Dette er litt utdatert måte å skrive dato på?
