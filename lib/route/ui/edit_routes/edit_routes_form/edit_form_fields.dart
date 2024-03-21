import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditRouteFormFields extends BaseForm {
  final name = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final url = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final method = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final bypass = StringField();
  final sysadmin = StringField();

  @override
  List<Field> getFields() => [name, url, method];

  @override
  Map<String, String>? getValues() {
    if (!name.isValid || !url.isValid || !method.isValid) {
      return null;
    }
    return {
      'name': name.value!,
      'url': url.value!,
      'method': method.value!,
      'bypass': bypass.value?.toString() ?? 'false',
      'sysadmin': sysadmin.value?.toString() ?? 'false',
    };
  }
}
