#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
project_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
test_root="$(mktemp -d "${TMPDIR:-/tmp}/starter-init-test.XXXXXX")"

cleanup() {
  if [[ -n "$test_root" && -d "$test_root" && "$test_root" == *starter-init-test.* ]]; then
    rm -rf -- "$test_root"
  fi
}
trap cleanup EXIT

tar \
  --exclude=.git \
  --exclude=node_modules \
  --exclude=frontend/node_modules \
  --exclude=target \
  --exclude=frontend/dist \
  --exclude=frontend/coverage \
  -cf - \
  -C "$project_root" . | tar -xf - -C "$test_root"

cd "$test_root"
git init -q -b main
git add .
git -c user.name='Template Test' -c user.email='template-test@example.invalid' commit -qm 'Initial template state'

./scripts/init-project.sh musicquiz fr.example.musicquiz "Music Quiz" MusicQuiz

test -f backend/main/java/fr/example/musicquiz/MusicQuizApplication.java
test -f backend/test/java/fr/example/musicquiz/MusicQuizApplicationIT.java
test -f backend/main/java/fr/example/musicquiz/shared/collection/domain/MusicQuizCollections.java
test -f .template-initialized
test ! -d backend/main/java/fr/teopartesi/starter
test ! -d backend/test/java/fr/teopartesi/starter

node -e \
  'const fs = require("fs"); for (const file of process.argv.slice(1)) JSON.parse(fs.readFileSync(file, "utf8"));' \
  package.json \
  package-lock.json \
  frontend/package.json \
  frontend/package-lock.json \
  frontend/angular.json \
  .seed4j/modules/*.json

if ./scripts/init-project.sh second-project fr.example.second >/dev/null 2>&1; then
  echo "La seconde initialisation aurait dû être refusée." >&2
  exit 1
fi

if rg -n \
  'fr\.teopartesi\.starter|starter-frontend|StarterApplication|StarterCollections|"name": "starter"|name: starter|<artifactId>starter</artifactId>' \
  --hidden \
  -g '!.git/**' \
  -g '!scripts/init-project.sh' \
  -g '!scripts/test-init-project.sh'; then
  echo "Des références techniques du template subsistent dans le projet de test." >&2
  exit 1
fi

echo "Test d'initialisation réussi dans une copie temporaire."
