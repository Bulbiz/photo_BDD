-- Requête 18 : "Récupère les 5 titres des photographies dont leur copies on été les dernières à être envoyées."

SELECT title,
       shipping_date
FROM shoppingcartelem s
JOIN photographycopy pc ON s.copy_id = pc.copy_id
JOIN photography p ON p.pid = pc.pid
WHERE s.cmd_id is not null
ORDER BY shipping_date DESC NULLS LAST
LIMIT 5;
