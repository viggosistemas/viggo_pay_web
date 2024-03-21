import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/field_length_validator.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class AlterarSenhaPixFormFields extends BaseForm {
  final senhaAntiga = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().igualA6,
    ],
  );

  final novaSenha = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().igualA6,
    ],
  );

  final confirmarSenha = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().igualA6,
    ],
  );

  @override
  List<Field> getFields() => [senhaAntiga, novaSenha, confirmarSenha];

  @override
  Map<String, String>? getValues() {
    if (!senhaAntiga.isValid || !novaSenha.isValid || !confirmarSenha.isValid) {
      return null;
    }

    return {
      'senhaAntiga': senhaAntiga.value!,
      'novaSenha': novaSenha.value!,
      'confirmarSenha': confirmarSenha.value!,
    };
  }
}
