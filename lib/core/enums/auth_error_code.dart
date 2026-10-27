/// Identifies authentication failures independently of the provider.
enum AuthErrorCode {
  invalidEmail,
  missingPassword,
  weakPassword,
  invalidCredentials,
  emailAlreadyInUse,
  userDisabled,
  tooManyRequests,
  networkRequestFailed,
  operationNotAllowed,
  profileUpdateFailed,
  profileCreationFailed,
  unexpected,
}
