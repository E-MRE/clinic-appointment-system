# Agent instructions

## Project

Clinic Appointment System is a Flutter web app written in Dart. The planned stack includes Firebase
Authentication, Cloud Firestore, flutter_bloc (Cubit), get_it, go_router, easy_localization, and
mocktail / fake_cloud_firestore / firebase_auth_mocks for tests. The Flutter skeleton is not in the
repository yet.

## Structure

- `lib/core/`: theme, design tokens, localization, dependency injection, router, and errors.
- `lib/features/<feature>/domain/`: pure Dart entities, value objects, rules, and repository
  interfaces. Do not import Flutter or Firebase here.
- `lib/features/<feature>/data/`: Firestore/Auth implementations and DTOs.
- `lib/features/<feature>/presentation/`: cubits, pages, and widgets.
- `test/`: mirrors `lib/`.

## Conventions

- Use design tokens and `easy_localization` keys; do not hardcode colors, spacing, radii, sizes, or
  user-facing strings.
- Use constructor injection and `get_it` for dependency wiring.
- Keep business rules in the domain layer and persistence concerns in the data layer.
- Follow test-driven development for domain behavior: write tests before implementation.

## Commits and pull requests

- Use an issue, then a branch from `main` named `feat/<issue>-short-name`, `fix/<issue>-short-name`,
  or `chore/<issue>-short-name`, then open a pull request into `main`.
- Pull request titles must use Conventional Commits (`feat: ...`, `fix: ...`, `chore: ...`).
- Merge with a rebase or merge commit; never squash. The course requires commits on at least 10
  different days to remain visible in history.
- Do not add AI attribution trailers such as `Co-Authored-By` to commits or pull request
  descriptions.
- Run `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and `flutter test`
  when the Flutter skeleton is available. See [CONTRIBUTING](.github/CONTRIBUTING.md).
