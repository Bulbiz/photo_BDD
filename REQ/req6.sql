-- Requête 6 : "Récupère les clients ayant commandés toutes les photographies du photographe 9."
-- -> Requête de totalité (Sous-requêtes corrélées)

SELECT DISTINCT cmd.email
FROM command cmd
WHERE NOT EXISTS
    -- Récupère les photographies du photographe 9 qui n'ont pas été commandées par le client.
    (SELECT p.pid
     FROM photography p
     WHERE p.photographer_id = 9
     EXCEPT
      -- Récupère les photographies commandées par le client.
       (SELECT pc.pid
        FROM command cmd2
        JOIN shoppingcartelem s ON cmd2.cmd_id = s.cmd_id
        JOIN photographycopy pc ON pc.copy_id = s.copy_id
        WHERE cmd2.email = cmd.email));
