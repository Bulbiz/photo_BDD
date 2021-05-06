-- Requête 12 : "Récupère Les numéros de commandes pour lesquels tous les éléments ont été livrés."
-- -> Sous-requête dans le WHERE.

SELECT DISTINCT cmd_id
FROM shoppingcartelem s1
WHERE cmd_id in
    (-- Supprime les NULL.
 SELECT DISTINCT cmd_id
     FROM shoppingcartelem
     EXCEPT
       (-- "Commandes pour lesquels au moins un élément n'a pas encore été livré."
 SELECT DISTINCT cmd_id
        FROM shoppingcartelem s2
        WHERE s1.cmd_id = s2.cmd_id
          AND s2.status <> 3 ));
