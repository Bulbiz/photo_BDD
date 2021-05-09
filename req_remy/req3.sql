-- "Affiche les photographies ayant une note moyenne suppérieur ou égale à 5"
-- -> Group by et Having
SELECT pid AS photo_id,
       title,
       cast(avg(rate) AS DECIMAL(4, 2)) AS avg_rate
FROM photography
NATURAL JOIN photographycopy
NATURAL JOIN review
GROUP BY pid
HAVING avg(rate) >= 5;
