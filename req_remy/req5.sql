-- "Les clients ayant commandé toutes les photographies du photographe 9"
-- -> Requête de totalité (Aggrégation)

--Liste toutes les photographie du photographe 9
WITH photography_photographer (pid) AS
  (SELECT pid 
   FROM photography p
   WHERE p.photographer_id = 9 )

SELECT cmd.email
FROM command cmd
JOIN shoppingcartelem s ON cmd.cmd_id = s.cmd_id
JOIN photographycopy pc ON s.copy_id = pc.copy_id
JOIN photography p ON pc.pid = p.pid 

-- Filtre les commandes ne contenant pas de photographie du photographe 9
WHERE p.pid in (SELECT pid FROM photography_photographer)

GROUP BY cmd.email
HAVING count(DISTINCT p.pid) = 
  (SELECT count(DISTINCT pid) FROM photography_photographer) ;