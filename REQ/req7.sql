-- Requête 7 : "Récupère le nom du photographe avec le plus d'article dans un panier,
--              c'est-à-dire le ou la plus populaire."
SELECT CONCAT(firstname, ' ', lastname) as photographe_name,
       COUNT(s.elem_id) AS number_of_command
FROM shoppingcartelem s
JOIN photographycopy pc ON s.copy_id = pc.copy_id
JOIN photography photo ON pc.pid = photo.pid
JOIN photographer artist ON photo.photographer_id = artist.photographer_id
GROUP BY firstname,
         lastname,
         artist.photographer_id
ORDER BY number_of_command DESC
LIMIT 1;
