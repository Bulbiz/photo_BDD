-- Requête 13 : "Récupère la moyenne des prix des photographies de chaque photographe, à
--               condition qu'aucune de ses photographies n'a eu un prix inférieur à 70 euros."

SELECT pid,
       CAST(AVG(digital_price) AS DECIMAL(10,2)) AS Average_digital_price,
       CAST(AVG(print_price) AS DECIMAL(10,2)) AS Average_print_price
FROM pricehistory
GROUP BY pid
HAVING MIN(digital_price) > 70
OR MIN(print_price) > 70;
