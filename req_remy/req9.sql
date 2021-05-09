-- "Affiche les titres et les prix maximal atteint par les photographies 
-- dans toutes leur histoire sur le site."
SELECT title,
       max(h.digital_price) AS max_digital_price,
       max(h.print_price) AS max_print_price,
       max(h.digital_price) + max(h.print_price) AS sum_max_price
FROM photography p
JOIN pricehistory h ON p.pid = h.pid
GROUP BY title
ORDER BY max(h.digital_price) + max(h.print_price);
