-- Requête 5 : "Récupère les clients ayant commandés toutes les photographies du photographe 9."
-- -> Requête de totalité (Aggrégation).

-- Récupère toutes les photographie du photographe 9
WITH photo_from_photographer_9 (pid) AS
  (SELECT pid
   FROM photography p
   WHERE p.photographer_id = 9)
SELECT cmd.email
FROM command cmd
JOIN shoppingcartelem s ON cmd.cmd_id = s.cmd_id
JOIN photographycopy pc ON s.copy_id = pc.copy_id
JOIN photography p ON pc.pid = p.pid

-- Garde uniquement les commandes possèdant une photogrphie du photographe 9.
WHERE p.pid in
    (SELECT pid
     FROM photo_from_photographer_9)
GROUP BY cmd.email

-- Vérifie que le client les a toutes commandées au moins une fois.
HAVING COUNT(DISTINCT p.pid) =
  (SELECT COUNT(DISTINCT pid)
   FROM photo_from_photographer_9);
