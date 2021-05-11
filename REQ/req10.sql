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
