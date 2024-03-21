import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class InfoUserFormFields extends BaseForm {
  final nickname = StringField(validators: [
    Validator().isEmptyValue,
  ]);

  @override
  List<Field> getFields() => [nickname];

  @override
  Map<String, String>? getValues() {
    if (!nickname.isValid) return null;

    return {
      'nickname': nickname.value!,
    };
  }
}
