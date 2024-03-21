import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/cpf_cnpj_validator.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/field_length_validator.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditInfoFormFields extends BaseForm {
  final name = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ150,
    ],
  );
  final taxId = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      CPFCNPJValidator().validateCNPJ,
      FieldLengthValidator().maiorQ14,
    ],
  );
  final email = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      Validator().isEmailValid,
      FieldLengthValidator().maiorQ80,
    ],
  );
  final phone = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ30,
    ],
  );
  final countryPhone = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ3,
    ],
  );
  final countryTax = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ3,
    ],
  );

  @override
  List<Field> getFields() => [
        name,
        taxId,
        email,
        phone,
        countryPhone,
        countryTax,
      ];

  @override
  Map<String, String>? getValues() {
    if (!name.isValid || !taxId.isValid || !email.isValid || !phone.isValid) {
      return null;
    }

    return {
      'client_name': name.value!,
      'client_tax_identifier_tax_id': taxId.value!,
      'client_email': email.value!,
      'client_mobile_phone_phone_number': phone.value!,
      'client_mobile_phone_country': countryPhone.value ?? 'BRA',
    };
  }
}
