import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';

class ListUsersFormField extends BaseForm {
  final name = StringField();

  @override
  Map<String, String>? getValues() {
    if (!name.isValid) return null;

    return {
      'name': '%${name.value ?? ''}%',
    };
  }

  @override
  List<Field> getFields() => [name];
}
