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
        AND s.cmd_id IS NOT NULL
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
                                    AND s.cmd_id = c.cmd_id
                                    AND s.cmd_id IS NOT NULL)
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
