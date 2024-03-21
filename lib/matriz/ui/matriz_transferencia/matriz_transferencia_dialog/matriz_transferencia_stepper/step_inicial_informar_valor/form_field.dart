import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/doublefield.dart';
import 'package:viggo_core_frontend/form/field/field.dart';

class EditValorStepFormFields extends BaseForm {
  final valor = DoubleField(
    isRequired: true,
    validators: [
      isBiggerThenZero,
    ],
  );

  @override
  List<Field> getFields() => [valor];

  @override
  Map<String, String>? getValues() {
    if (!valor.isValid) return null;

    return {
      'valor': valor.value!,
    };
  }
}
