import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditSelectPixStepFormFields extends BaseForm {
  final contato = StringField(
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final pixSelect = StringField(isRequired: true);

  @override
  List<Field> getFields() => [pixSelect];

  @override
  Map<String, String>? getValues() {
    if (!pixSelect.isValid) return null;

    return {
      'contato': contato.value ?? '',
      'pixSelect': pixSelect.value!,
    };
  }
}