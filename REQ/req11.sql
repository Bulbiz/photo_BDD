-- Requête 11 : "Récupère les villes contenant plusieurs adresses différentes".

SELECT a1.city
FROM address a1,
     address a2
WHERE a1.aid <> a2.aid
  AND a1.city = a2.city
GROUP BY a1.city;
