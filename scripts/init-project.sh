#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  ./scripts/init-project.sh [--verify] <project-name> <java-package> [display-name] [java-class-prefix]

Exemples:
  ./scripts/init-project.sh music-quiz fr.teopartesi.musicquiz
  ./scripts/init-project.sh musicquiz fr.teopartesi.musicquiz "Music Quiz" MusicQuiz

Contraintes:
  project-name       minuscules, chiffres et tirets, par exemple music-quiz
  java-package       package Java en minuscules, par exemple fr.teopartesi.musicquiz
  display-name       nom affiché facultatif
  java-class-prefix  préfixe Java facultatif, par exemple MusicQuiz
USAGE
}

verify=false
if [[ "${1:-}" == "--verify" ]]; then
  verify=true
  shift
fi

if [[ $# -lt 2 || $# -gt 4 ]]; then
  usage >&2
  exit 2
fi

project_name="$1"
java_package="$2"
display_name="${3:-}"
class_prefix="${4:-}"

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
project_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
cd "$project_root"

if [[ -f .template-initialized ]]; then
  echo "Ce projet a déjà été initialisé. Consultez .template-initialized." >&2
  exit 1
fi

if [[ ! "$project_name" =~ ^[a-z][a-z0-9]*(-[a-z0-9]+)*$ ]]; then
  echo "Nom technique invalide : utilisez des minuscules, chiffres et tirets." >&2
  exit 2
fi

if [[ ! "$java_package" =~ ^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$ ]]; then
  echo "Package Java invalide : utilisez au moins deux segments en minuscules." >&2
  exit 2
fi

if [[ "$project_name" == "starter" || "$java_package" == "fr.teopartesi.starter" ]]; then
  echo "Choisissez des identifiants différents de ceux du template." >&2
  exit 2
fi

derived_class_prefix="$(
  printf '%s\n' "$project_name" | awk -F- '{
    for (i = 1; i <= NF; i++) {
      printf "%s%s", toupper(substr($i, 1, 1)), substr($i, 2)
    }
    printf "\n"
  }'
)"

if [[ -z "$class_prefix" ]]; then
  class_prefix="$derived_class_prefix"
fi

