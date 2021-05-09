-- Requête 1 : "Récupère tous les commentaires concernant les photographies du photographe numéro 2"

SELECT photography.title,
       review_date,
       rate,
       remark
FROM photographer
NATURAL JOIN photography
NATURAL JOIN photographycopy
NATURAL JOIN review
WHERE photographer_id = 2;
