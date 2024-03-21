import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/field_length_validator.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditAddressFormFields extends BaseForm {
  final logradouro = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ100,
    ],
  );
  final numero = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ10,
    ],
  );
  final complemento = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ500,
    ],
  );
  final bairro = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ100,
    ],
  );
  final cidade = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ100,
    ],
  );
  final estado = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ100,
    ],
  );
  final cep = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ20,
    ],
  );
  final pais = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ3,
    ],
  );

  @override
  List<Field> getFields() => [
        logradouro,
        numero,
        complemento,
        bairro,
        cidade,
        estado,
        cep,
        pais,
      ];

  @override
  Map<String, String>? getValues() {
    if (!logradouro.isValid ||
        !numero.isValid ||
        !complemento.isValid ||
        !bairro.isValid ||
        !cidade.isValid ||
        !estado.isValid ||
        !cep.isValid ||
        !pais.isValid) return null;

    return {
      'billing_address_logradouro': logradouro.value!,
      'billing_address_numero': numero.value!,
      'billing_address_complemento': complemento.value!,
      'billing_address_bairro': bairro.value!,
      'billing_address_cidade': cidade.value!,
      'billing_address_estado': estado.value!,
      'billing_address_cep': cep.value!,
      'billing_address_pais': pais.value!,
    };
  }
}
