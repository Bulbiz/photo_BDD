-- "Affiche les photographes ayant une note moyenne suppérieur à la moyenne"
-- -> Utilisation de deux aggrégations
SELECT firstname,
       lastname,
       avg(rate) AS avg_rate
FROM photographer artist
JOIN photography p ON artist.photographer_id = p.photographer_id
JOIN photographycopy pc ON p.pid = pc.pid
JOIN review ON pc.copy_id = review.copy_id
GROUP BY artist.photographer_id
HAVING avg(rate) >=
  (SELECT avg(rate)
   FROM review) ;
