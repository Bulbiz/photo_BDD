-- Requête 17 : "Récupère les photographies classifiées en fonction du ratio de
--               la quantité de copies copies imprimables disponibles sur le nombre de copies
--               actuellement commandées (risque de rupture de stock). "

SELECT pid,
       CASE
           WHEN sum(c.quantity) / sum(s.quantity) > 100 THEN 'low'
           WHEN sum(c.quantity) / sum(s.quantity) > 10 THEN 'normal'
           ELSE 'high'
       END AS risk_of_stockout
FROM shoppingcartelem s
JOIN photographycopy c ON s.copy_id = c.copy_id
WHERE c.photo_type = 0
GROUP BY pid
ORDER BY risk_of_stockout,
         pid;
