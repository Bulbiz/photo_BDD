-- Requête 14 : "Récupère le numéro de commande ainsi que le statut de paiement de toutes
--               les commandes n'ayant pas encore quitté le dépôt."
-- -> LEFT JOIN + résultats différents en fonction des NULLs (voir req15.sql).

SELECT DISTINCT s.cmd_id,
                c.is_payed
FROM shoppingcartelem s
LEFT JOIN command c ON (s.cmd_id = c.cmd_id)
WHERE s.status < 2;
-- AND s.cmd_id is not  NULL; A rajouter pour supprimer les NULLs.
