import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';

class ListDomainsMatrizFormField extends BaseForm{
  final domainId = StringField();

  @override
  List<Field> getFields() => [domainId];

  @override
  Map<String, String>? getValues() {
    if (!domainId.isValid) return null;

    return {
      'domain_id': domainId.value!,
    };
  }
}
