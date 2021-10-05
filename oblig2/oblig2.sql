#Oppgave 2
#a)
SELECT *
FROM timelistelinje AS t
WHERE t.timelistenr = 3;

#b)
SELECT count(*)
FROM timeliste;

#c)
SELECT count(*)
FROM timeliste AS t
WHERE t.status != 'utbetalt';

#d)
SELECT (SELECT count(*) FROM timelistelinje) AS antall,(SELECT count(pause) FROM timelistelinje) AS antallmedpause;

#e)
SELECT *
FROM timelistelinje AS t
WHERE t.pause IS NULL;

#Oppgave 3
#a)
SELECT sum(v.varighet/60) AS antalltimer
FROM varighet AS v INNER JOIN timeliste as t ON (v.timelistenr = t.timelistenr) WHERE t.status = 'utbetalt';

#b)
SELECT DISTINCT t.timelistenr, t.beskrivelse
FROM timeliste AS t
WHERE t.beskrivelse LIKE '%test%' OR t.beskrivelse LIKE '%Test%';

#c)
SELECT sum((v.varighet/60)*200) AS pengerutbetalt
FROM varighet AS v INNER JOIN timeliste as t ON (v.timelistenr = t.timelistenr) WHERE t.status = 'utbetalt';


#Oppgave 4
/*
a)



*/
