-- Requête 1 : "Récupère le prix d'achat de tous les éléments d'une commande."

CREATE OR REPLACE FUNCTION get_puchase_price_of_cmd(INT)
RETURNS TABLE(elem_id INT, print_price INT, digital_price INT, copy_id INT, change_date TIMESTAMP)
AS $func$
  DECLARE
    elem_id INT;
    rec RECORD;
  BEGIN
    FOR elem_id IN
      -- Récupère tous les éléments de la commande.
      SELECT DISTINCT s.elem_id
      FROM shoppingcartelem s
      WHERE s.cmd_id = $1
    LOOP
      RETURN QUERY EXECUTE
        -- Pour chaque éléments,
        -- récupère le dernier changement de prix avant la date de commande.
        'SELECT DISTINCT s.elem_id,
                  h.print_price,
                  h.digital_price,
                  s.copy_id,
                  h.change_date
        FROM command c
        JOIN shoppingcartelem s ON (c.cmd_id = '|| $1 || '
                                    AND s.cmd_id = c.cmd_id)
        JOIN photographycopy pc ON pc.copy_id = s.copy_id
        JOIN pricehistory h ON h.pid = pc.pid
        WHERE c.command_date > h.change_date
          AND s.elem_id = ' || elem_id || '
        ORDER BY h.change_date DESC
        LIMIT 1';
    END LOOP;
  END
$func$ LANGUAGE PLPGSQL;

-- Pour chaque éléments de la commande affiche son prix d'achat en fonction du type
-- de la copie.
SELECT res.elem_id,
       CASE
            (SELECT photo_type
             FROM photographycopy
             WHERE copy_id = res.copy_id)
           WHEN 1 THEN res.print_price
           ELSE res.digital_price
       END AS purchase_price
FROM get_puchase_price_of_cmd(7) res -- Récupère les prix d'achats des éléments de la commande 7.
ORDER BY res.elem_id;

-- Requête 2 : "Récupère la moyenne des prix totaux de chaque copie imprimable
--              pour chaque panier commandé."

SELECT AVG(cmd_print_price_sums.print_price_sum) AS avg_amount_cmd
FROM
  (SELECT SUM(p.print_price * s.quantity) AS print_price_sum
   FROM shoppingcartelem s
   JOIN photographycopy pc ON s.copy_id = pc.copy_id
   JOIN photography p ON pc.pid = p.pid
   WHERE s.status >= 0 AND pc.photo_type = 0
   GROUP BY s.cmd_id) AS cmd_print_price_sums;


-- Requête 3 : "Récupère les photographies ayant une note moyenne supérieure ou égale à 5."

SELECT pid AS photo_id,
       title,
       CAST(AVG(rate) AS DECIMAL(4, 2)) AS avg_rate
FROM photography
NATURAL JOIN photographycopy
NATURAL JOIN review
GROUP BY pid
HAVING AVG(rate) >= 5;

--  Requête 4 : "Récupère le nom des photographes ayant une note de review
--               moyenne pour ses photographies supérieures à la moyenne de toutes les notes
--               de review."

SELECT CONCAT(firstname, ' ', lastname) as photographe_name,
       CAST(AVG(r1.rate) AS DECIMAL(4, 2)) AS avg_rate
FROM photographer artist
JOIN photography p ON artist.photographer_id = p.photographer_id
JOIN photographycopy pc ON p.pid = pc.pid
JOIN review r1 ON pc.copy_id = r1.copy_id
GROUP BY artist.photographer_id
HAVING AVG(r1.rate) >=
  (SELECT AVG(r2.rate)
   FROM review r2);

-- Requête 5 : "Récupère les client-e-s ayant commandé toutes les photographies du photographe 9."
-- -> Requête de totalité (Agrégation).

-- Récupère toutes les photographies du photographe 9
WITH photo_from_photographer_9 (pid) AS
  (SELECT pid
   FROM photography p
   WHERE p.photographer_id = 9)

SELECT cmd.email
FROM command cmd
JOIN shoppingcartelem s ON cmd.cmd_id = s.cmd_id
JOIN photographycopy pc ON s.copy_id = pc.copy_id
JOIN photography p ON pc.pid = p.pid

-- Garde uniquement les commandes possédant une photographie du photographe 9.
WHERE p.pid in
    (SELECT pid
     FROM photo_from_photographer_9)
GROUP BY cmd.email

-- Vérifie que le client ou la cliente les a toutes commandées au moins une fois.
HAVING COUNT(DISTINCT p.pid) =
  (SELECT COUNT(DISTINCT pid)
   FROM photo_from_photographer_9);


-- Requête 6 : "Récupère les client-e-s ayant commandé-e-s toutes les photographies du photographe 9."
-- -> Requête de totalité (Sous requêtes corrélées)

SELECT DISTINCT cmd.email
FROM command cmd
WHERE NOT EXISTS
    -- Récupère les photographies du photographe 9 qui n'ont pas été commandées
    -- par le client ou la cliente.
    (SELECT p.pid
     FROM photography p
     WHERE p.photographer_id = 9
     EXCEPT
      -- Récupère les photographies commandées par le client ou la cliente.
       (SELECT pc.pid
        FROM command cmd2
        JOIN shoppingcartelem s ON cmd2.cmd_id = s.cmd_id
        JOIN photographycopy pc ON pc.copy_id = s.copy_id
        WHERE cmd2.email = cmd.email));


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


-- Requête 8 : "Récupère tou-te-s les client-e-s habitant à Hollywood ainsi que leur nombre de commande."

SELECT client.email,
       client.firstname,
       client.lastname,
       COUNT(command.cmd_id) AS number_of_command
