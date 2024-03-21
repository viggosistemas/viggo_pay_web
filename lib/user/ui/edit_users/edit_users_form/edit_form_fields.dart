import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditUsersFormField extends BaseForm{
  final name = StringField(
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
  final domainId = StringField(
    isRequired: true,
  );

  @override
  List<Field> getFields() => [name, email, domainId];

  @override
  Map<String, String>? getValues() {
    if (!name.isValid || !email.isValid || !domainId.isValid) return null;

    return {
      'name': name.value!,
      'email': email.value!,
      'domain_id': domainId.value!,
    };
  }
}
