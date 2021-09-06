import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/validator/phone_validator.dart';

void main() async {
  Future<BuildContext> getBuildContext(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    return tester.element(find.byType(Container));
  }

  group('PhoneValidator.compose', () {
    testWidgets('compose should test each validator until first failure',
        (WidgetTester tester) async {
      bool firstValidationDone = false;
      bool lastValidationDone = false;
      final validator = PhoneValidator.compose([
        (PhoneNumber? p) {
          firstValidationDone = true;
        },
        (PhoneNumber? p) {
          return "validation failed";
        },
        (PhoneNumber? p) {
          lastValidationDone = true;
        },
      ]);
      expect(validator(PhoneNumber(isoCode: '', nsn: '')),
          equals("validation failed"));
      expect(firstValidationDone, isTrue);
      expect(lastValidationDone, isFalse);
    });
  });

  group('PhoneValidator.required', () {
    testWidgets('should be required value', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.required(context);
      expect(
        validator(PhoneNumber(isoCode: 'US', nsn: '')),
        equals("Phone number required"),
      );

      final validatorWithText = PhoneValidator.required(
        context,
        errorText: 'custom message',
      );
      expect(
        validatorWithText(PhoneNumber(isoCode: 'US', nsn: '')),
        equals("custom message"),
      );
    });
  });

  group('PhoneValidator.invalid', () {
    testWidgets('should be invalid', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.invalid(context);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '123')),
        equals("Phone number invalid"),
      );

      final validatorWithText = PhoneValidator.invalid(
        context,
        errorText: 'custom message',
      );
      expect(
        validatorWithText(PhoneNumber(isoCode: 'FR', nsn: '123')),
        equals("custom message"),
      );
    });
  });

  group('PhoneValidator.type', () {
    testWidgets('should be invalid mobile type', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.type(context, PhoneNumberType.mobile);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '412345678')),
        equals("Invalid mobile phone number"),
      );

      final validatorWithText = PhoneValidator.type(
        context,
        PhoneNumberType.mobile,
        errorText: 'custom type message',
      );
      expect(
        validatorWithText(PhoneNumber(isoCode: 'FR', nsn: '412345678')),
        equals("custom type message"),
      );
    });

    testWidgets('should be invalid landline type', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.type(context, PhoneNumberType.fixedLine);
      expect(
        validator(PhoneNumber(isoCode: 'FR', nsn: '612345678')),
        equals("Invalid landline phone number"),
      );

      final validatorWithText = PhoneValidator.type(
        context,
        PhoneNumberType.fixedLine,
        errorText: 'custom fixed type message',
      );
      expect(
        validatorWithText(PhoneNumber(isoCode: 'FR', nsn: '612345678')),
        equals("custom fixed type message"),
      );
    });
  });

  group('PhoneValidator.country', () {
    testWidgets('should be invalid country', (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      final validator = PhoneValidator.country(context, ['FR', 'BE']);
      expect(
        validator(PhoneNumber(isoCode: 'US', nsn: '')),
        equals("Invalid country"),
      );
    });

    testWidgets('country validator should refuse invalid isoCode',
        (WidgetTester tester) async {
      final context = await getBuildContext(tester);

      expect(
        () => PhoneValidator.country(context, ['INVALID_ISO_CODE']),
        throwsAssertionError,
      );
    });
  });
}
