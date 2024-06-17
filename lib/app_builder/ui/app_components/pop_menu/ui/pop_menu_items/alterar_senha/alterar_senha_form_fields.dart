import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class AlterarSenhaFormFields extends BaseForm {
  final senhaAntiga = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  final novaSenha = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      Validator().isPasswordStrong,
    ],
  );

  final confirmarSenha = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      Validator().isPasswordStrong,
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
