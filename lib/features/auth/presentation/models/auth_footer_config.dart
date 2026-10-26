/// Footer navigation parameters for an authentication screen.
final class AuthFooterConfig {
  const AuthFooterConfig({
    required this.promptKey,
    required this.actionKey,
    required this.alternateRoute,
  });

  /// Translation key for the prompt text preceding the link.
  final String promptKey;

  /// Translation key for the clickable link action.
  final String actionKey;

  /// Navigation target route when the link is tapped.
  final String alternateRoute;
}
