-- Requête 12 : "Récupère les numéros de commandes pour lesquels tous les éléments ont été livrés."

SELECT DISTINCT cmd_id
FROM shoppingcartelem s1
WHERE cmd_id IS NOT NULL
  AND cmd_id NOT IN
    (-- "Commandes pour lesquels au moins un élément n'a pas encore été livré."
 SELECT cmd_id
     FROM shoppingcartelem s2
     WHERE s1.cmd_id = s2.cmd_id
       AND s2.status < 3);
