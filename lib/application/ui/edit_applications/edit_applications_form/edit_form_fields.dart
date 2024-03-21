import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditApplicationFormFields extends BaseForm {
  final name = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  final description = StringField(
    validators: [
      Validator().isEmptyValue,
    ],
  );

  @override
  List<Field> getFields() => [name];

  @override
  Map<String, String>? getValues() {
    if (!name.isValid || !description.isValid) {
      return null;
    }
    return {
      'name': name.value!,
      'description': description.value ?? '',
    };
  }
}
