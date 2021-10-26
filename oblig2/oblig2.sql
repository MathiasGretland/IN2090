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
Det er fordi når det brukes NATURAL JOIN så vil den kun telle de som er identiske,
i dette tilfellet vil det være den som har timelistenr 2, fordi den fra timeliste er en delrelasjon av den
fra timelistelinje. Altså all informasjon fra timeliste raden hvor timelistenr er 2, eksisterer helt ekstakt likt i timelistelinje.

I den andre spørresetningen så bruker de INNER JOIN, som velger ut de som har samme verdi i begge tabeller.
siden timelistenr i timeliste inneholder alle tall fra 1 opp til 8, og timelistenr i timelistelinje inneholder alle tall fra 1 til 7
vil alle radene i timelistelinje bli valgt.

b)
I den første spørresetningen mellom timeliste og varighet, så er det viktig å se at den eneste klonnen som har likt navn er
timelistenr, og vi vet at timelistenr i timeliste inneholder alle tall fra 1 opp til 8, og varighet sin er akkurat som timelistelinje sin
hvor alle tall fra 1 til 7, så vil alle radene fra varighet være med.

Den andre spørresetningen er akkurat som spørresetningen i oppgave 1, hvor de bruker INNER JOIN, som velger ut de som har samme verdi i begge tabeller.
siden timelistenr i timeliste inneholder alle tall fra 1 opp til 8, og timelistenr i varighet inneholder alle tall fra 1 til 7
vil alle radene i timelistelinje bli valgt.
*/
