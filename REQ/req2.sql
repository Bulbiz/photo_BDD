-- Requête 2 : "Récupère la moyenne des prix totaux de chaque copie imprimable
--              pour chaque panier commandé."

SELECT AVG(cmd_print_price_sums.print_price_sum) AS avg_amount_cmd
FROM
  (SELECT SUM(p.print_price * s.quantity) AS print_price_sum
   FROM shoppingcartelem s
   JOIN photographycopy pc ON s.copy_id = pc.copy_id
   JOIN photography p ON pc.pid = p.pid
   WHERE s.status >= 0 AND pc.photo_type = 0
   GROUP BY s.cmd_id) AS cmd_print_price_sums;