if [[ ! "$class_prefix" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
  echo "Préfixe Java invalide : utilisez un identifiant PascalCase." >&2
  exit 2
fi

if [[ -z "$display_name" ]]; then
  display_name="$class_prefix"
fi

if [[ ! "$display_name" =~ ^[[:alnum:]][[:alnum:][:space:]._-]*$ ]]; then
  echo "Nom affiché invalide : utilisez des lettres, chiffres, espaces, points, tirets ou underscores." >&2
  exit 2
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "L'initialisation doit être exécutée dans un dépôt Git." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Le dépôt doit être propre avant l'initialisation." >&2
  git status --short >&2
  exit 1
fi

required_paths=(
  .github/workflows/ci.yml
  .seed4j/modules
  backend/main/java/fr/teopartesi/starter
  backend/test/java/fr/teopartesi/starter
  backend/main/resources/application.yml
  documentation/package-types.md
  frontend/angular.json
  frontend/package.json
  frontend/package-lock.json
  package.json
  package-lock.json
  pom.xml
)

for path in "${required_paths[@]}"; do
  if [[ ! -e "$path" ]]; then
    echo "Chemin du template absent : $path" >&2
    exit 1
  fi
done

new_package_path="$(printf '%s' "$java_package" | tr '.' '/')"
new_main_package="backend/main/java/$new_package_path"
new_test_package="backend/test/java/$new_package_path"
application_class="${class_prefix}Application"
collections_class="${class_prefix}Collections"
frontend_name="${project_name}-frontend"
brand_initial="$(printf '%s' "$class_prefix" | cut -c 1)"

if [[ -e "$new_main_package" || -e "$new_test_package" ]]; then
  echo "Le package cible existe déjà ; arrêt pour éviter un écrasement." >&2
  exit 1
fi

echo "Initialisation de $display_name"
echo "  nom technique : $project_name"
echo "  package Java  : $java_package"
echo "  classes Java  : $class_prefix"

find \
  backend/main/java/fr/teopartesi/starter \
  backend/test/java/fr/teopartesi/starter \
  -type f \
  -name '*.java' \
  -exec env \
    JAVA_PACKAGE="$java_package" \
    APPLICATION_CLASS="$application_class" \
    COLLECTIONS_CLASS="$collections_class" \
    perl -pi -e \
      's/fr\.teopartesi\.starter/$ENV{JAVA_PACKAGE}/g; s/StarterApplication/$ENV{APPLICATION_CLASS}/g; s/StarterCollections/$ENV{COLLECTIONS_CLASS}/g' \
    {} +

mv \
  backend/main/java/fr/teopartesi/starter/StarterApplication.java \
  "backend/main/java/fr/teopartesi/starter/${application_class}.java"

mv \
  backend/main/java/fr/teopartesi/starter/shared/collection/domain/StarterCollections.java \
  "backend/main/java/fr/teopartesi/starter/shared/collection/domain/${collections_class}.java"

mv \
  backend/test/java/fr/teopartesi/starter/StarterApplicationIT.java \
  "backend/test/java/fr/teopartesi/starter/${application_class}IT.java"

mv \
  backend/test/java/fr/teopartesi/starter/shared/collection/domain/StarterCollectionsTest.java \
  "backend/test/java/fr/teopartesi/starter/shared/collection/domain/${collections_class}Test.java"

mkdir -p "$(dirname "$new_main_package")" "$(dirname "$new_test_package")"
mv backend/main/java/fr/teopartesi/starter "$new_main_package"
mv backend/test/java/fr/teopartesi/starter "$new_test_package"

find backend/main/java/fr backend/test/java/fr -type d -empty -delete 2>/dev/null || true

env \
  JAVA_PACKAGE="$java_package" \
  PROJECT_NAME="$project_name" \
  DISPLAY_NAME="$display_name" \
  perl -pi -e \
    's/fr\.teopartesi\.starter/$ENV{JAVA_PACKAGE}/g; s/<artifactId>starter<\//"<artifactId>".$ENV{PROJECT_NAME}."<\/"/ge; s/<name>starter<\//"<name>".$ENV{PROJECT_NAME}."<\/"/ge; s/<description>Starter<\//"<description>".$ENV{DISPLAY_NAME}."<\/"/ge' \
    pom.xml

env PROJECT_NAME="$project_name" DISPLAY_NAME="$display_name" perl -pi -e \
  's/"name": "starter"/"name": "$ENV{PROJECT_NAME}"/g; s/"description": "Starter"/"description": "$ENV{DISPLAY_NAME}"/g' \
  package.json package-lock.json

env PROJECT_NAME="$project_name" perl -pi -e \
  's/name: starter/"name: ".$ENV{PROJECT_NAME}/ge' \
  backend/main/resources/application.yml

env FRONTEND_NAME="$frontend_name" perl -pi -e \
  's/starter-frontend/$ENV{FRONTEND_NAME}/g' \
  frontend/package.json frontend/package-lock.json frontend/angular.json .github/workflows/ci.yml

for module_file in .seed4j/modules/*.json; do
  env JAVA_PACKAGE="$java_package" PROJECT_NAME="$project_name" DISPLAY_NAME="$display_name" perl -pi -e \
    's/"packageName": "fr\.teopartesi\.starter"/"packageName": "$ENV{JAVA_PACKAGE}"/g; s/"projectName": "Starter"/"projectName": "$ENV{DISPLAY_NAME}"/g; s/"baseName": "starter"/"baseName": "$ENV{PROJECT_NAME}"/g' \
    "$module_file"
done

env JAVA_PACKAGE="$java_package" perl -pi -e \
  's/fr\.teopartesi\.starter/$ENV{JAVA_PACKAGE}/g' \
  documentation/package-types.md

env DISPLAY_NAME="$display_name" BRAND_INITIAL="$brand_initial" perl -pi -e \
  's/Starter/$ENV{DISPLAY_NAME}/g; s/>S<\/span/">".$ENV{BRAND_INITIAL}."<\/span"/ge' \
  frontend/src/index.html \
  frontend/src/app/app-shell.html \
  frontend/src/app/app.routes.ts \
  frontend/src/app/app.routes.spec.ts \
  frontend/src/app/pages/home/home.html

env DISPLAY_NAME="$display_name" perl -pi -e \
  's/^# Full-stack Seed4J template$/"# ".$ENV{DISPLAY_NAME}/ge' \
  README.md

env DISPLAY_NAME="$display_name" perl -pi -e \
  's/^# Frontend du template$/"# Frontend de ".$ENV{DISPLAY_NAME}/ge' \
  frontend/README.md

cat > .template-initialized <<MARKER
project_name=$project_name
java_package=$java_package
display_name=$display_name
java_class_prefix=$class_prefix
MARKER

if rg -n \
  'fr\.teopartesi\.starter|starter-frontend|StarterApplication|StarterCollections|"name": "starter"|name: starter|<artifactId>starter</artifactId>' \
  --hidden \
  -g '!.git/**' \
  -g '!scripts/init-project.sh' \
  -g '!scripts/test-init-project.sh'; then
  echo "Des références techniques du template subsistent." >&2
  exit 1
fi

node -e \
  'const fs = require("fs"); for (const file of process.argv.slice(1)) JSON.parse(fs.readFileSync(file, "utf8"));' \
  package.json \
  package-lock.json \
  frontend/package.json \
  frontend/package-lock.json \
  frontend/angular.json \
  .seed4j/modules/*.json

if [[ "$verify" == true ]]; then
  mise run check
fi

echo "Initialisation terminée. Vérifiez les changements avec git status et git diff."
