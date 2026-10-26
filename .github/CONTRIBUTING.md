# Contributing to Clinic Appointment System

Thank you for helping improve the Clinic Appointment System. Please use the workflow below so
changes stay focused, reviewable, and visible in the project history.

## From issue to pull request

1. Find an existing issue or open one describing the bug or proposed change. For substantial work,
   wait until the scope is agreed before starting.
2. Create a branch from `main` using a short name such as `feat/<issue>-short-name`,
   `fix/<issue>-short-name`, or `chore/<issue>-short-name`.
3. Open a pull request into `main`, link the issue, and summarize the change and validation.

Pull request titles must follow [Conventional Commits](https://www.conventionalcommits.org/), for
example `feat: add appointment approval` or `fix: prevent overlapping appointments`.

Merge pull requests with a rebase or a merge commit. Never squash. The course requires commits on
at least 10 different days to remain visible in the repository history.

## Development and checks

Use test-driven development for the domain layer: write or update tests first, then implement the
behavior. Keep domain code independent of Flutter and Firebase.

Feature pages compose the shared UI layer: text uses `AppText` roles and tones, and components come
from `lib/core/widgets/` (browse them on the debug-only `/debug/components` route). Raw text styles
and spacing values belong only in the shared layer; page-specific customization stays in the page.

Run these local checks when the Flutter skeleton is available:

```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

If a check cannot run, explain why in the pull request.
