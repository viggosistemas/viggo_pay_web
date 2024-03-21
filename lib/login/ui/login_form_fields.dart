import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class LoginFormFields extends BaseForm {
  final domain = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  final username = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  final password = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  final remember = StringField();

  @override
  List<Field> getFields() => [domain, username, password];

  @override
  Map<String, String>? getValues() {
    if (!domain.isValid || !username.isValid || !password.isValid) return null;

    return {
      'domain': domain.value!,
      'username': username.value!,
      'password': password.value!,
    };
  }

  Map<String, dynamic>? getRememberFields() {
    if (!domain.isValid || !username.isValid || !remember.isValid) return null;

    return {
      "domain_name": domain.value!,
      "usernameOrEmail": username.value!,
      "rememberCredentials": remember.value?.parseBool() ?? false,
    };
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}