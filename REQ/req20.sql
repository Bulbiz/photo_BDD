-- Requête 20 : "Récupère les copies de photographies apparaissant dans plusieurs commandes différentes et qui n'ont jamais été retournés."

SELECT DISTINCT s1.copy_id
FROM shoppingcartelem s1,
     shoppingcartelem s2
WHERE s1.cmd_id <> s2.cmd_id
  AND s1.copy_id = s2.copy_id
EXCEPT
SELECT copy_id
FROM return_product rp
JOIN shoppingcartelem s ON rp.elem_id = s.elem_id;
