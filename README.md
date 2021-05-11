# Projet - BD6

Modélisation et peuplement d'une base de donnée pour un site d'e-commerce.

## Documentation 📄

* Le [sujet](https://gaufre.informatique.univ-paris-diderot.fr/EmileRolley/bd6-project/blob/master/docs/pdf/subject.pdf)
* La [modélisation](https://gaufre.informatique.univ-paris-diderot.fr/EmileRolley/bd6-project/blob/master/docs/pdf/design.pdf)
* Le [diagramme E/R](https://gaufre.informatique.univ-paris-diderot.fr/EmileRolley/bd6-project/blob/master/docs/images/ER-diagram.png)

## Rendus 🏷

* [`assignment1`](https://gaufre.informatique.univ-paris-diderot.fr/EmileRolley/bd6-project/tags/assignment1) correspond à la première version de la modélisation.
* [`assignment2`](https://gaufre.informatique.univ-paris-diderot.fr/EmileRolley/bd6-project/tags/assignment2) correspond à la version finale de la modélisation.


## Utilisation

Dans un un interpréteur `PostgreSQL` :

Pour créer les différentes tables de la base de données, exécutez la commande suivante :

```sql
\i create_table.sql
```

Pour remplir les tables avec les données générées automatiquement (grand jeux de données)
à l'aide du script `generate.py`, exécutez la commande suivante :

```sql
\i insert_generated_data.sql
```

Pour remplir les tables avec les données créées à la main (petit jeux de données),
exécutez la commande suivante :

```sql
\i insert_data.sql
```

> **Remarque** : les deux jeux de données ne peuvent pas être utilisés simultanément.

Pour lancer une requête, exécutez :

```sql
\i REQ/reqi.sql -- où i correspond au numéros de la requête.
```

> **Remarque** : L'ensemble des requête du répertoire _./REQ/_ on été concaténées dans
> le fichier _./REQ/all_req.sql_.

## Récapitulatif des requêtes effectuées

Voici le descriptif de chaque requête :

| Numéro de requête | Description                                                                                                                                                                                       |
|------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 1 | Récupère le prix d'achat de tous les éléments d'une commande.                                                                                                                                     |
|                 2 | Récupère la moyenne des prix totaux de chaque copie imprimable pour chaque panier commandé.                                                                                                       |
|                 3 | Récupère les photographies ayant une note moyenne supérieure ou égale à 5.                                                                                                                        |
|                 4 | Récupère le nom des photographes ayant une note de review moyenne pour ses photographies supérieures à la moyenne de tous les notes de review.                                                    |
|                 5 | Récupère les client-e-s ayant commandé-e-s toutes les photographies du photographe 9.                                                                                                             |
|                 6 | Récupère les client-e-s ayant commandé-e-s toutes les photographies du photographe 9.                                                                                                             |
|                 7 | Récupère le nom du photographe avec le plus d'article dans un panier, c'est-à-dire le ou la plus populaire.                                                                                       |
|                 8 | Récupère tou-te-s les client-e-s habitant à Hollywood ainsi que leur nombre de commande.                                                                                                          |
|                 9 | Récupère les titres et les prix maximaux atteint par chaque photographie.                                                                                                                         |
|                10 | Récupère le client ou la cliente ayant fait le plus de commande sur le site.                                                                                                                      |
|                11 | Récupère les villes contenant plusieurs adresses différentes                                                                                                                                      |
|                12 | Récupère les numéros de commandes pour lesquels tous les éléments ont été livrés.                                                                                                                 |
|                13 | Récupère la moyenne des prix des photographies de chaque photographe, à condition qu'aucune de ses photographies n'a eu un prix inférieur à 70 euros.                                             |
|                14 | Récupère le numéro de commande ainsi que le statut de paiement de toutes les commandes n'ayant pas encore quittées le dépôt.                                                                       |
|                15 | Récupère le numéro de commande ainsi que le statut de paiement de toutes les commandes n'ayant pas encore quittées le dépôt.                                                                       |
|                16 | Récupère le titre des photographies qui ont eu au moins trois changements de prix.                                                                                                                |
|                17 | Récupère les photographies classifiées en fonction du ratio de la quantité de copies copies imprimables disponibles sur le nombre de copies actuellement commandées (risque de rupture de stock). |
|                18 | Récupère les 5 titres des photographies dont leurs copies ont été les dernières à être envoyées.                                                                                                  |
|                19 | Récupère le nom de tous les photographes n'ayant reçu aucune review inférieur à 5.                                                                                                                |
|                20 | Récupère les copies de photographies apparaissant dans plusieurs commandes différentes et qui n'ont jamais été retournées.                                                                        |

Voici le tableau des requêtes ainsi que des techniques utilisées pour chacune d'entre elles :

| Numéro de requête | + 3 tables | Auto-jointure | Sous requête              | GROUP BY + HAVING | Agrégats | Totalité |  Jointure  | Gestion des NULLs |
|------------------:|:----------:|:-------------:|:--------------------------|:-----------------:|:--------:|:--------:|:----------:|:-----------------:|
|                 1 |      X     |               | `corrélée` `SELECT` `FOR` |                   |          |          |    `ON`    |                   |
|                 2 |      X     |               | `FROM`                    |                   |     X    |          |    `ON`    |                   |
|                 3 |      X     |               |                           |         X         |     X    |          |  `NATURAL` |                   |
|                 4 |      X     |               | `HAVING`                  |         X         |     X    |          |    `ON`    |                   |
|                 5 |      X     |               | `WHERE` `HAVING`          |         X         |     X    |     X    |    `ON`    |                   |
|                 6 |      X     |               | `corrélée` `WHERE`        |                   |          |          |    `ON`    |                   |
|                 7 |      X     |               |                           |                   |     X    |          |    `ON`    |                   |
|                 8 |      X     |               |                           |                   |     X    |          |    `ON`    |                   |
|                 9 |            |               |                           |                   |     X    |          |    `ON`    |                   |
|                10 |            |               |                           |                   |     X    |          |    `ON`    |                   |
|                11 |            |       X       |                           |                   |          |          |            |                   |
|                12 |            |               | `corrélée`  `WHERE`       |                   |          |     X    |            |         X         |
|                13 |            |               |                           |         X         |     X    |          |            |                   |
|                14 |            |               |                           |                   |          |          |  `LEFT ON` |                   |
|                15 |            |               |                           |                   |          |          | `RIGHT ON` |         X         |
|                16 |            |               |                           |         X         |     X    |          |    `ON`    |                   |
|                17 |            |               |                           |                   |     X    |          |    `ON`    |                   |
|                18 |      X     |               |                           |                   |          |          |    `ON`    |         X         |
|                19 |      X     |               | `WHERE`                   |                   |          |     X    |    `ON`    |                   |
|                20 |            |       X       |                           |                   |          |     X    |    `ON`    |                   |

## Auteurs 🧘

| Nom      | Prénom | GitLab ID                                                                     | Numéro étudiant |
|----------|--------|-------------------------------------------------------------------------------|-----------------|
| Rolley   | Emile  | [@EmileRolley](https://gaufre.informatique.univ-paris-diderot.fr/EmileRolley) | 71802612        |
| Phol-Asa | Rémy   | [@pholasa](https://gaufre.informatique.univ-paris-diderot.fr/pholasa)         | 71803190        |

