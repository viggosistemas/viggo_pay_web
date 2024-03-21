import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/field_length_validator.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditEnderecoFormFields extends BaseForm {
  final logradouro = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ255,
    ],
  );
  final numero = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ60,
    ],
  );
  final complemento = StringField(
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ60,
    ],
  );
  final bairro = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ60,
      FieldLengthValidator().menorQ3,
    ],
  );
  final cep = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final pontoReferencia = StringField(
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ500,
    ],
  );
  final municipio = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final municipioName = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );

  @override
  List<Field> getFields() => [
        logradouro,
        numero,
        complemento,
        bairro,
        cep,
        pontoReferencia,
        municipio,
        municipioName,
      ];

  @override
  Map<String, String>? getValues() {
    if (!logradouro.isValid ||
        !numero.isValid ||
        !bairro.isValid ||
        !cep.isValid ||
        !municipio.isValid) return null;

    return {
      'logradouro': logradouro.value!,
      'numero': numero.value!,
      'complemento': complemento.value ?? '',
      'bairro': bairro.value!,
      'cep': cep.value!,
      'ponto_referencia': pontoReferencia.value ?? '',
      'municipio': municipio.value!,
    };
  }
}
