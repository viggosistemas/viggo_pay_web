import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/doublefield.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class ConfigMatrizTaxaFormFields extends BaseForm {
  final porcentagem = DoubleField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final taxa = StringField(
    isRequired: true,
  );
  @override
  List<Field> getFields() => [taxa];

  @override
  Map<String, String>? getValues() {
    if (!porcentagem.isValid && !taxa.isValid) {
      return null;
    } else if (!porcentagem.isValid) {
      return {
        'taxa': taxa.value!.toString(),
      };
    } else if (!taxa.isValid) {
      return {
        'porcentagem': porcentagem.value.toString(),
      };
    } else {
      return {
        'porcentagem': porcentagem.value!.toString(),
        'taxa': taxa.value!.toString(),
      };
    }
  }
}
