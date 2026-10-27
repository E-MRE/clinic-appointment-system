#!/usr/bin/env bash
set -euo pipefail

# Runs the Firestore security rules tests against a local emulator.
# The demo- project id keeps the emulator offline from the real project.
# Mocha runs on the system node: the standalone Firebase CLI ships its own npm,
# whose config clashes with the system npm inside emulators:exec.
cd "$(dirname "$0")/.."
npm ci --prefix firebase/rules_test --silent
node_bin="$(command -v node)"
firebase emulators:exec --only firestore --project demo-clinic \
  "cd firebase/rules_test && '$node_bin' node_modules/mocha/bin/mocha.js"
