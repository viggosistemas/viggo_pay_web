import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditSenhaStepFormFields extends BaseForm {
  final senha = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  @override
  List<Field> getFields() => [senha];

  @override
  Map<String, String>? getValues() {
    if (!senha.isValid) return null;

    return {
      'senha': senha.value!,
    };
  }
}