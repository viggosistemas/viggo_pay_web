import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class RegisterFormFields extends BaseForm {
  final name = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final displayName = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final email = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      Validator().isEmailValid,
    ],
  );
  final password = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      Validator().isPasswordStrong,
    ],
  );

  @override
  List<Field> getFields() => [
        name,
        displayName,
        email,
        password,
      ];

  @override
  Map<String, String>? getValues() {
    if (!name.isValid || !displayName.isValid || !email.isValid) {
      return null;
    }
    return {
      'name': name.value!,
      'display_name': displayName.value!,
      'email': email.value!,
      'password': password.value ?? '',
    };
  }
}
