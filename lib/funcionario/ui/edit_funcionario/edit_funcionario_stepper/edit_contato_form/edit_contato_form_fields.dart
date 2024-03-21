import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/field_length_validator.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditContatoFormFields extends BaseForm {
  final contato = StringField(validators: [
    Validator().isEmptyValue,
    FieldLengthValidator().maiorQ100,
  ]);

  final contatos = StringField();

  @override
  List<Field> getFields() => [contato];

  @override
  Map<String, String>? getValues() {
    return {
      'contato': contato.value ?? '',
      'contatos': contatos.value ?? '',
    };
  }
}
