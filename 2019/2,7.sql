CREATE VIEW nyeste_album(navn, b.navn, a.utgitt, antall_sanger) AS
SELECT a.navn, b.navn, a.utgitt, antall_sanger
