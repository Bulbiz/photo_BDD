-- "Affiche tout les commentaires concernant les photographie du photographe numéro 2"
-- -> Requête sur au moins 3 tables
SELECT photography.title,
       review_date,
       rate,
       remark
FROM photographer
NATURAL JOIN photography
NATURAL JOIN photographycopy
NATURAL JOIN review
WHERE photographer_id = 2;
