-- Requête 16 : "Récupère le titre des photographies qui ont eu au moins trois changements de prix."

SELECT p.pid,
       title
FROM pricehistory h
JOIN photography p ON p.pid = h.pid
GROUP BY p.pid
HAVING COUNT(p.pid) >= 3;
