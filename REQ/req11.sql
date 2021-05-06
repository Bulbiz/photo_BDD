-- Requête 11 : "Récupère les départements contenant plusieurs adresses différentes".
-- -> Auto jointure + GROUP BY

SELECT a1.departement
FROM address a1,
     address a2
WHERE a1.aid <> a2.aid
  AND a1.departement = a2.departement
GROUP BY a1.departement;
