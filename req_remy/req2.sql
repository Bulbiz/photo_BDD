-- "Calcule la moyenne des montants des éléments physique des paniers commandés 
-- (si ils étaient acheter aujourd'hui)"
-- -> Sous Requête dans le from + Utilisation de deux aggrégations
SELECT avg(montant_commande.montant_physique) AS avg_amount_cmd
FROM
  --Liste les montants des différents panier physique commandé
  (SELECT sum(p.print_price) AS montant_physique
   FROM shoppingcartelem s
   JOIN photographycopy pc ON s.copy_id = pc.copy_id
   JOIN photography p ON pc.pid = p.pid
   WHERE s.status >= 0 AND pc.photo_type = 0
   GROUP BY s.cmd_id) AS montant_commande;


/* BONUS : Requête pour avoir le montant moyen des paniers commandés (print et digital combiné)*/
/*
WITH 
  physique (cmd_id,somme) AS (
    SELECT s.cmd_id,sum(p.print_price) AS montant_physique
    FROM shoppingcartelem s
    JOIN photographycopy pc ON s.copy_id = pc.copy_id
    JOIN photography p ON pc.pid = p.pid
    WHERE s.status >= 0 AND pc.photo_type = 0
    GROUP BY s.cmd_id
  ),

  digital (cmd_id, somme) AS (
    SELECT s.cmd_id,sum(p.digital_price) AS montant_digital
    FROM shoppingcartelem s
    JOIN photographycopy pc ON s.copy_id = pc.copy_id
    JOIN photography p ON pc.pid = p.pid
    WHERE s.status >= 0 AND pc.photo_type = 1
    GROUP BY s.cmd_id
  ),

  combined (cmd_id, somme) AS (
    SELECT p.cmd_id, p.somme + d.somme AS montant
    FROM physique p JOIN digital d ON p.cmd_id = d.cmd_id 
  )

SELECT avg(combined.somme) AS montant_moyen FROM combined;
*/