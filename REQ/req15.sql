-- Requête 15 : "Récupère le numéro de commande ainsi que le statut de paiement de toutes
--               les commandes n'ayant pas encore quittées le dépôt."
-- -> RIGHT JOIN + résultats différents en fonction des NULLs (voir req14.sql).

SELECT DISTINCT s.cmd_id,
                c.is_payed
FROM shoppingcartelem s
RIGHT JOIN command c ON (s.cmd_id = c.cmd_id)
WHERE s.status < 2;
