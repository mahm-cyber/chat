import 'package:domain_models/domain_models.dart';
import 'package:test/test.dart';

void main() {
  group('PhoneNumber Value Object', () {
    test('successfully parses valid E.164 phone numbers', () {
      final phone = PhoneNumber.parse('+12025550143');
      expect(phone.value, equals('+12025550143'));
    });

    test('sanitizes spaces, dashes, and parentheses', () {
      final phone = PhoneNumber.parse('+1 (202) 555-0143');
      expect(phone.value, equals('+12025550143'));
    });

    test('throws InvalidPhoneNumberException when missing leading plus', () {
      expect(
        () => PhoneNumber.parse('12025550143'),
        throwsA(isA<InvalidPhoneNumberException>()),
      );
    });

    test('throws InvalidPhoneNumberException when containing letters', () {
      expect(
        () => PhoneNumber.parse('+1202555ABCD'),
        throwsA(isA<InvalidPhoneNumberException>()),
      );
    });

    test('throws InvalidPhoneNumberException when too short or too long', () {
      expect(
        () => PhoneNumber.parse('+123'),
        throwsA(isA<InvalidPhoneNumberException>()),
      );
      expect(
        () => PhoneNumber.parse('+12345678901234567'),
        throwsA(isA<InvalidPhoneNumberException>()),
      );
    });

    test('supports value equality', () {
      final phone1 = PhoneNumber.parse('+12025550143');
      final phone2 = PhoneNumber.parse('+1 (202) 555-0143');
      expect(phone1, equals(phone2));
    });
  });
}
