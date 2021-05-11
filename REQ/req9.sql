-- Requête 9 : "Récupère les titres et les prix maximaux atteint par chaque photographie."

SELECT title,
       MAX(h.digital_price) AS max_digital_price,
       MAX(h.print_price) AS max_print_price
FROM photography p
JOIN pricehistory h ON p.pid = h.pid
GROUP BY p.pid
ORDER BY MAX(h.digital_price) + MAX(h.print_price);
