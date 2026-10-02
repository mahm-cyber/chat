abstract class DomainException implements Exception {
  final String message;
  const DomainException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class InvalidPhoneNumberException extends DomainException {
  const InvalidPhoneNumberException(super.message);
}

class InvalidMessageContentException extends DomainException {
  const InvalidMessageContentException(super.message);
}

class UnauthorizedDomainActionException extends DomainException {
  const UnauthorizedDomainActionException(super.message);
}

class DomainInvariantViolationException extends DomainException {
  const DomainInvariantViolationException(super.message);
}

class EntityNotFoundException extends DomainException {
  const EntityNotFoundException(super.message);
}
