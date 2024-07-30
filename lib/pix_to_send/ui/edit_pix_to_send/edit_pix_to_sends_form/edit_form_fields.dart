import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditPixToSendFormFields extends BaseForm {
  final alias = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  final aliasType = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  @override
  List<Field> getFields() => [alias, aliasType];

  @override
  Map<String, String>? getValues() {
    if (!alias.isValid || !aliasType.isValid) return null;

    return {
      'alias': alias.value!,
      'aliasType': aliasType.value!,
    };
  }
}
