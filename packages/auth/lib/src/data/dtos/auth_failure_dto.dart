
import '../../domain/auth_domain.dart';

class AuthFailureDto {
  static AuthFailure fromFirebaseErrorCode(String code) {
    final failureConverter = {
      'internal-error': UnknownAuthFailure(code: code),
      'claims-too-large': UnknownAuthFailure(code: code),
      'invalid-hash-algorithm': UnknownAuthFailure(code: code),
      'invalid-hash-block-size': UnknownAuthFailure(code: code),
      'invalid-hash-derived-key-length': UnknownAuthFailure(code: code),
      'invalid-hash-key': UnknownAuthFailure(code: code),
      'invalid-hash-memory-cost': UnknownAuthFailure(code: code),
      'invalid-hash-parallelization': UnknownAuthFailure(code: code),
      'invalid-hash-rounds': UnknownAuthFailure(code: code),
      'invalid-hash-salt-separator': UnknownAuthFailure(code: code),
      'insufficient-permission': MissingPermissionFailure(code: code),
      'operation-not-allowed': MissingAuthenticationFailure(code: code),
      'missing-android-pkg-name': UnknownAuthFailure(code: code),
      'missing-oauth-client-secret	': UnknownAuthFailure(code: code),
      'project-not-found': UnknownAuthFailure(code: code),
      'reserved-claims': UnknownAuthFailure(code: code),
      'maximum-user-count-exceeded': UnknownAuthFailure(code: code),
      'unauthorized-continue-uri': MissingAuthenticationFailure(code: code),
      'email-already-exists': EmailAlreadyExistsFailure(code: code),
      'email-already-in-use': EmailAlreadyExistsFailure(code: code),
      'network-request-failed': NetworkAuthFailure(code: code),
      'invalid-email': const InvalidEmailFailure(),
      'invalid-password': const InvalidPasswordFailure(),
      'invalid-uid': const UnknownAuthFailure(),
      'invalid-phone-number': const UnknownAuthFailure(),
      'invalid-display-name': const UnknownAuthFailure(),
      'invalid-dynamic-link-domain': const UnknownAuthFailure(),
      'invalid-creation-time': const UnknownAuthFailure(),
      'invalid-disabled-field': const UnknownAuthFailure(),
      'invalid-email-verified': UnknownAuthFailure(code: code),
      'invalid-photo-url': const UnknownAuthFailure(),
      'invalid-credential': InvalidCredentialsFailure(code: code),
      'invalid-argument': const UnknownAuthFailure(),
      'invalid-claims': const UnknownAuthFailure(),
      'invalid-continue-uri': const UnknownAuthFailure(),
      'invalid-user-import': const UnknownAuthFailure(),
      'invalid-id-token': const UnknownAuthFailure(),
      'invalid-last-sign-in-time': const UnknownAuthFailure(),
      'invalid-provider-data': UnknownAuthFailure(code: code),
      'invalid-provider-id': UnknownAuthFailure(code: code),
      'invalid-oauth-responsetype': const UnknownAuthFailure(),
      'missing-continue-uri': UnknownAuthFailure(code: code),
      'missing-hash-algorithm': UnknownAuthFailure(code: code),
      'missing-uid': const UnknownAuthFailure(),
      'invalid-page-token': UnknownAuthFailure(code: code),
      'phone-number-already-exists': const UnknownAuthFailure(),
      'uid-already-exists': const UnknownAuthFailure(),
      'user-not-found': UserNotFoundFailure(code: code),
      'invalid-session-cookie-duration': const UnknownAuthFailure(),
      'session-cookie-expired': MissingAuthenticationFailure(code: code),
      'session-cookie-revoked': MissingAuthenticationFailure(code: code),
      'id-token-expired': MissingAuthenticationFailure(code: code),
      'id-token-revoked': MissingAuthenticationFailure(code: code),
      'invalid-password-hash': const UnknownAuthFailure(),
      'invalid-password-salt': const UnknownAuthFailure(),
      'missing-ios-bundle-id': const UnknownAuthFailure(),
      'reserved-claims	': const UnknownAuthFailure(),
      'wrong-password': WrongPasswordFailure(code: code),
    };
    return failureConverter[code] ?? UnknownAuthFailure(code: code);
  }
}