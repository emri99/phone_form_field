import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_form_field/phone_form_field.dart';

typedef PhoneNumberInputValidator = String? Function(PhoneNumber? phoneNumber);

class PhoneValidator {
  static PhoneNumberInputValidator compose(
      List<PhoneNumberInputValidator> validators) {
    return (valueCandidate) {
      for (var validator in validators) {
        final validatorResult = validator.call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }
      return null;
    };
  }

  static PhoneNumberInputValidator required(
    BuildContext context, {
    String? errorText,
  }) {
    final defaultMessage = "Phone number required";
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate == null || (valueCandidate.nsn.trim().isEmpty)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.translate(defaultMessage) ??
            defaultMessage;
      }
      return null;
    };
  }

  static PhoneNumberInputValidator invalid(
    BuildContext context, {
    String? errorText,
    bool useLightParser = false,
  }) {
    final defaultMessage = "Phone number invalid";
    final parser = useLightParser ? LightPhoneParser() : PhoneParser();
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate == null || !parser.validate(valueCandidate)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.translate(defaultMessage) ??
            defaultMessage;
      }
      return null;
    };
  }

  static PhoneNumberInputValidator type(
    BuildContext context,
    PhoneNumberType expectedType, {
    String? errorText,
    bool useLightParser = false,
  }) {
    final defaultMessage = expectedType == PhoneNumberType.mobile
        ? "Invalid mobile phone number"
        : "Invalid landline phone number";
    final parser = useLightParser ? LightPhoneParser() : PhoneParser();
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate == null ||
          !parser.validate(valueCandidate, expectedType)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.translate(defaultMessage) ??
            defaultMessage;
      }
      return null;
    };
  }

  static PhoneNumberInputValidator country(
    BuildContext context,
    List<String> expectedCountries, {
    String? errorText,
  }) {
    assert(expectedCountries.every((isoCode) => isoCodes.contains(isoCode)),
        'Each expectedCountries value be valid country isoCode');
    final defaultMessage = "Invalid country";
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate == null ||
          !expectedCountries.contains(valueCandidate.isoCode)) {
        return errorText ??
            PhoneFieldLocalization.of(context)?.translate(defaultMessage) ??
            defaultMessage;
      }
      return null;
    };
  }
}