FROM command
JOIN client ON command.email = client.email
JOIN address ON client.address = address.aid
WHERE address.city='Hollywood'
GROUP BY client.email,
         client.firstname,
         client.lastname;


-- Requête 9 : "Récupère les titres et les prix maximaux atteint par chaque photographie."

SELECT title,
       MAX(h.digital_price) AS max_digital_price,
       MAX(h.print_price) AS max_print_price
FROM photography p
JOIN pricehistory h ON p.pid = h.pid
GROUP BY p.pid
ORDER BY MAX(h.digital_price) + MAX(h.print_price);


-- Requête 10 : "Récupère le client ou la cliente ayant fait le plus de commande sur le site."

SELECT clt.firstname,
       clt.lastname,
       COUNT(cmd.email) AS number_of_command
FROM command cmd
JOIN client clt ON cmd.email = clt.email
GROUP BY clt.firstname,
  reqme
ORDER BY number_of_command DESC
LIMIT 1;


-- Requête 11 : "Récupère les villes contenant plusieurs adresses différentes".

SELECT a1.city
FROM address a1,
     address a2
WHERE a1.aid <> a2.aid
  AND a1.city = a2.city
GROUP BY a1.city;


-- Requête 12 : "Récupère les numéros de commandes pour lesquels tous les éléments ont été livrés."

SELECT DISTINCT cmd_id
FROM shoppingcartelem s1
WHERE cmd_id IS NOT NULL
  AND cmd_id NOT IN
    (-- "Commandes pour lesquels au moins un élément n'a pas encore été livré."
 SELECT cmd_id
     FROM shoppingcartelem s2
     WHERE s1.cmd_id = s2.cmd_id
       AND s2.status < 3);


-- Requête 13 : "Récupère la moyenne des prix des photographies de chaque photographe, à
--               condition qu'aucune de ses photographies n'a eu un prix inférieur à 70 euros."

SELECT pid,
       CAST(AVG(digital_price) AS DECIMAL(10,2)) AS Average_digital_price,
       CAST(AVG(print_price) AS DECIMAL(10,2)) AS Average_print_price
FROM pricehistory
GROUP BY pid
HAVING MIN(digital_price) > 70
OR MIN(print_price) > 70;


-- Requête 14 : "Récupère le numéro de commande ainsi que le statut de paiement de toutes
--               les commandes n'ayant pas encore quittées le dépôt."
-- -> LEFT JOIN + résultats différents en fonction des NULLs (voir req15.sql).

SELECT DISTINCT s.cmd_id,
                c.is_payed
FROM shoppingcartelem s
LEFT JOIN command c ON (s.cmd_id = c.cmd_id)
WHERE s.status < 2;
-- AND s.cmd_id is not  NULL; A rajouter pour supprimer les NULLs.


-- Requête 15 : "Récupère le numéro de commande ainsi que le statut de paiement de toutes
--               les commandes n'ayant pas encore quittées le dépôt."
-- -> RIGHT JOIN + résultats différents en fonction des NULLs (voir req14.sql).

SELECT DISTINCT s.cmd_id,
                c.is_payed
FROM shoppingcartelem s
RIGHT JOIN command c ON (s.cmd_id = c.cmd_id)
WHERE s.status < 2;


-- Requête 16 : "Récupère le titre des photographies qui ont eu au moins trois changements de prix."

SELECT p.pid,
       title
FROM pricehistory h
JOIN photography p ON p.pid = h.pid
GROUP BY p.pid
HAVING COUNT(p.pid) >= 3;


-- Requête 17 : "Récupère les photographies classifiées en fonction du ratio de
--               la quantité de copies copies imprimables disponibles sur le nombre de copies
--               actuellement commandées (risque de rupture de stock). "

SELECT pid,
       CASE
           WHEN sum(c.quantity) / sum(s.quantity) > 10 THEN 'low'
           WHEN sum(c.quantity) / sum(s.quantity) > 1 THEN 'normal'
           ELSE 'high'
       END AS risk_of_stockout
FROM shoppingcartelem s
JOIN photographycopy c ON s.copy_id = c.copy_id
WHERE c.photo_type = 0
GROUP BY pid
ORDER BY sum(c.quantity) / sum(s.quantity);


-- Requête 18 : "Récupère les 5 titres des photographies dont leurs copies ont été les dernières à être envoyées."

SELECT title,
       shipping_date
FROM shoppingcartelem s
JOIN photographycopy pc ON s.copy_id = pc.copy_id
JOIN photography p ON p.pid = pc.pid
WHERE s.cmd_id is not null
ORDER BY shipping_date DESC NULLS LAST
LIMIT 5;


-- Requête 19 : "Récupère le nom de tous les photographes n'ayant reçu aucune review inférieur à 5."

SELECT DISTINCT CONCAT(pher.firstname, ' ', pher.lastname) AS photographer_name
FROM photographer pher
JOIN photography phy ON pher.photographer_id = phy.photographer_id
JOIN photographycopy pcpy ON pcpy.pid = phy.pid
JOIN review r ON pcpy.copy_id = r.copy_id
WHERE r.copy_id NOT IN
    (SELECT copy_id
     FROM review
     WHERE rate <= 5);


-- Requête 20 : "Récupère les copies de photographies apparaissant dans
--               plusieurs commandes différentes et qui n'ont jamais été retournées."

SELECT DISTINCT s1.copy_id
FROM shoppingcartelem s1,
     shoppingcartelem s2
WHERE s1.cmd_id <> s2.cmd_id
  AND s1.copy_id = s2.copy_id
EXCEPT
SELECT copy_id
FROM return_product rp
JOIN shoppingcartelem s ON rp.elem_id = s.elem_id;
