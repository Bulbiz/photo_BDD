-- Requête 13 : "Récupère la moyenne des prix des photographies de chaque photographe, à
--               condition qu'aucune de ses photographies n'a eu un prix inférieur à 70 euros."
-- -> GROUP BY + HAVING

SELECT pid,
       avg(digital_price) AS Average_digital_price,
       avg(print_price) AS Average_print_price
FROM pricehistory
GROUP BY pid
HAVING min(digital_price) > 70
OR min(print_price) > 70;
