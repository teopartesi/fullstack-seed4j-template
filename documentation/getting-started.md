# Créer un projet depuis le template

Le dépôt est un template GitHub complété par un script d'initialisation. GitHub crée d'abord un dépôt indépendant, puis le
script remplace les identifiants techniques `starter` par ceux du nouveau projet.

## Création avec GitHub CLI

Choisir le nom du nouveau dépôt et sa visibilité :

```bash
cd ~/workspace

gh repo create teopartesi/musicquiz \
  --template teopartesi/fullstack-seed4j-template \
  --private \
  --clone

cd musicquiz
```

Le dépôt créé possède son propre historique et son propre remote `origin`.

## Initialisation

Vérifier que le dépôt est propre, puis exécuter le script avec le nom technique, le package Java, le nom affiché et le
préfixe des classes Java :

```bash
git status --short --branch

./scripts/init-project.sh \
  musicquiz \
  fr.teopartesi.musicquiz \
  "Music Quiz" \
  MusicQuiz
```

Pour un nom technique composé de mots séparés par des tirets, les deux derniers arguments peuvent être omis :

```bash
./scripts/init-project.sh music-quiz fr.teopartesi.musicquiz
```

Le script :

- valide les arguments et exige un dépôt Git propre ;
- renomme les packages, classes Java, manifests npm, workspace Angular et métadonnées Seed4J ;
- adapte les chemins utilisés par la CI ;
- crée `.template-initialized` ;
- refuse une seconde initialisation.

## Installation et vérification

```bash
mise trust
mise install
mise run deps:clean_install
mise run frontend:ci
mise run check
```

Examiner ensuite les modifications :

```bash
git status --short
git diff
```

Créer le premier commit du nouveau projet uniquement lorsque tous les contrôles passent.

## Sonar optionnel

La CI fonctionne sans configuration Sonar. Pour activer l'analyse, suivre la procédure décrite dans
[`ci-cd.md`](ci-cd.md). Les variables et secrets GitHub du template ne sont pas copiés dans le nouveau dépôt.
