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
