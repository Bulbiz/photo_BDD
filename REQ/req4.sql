--  Requête 4 : "Récupère le nom des photographes ayant une note de review
--               moyenne pour ses photographies supérieures à la moyenne de toutes les notes
--               de review."

SELECT CONCAT(firstname, ' ', lastname) as photographe_name,
       CAST(AVG(r1.rate) AS DECIMAL(4, 2)) AS avg_rate
FROM photographer artist
JOIN photography p ON artist.photographer_id = p.photographer_id
JOIN photographycopy pc ON p.pid = pc.pid
JOIN review r1 ON pc.copy_id = r1.copy_id
GROUP BY artist.photographer_id
HAVING AVG(r1.rate) >=
  (SELECT AVG(r2.rate)
   FROM review r2);
