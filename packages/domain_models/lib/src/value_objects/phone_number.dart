import 'package:equatable/equatable.dart';
import '../exceptions/domain_exception.dart';

class PhoneNumber extends Equatable {
  final String value;

  static final _e164Regex = RegExp(r'^\+[1-9]\d{6,14}$');

  const PhoneNumber._(this.value);

  factory PhoneNumber.parse(String input) {
    // Strip common delimiters: spaces, dashes, parentheses
    final sanitized = input.replaceAll(RegExp(r'[\s\-()]'), '');

    if (!_e164Regex.hasMatch(sanitized)) {
      throw InvalidPhoneNumberException(
        'Phone number "$input" is invalid. Must be in E.164 international format (e.g. +12345678901).',
      );
    }

    return PhoneNumber._(sanitized);
  }

  @override
  String toString() => value;

  @override
  List<Object?> get props => [value];
}
