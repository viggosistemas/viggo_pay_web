import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class ForgetPassWordFormFields extends BaseForm {
  final domain = StringField(
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

  @override
  List<Field> getFields() => [domain, email];

  @override
  Map<String, String>? getValues() {
    if (!domain.isValid || !email.isValid) return null;

    return {
      'domain': domain.value!,
      'email': email.value!,
    };
  }
}
