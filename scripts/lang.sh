#!/usr/bin/env bash
set -euo pipefail

dart run easy_localization:generate -O lib/generated/localization/lang -f keys -o locale_keys.g.dart --source-dir assets/translations
dart format lib/generated/localization/lang/locale_keys.g.dart
