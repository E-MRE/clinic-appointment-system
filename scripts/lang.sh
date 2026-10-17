#!/usr/bin/env bash
dart run easy_localization:generate -O lib/generated/localization/lang -f keys -o locale_keys.g.dart --source-dir assets/translations
dart run easy_localization:generate -O lib/generated/localization/lang --source-dir assets/translations
