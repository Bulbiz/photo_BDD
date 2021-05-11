-- Requête 3 : "Récupère les photographies ayant une note moyenne supérieure ou égale à 5."

SELECT pid AS photo_id,
       title,
       CAST(AVG(rate) AS DECIMAL(4, 2)) AS avg_rate
FROM photography
NATURAL JOIN photographycopy
NATURAL JOIN review
GROUP BY pid
HAVING AVG(rate) >= 5;
