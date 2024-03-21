import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/cpf_cnpj_validator.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/field_length_validator.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditInfoFormFields extends BaseForm {
  final clientName = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ150,
    ],
  );
  final clientTaxId = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      CPFCNPJValidator().validateCNPJ,
      FieldLengthValidator().maiorQ14,
    ],
  );
  final clientTaxCountry = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ3,
    ],
  );
  final clientMobilePhone = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ30,
    ],
  );
  final clientMobilePhoneCountry = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ3,
    ],
  );
  final clientEmail = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      Validator().isEmailValid,
      FieldLengthValidator().maiorQ80,
    ],
  );

  @override
  List<Field> getFields() => [
        clientName,
        clientTaxId,
        clientTaxCountry,
        clientMobilePhone,
        clientMobilePhoneCountry,
        clientEmail,
      ];

  @override
  Map<String, String>? getValues() {
    if (!clientName.isValid ||
        !clientTaxId.isValid ||
        !clientTaxCountry.isValid ||
        !clientMobilePhone.isValid ||
        !clientMobilePhoneCountry.isValid ||
        !clientEmail.isValid) return null;

    return {
      'client_name': clientName.value!,
      'client_tax_identifier_tax_id': clientTaxId.value!,
      'client_mobile_phone': clientMobilePhone.value!,
      'client_mobile_phone_country': clientMobilePhoneCountry.value!,
      'client_email': clientEmail.value!,
      'client_tax_identifier_country': clientTaxCountry.value!,
    };
  }
}
