# Core foundation

## Composition and ownership

`main.dart` is the composition root: initialize Flutter/localization, create an
isolated GetIt container, call `configureDependencies`, then inject the router and
ThemeCubit into `App`. Registration lives only in `lib/core/di/`.

Use constructor injection for repositories, use cases, and Cubits. Do not import
GetIt in domain classes or descendant widgets. Widgets receive dependencies via
constructors or BlocProvider. Register repository interfaces against data-layer
implementations as features arrive. Flexify's central registration and constructor
injection are the reference for this structure.

The router and ThemeCubit are lazy singletons owned by the container. App uses
`BlocProvider.value`, so it does not close the shared Cubit. `await container.reset()`
disposes registered instances. Tests use a new container and reset it in teardown.
Feature Cubits should normally be factories owned and closed by their route's
`BlocProvider(create: ...)`.

## Routing

`AppRoutes.home` is the placeholder `/` route. Unknown URLs show a localized
not-found page with a home button. `createAppRouter` accepts a redirect callback
and refresh Listenable for future auth/role routing (#7/#8); it does not implement
access control yet. `initialLocation` is optional so platform deep links remain
available in production.

## Domain outcomes

`Failure` and `Result<T>` in `lib/core/errors/` have no framework dependencies.
Return `Success(value)` or `Failed(failure)` from domain operations. Use exhaustive
pattern matching or `fold`; `map` transforms successful values and preserves
failures. A nullable success is still a success. A thrown exception from a map
callback propagates; map does not silently convert programming errors.

Failures distinguish validation (including its field), authorization, missing
resources, conflicts, and unexpected errors. Data adapters translate known SDK
exceptions into these types. Keep technical diagnostics in data-layer logging;
presentation maps failures to localized text instead of showing exception strings.
Extend the sealed hierarchy when a concrete feature needs additional semantics.

## Feature Cubit state pattern

Use a feature-specific sealed state with initial, loading, success, and failure
variants. Store typed data and `Failure`, never localized strings or BuildContext.
The following is a template for a future feature, not an existing appointment API:

```dart
sealed class ItemsState {
  const ItemsState();
}
final class ItemsInitial extends ItemsState {}
final class ItemsLoading extends ItemsState {}
final class ItemsSuccess extends ItemsState {
  ItemsSuccess(this.items);
  final List<Item> items;
}
final class ItemsFailure extends ItemsState {
  ItemsFailure(this.failure);
  final Failure failure;
}

final class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit(this.repository) : super(ItemsInitial());
  final ItemsRepository repository;

  Future<void> load() async {
    if (isClosed || state is ItemsLoading) return;
    emit(ItemsLoading());
    final result = await repository.load(); // Future<Result<List<Item>>>
    if (isClosed) return;
    emit(switch (result) {
      Success(:final value) => ItemsSuccess(value),
      Failed(:final failure) => ItemsFailure(failure),
    });
  }
}
```

Test initial → loading → success/failure, retry after failure, and disposal during
an outstanding operation. Define a concurrency policy per feature (the example
ignores duplicate loads). Use BlocBuilder for rendering and BlocListener for
one-time effects. Simple synchronous state such as ThemeCubit needs only its
ThemeMode value, not artificial loading/failure states.

## Verification

Run `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and
`flutter test`. Domain tests were written and observed failing before Result and
Failure were implemented. Widget tests cover unknown deep links, return-home
navigation, and theme switching; DI tests cover resolution and reset isolation.

Package references: [get_it](https://pub.dev/packages/get_it),
[go_router](https://pub.dev/packages/go_router),
[flutter_bloc](https://pub.dev/packages/flutter_bloc).
