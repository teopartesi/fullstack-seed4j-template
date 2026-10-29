# Maintenance du template

Le template contient uniquement le socle technique partagé. Les règles, données, écrans et intégrations propres à une
application sont développés dans les dépôts créés depuis le template.

## Modifier le template

Avant une modification :

```bash
git status --short --branch
git remote -v
```

Conserver les marqueurs et métadonnées Seed4J. Lorsqu'un identifiant technique `starter` est ajouté dans une configuration,
adapter également `scripts/init-project.sh` et son test.

## Vérifications obligatoires

```bash
mise run deps:clean_install
mise run frontend:ci
mise run format:check
mise run check
./scripts/test-init-project.sh
```

Le test de l'initialiseur crée un dépôt temporaire, initialise un projet d'exemple, valide ses fichiers et vérifie qu'une
seconde initialisation est refusée.

## Recherche des références interdites

Le dépôt template peut contenir les identifiants `starter`. Il ne doit pas contenir de référence métier provenant d'une
application créée depuis lui.

Avant publication, rechercher les noms, packages, domaines fonctionnels et clés de services propres aux projets dérivés.

## Versions et dépendances

- mettre à jour les versions de `mise.toml`, des workflows et des manifests de manière cohérente ;
- régénérer les lockfiles avec les versions npm déclarées par le projet ;
- conserver les scans et seuils existants tant qu'une modification n'est pas explicitement validée ;
- exécuter les tests locaux avant de vérifier la CI distante.

## Publication

Ne publier une modification qu'après relecture du diff et réussite des contrôles. Les services externes optionnels restent
désactivés par défaut afin qu'un dépôt nouvellement créé dispose immédiatement d'une CI exploitable.
