import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';

class HeaderSearchFormFields extends BaseForm {
  final searchField = StringField();

  @override
  List<Field> getFields() {
    return [searchField];
  }

  @override
  Map<String, String>? getValues() {
    if (!searchField.isValid) return null;

    return {
      'searchField': searchField.value!,
    };
  }
}
