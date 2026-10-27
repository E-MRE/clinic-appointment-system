/// Identifies authentication failures independently of the provider.
enum AuthErrorCode {
  invalidEmail,
  missingPassword,
  passwordTooShort,
  fullNameRequired,
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
