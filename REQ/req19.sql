-- Requête 19 : "Récupère le nom de tous les photographes ayant aucune review inférieur à 5."

SELECT DISTINCT CONCAT(pher.firstname, ' ', pher.lastname) AS photographer_name
FROM photographer pher
JOIN photography phy ON pher.photographer_id = phy.photographer_id
JOIN photographycopy pcpy ON pcpy.pid = phy.pid
JOIN review r ON pcpy.copy_id = r.copy_id
WHERE r.copy_id NOT IN
    (SELECT copy_id
     FROM review
     WHERE rate <= 5);
