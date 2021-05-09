-- "Affiche le/la photographe avec le plus d'article commandé/dans un panier effectué 
-- (autrement dit la plus populaire)"
SELECT firstname,
       lastname,
       count(s.elem_id) AS number_of_command
FROM shoppingcartelem s
JOIN photographycopy pc ON s.copy_id = pc.copy_id
JOIN photography photo ON pc.pid = photo.pid
JOIN photographer artist ON photo.photographer_id = artist.photographer_id
GROUP BY firstname,
         lastname,
         artist.photographer_id
ORDER BY number_of_command DESC
LIMIT 1 ;

