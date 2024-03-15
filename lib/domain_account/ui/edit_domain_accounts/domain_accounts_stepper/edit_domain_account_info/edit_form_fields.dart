import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/cpf_cnpj_validator.dart';
import 'package:viggo_pay_core_frontend/form/field_length_validator.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditInfoFormFields extends BaseForm
    with EditInfoFormFieldsValidation {
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name => _nameController.stream.transform(nameValidation);
  Function(String) get onNameChange => _nameController.sink.add;

  final _taxIdController = BehaviorSubject<String>();
  Stream<String> get taxId =>
      _taxIdController.stream.transform(taxIdValidation);
  Function(String) get onTaxIdChange => _taxIdController.sink.add;

  final _emailController = BehaviorSubject<String>();
  Stream<String> get email => _emailController.stream.transform(emailValidation);
  Function(String) get onEmailChange => _emailController.sink.add;

  final _phoneController = BehaviorSubject<String>();
  Stream<String> get phone => _phoneController.stream.transform(phoneValidation);
  Function(String) get onPhoneChange => _phoneController.sink.add;

  final _countryPhoneController = BehaviorSubject<String>();
  Stream<String> get countryPhone => _countryPhoneController.stream.transform(countryPhoneValidation);
  Function(String) get onCountryPhoneChange => _countryPhoneController.sink.add;

  final _countryTaxController = BehaviorSubject<String>();
  Stream<String> get countryTax => _countryTaxController.stream.transform(countryPhoneValidation);
  Function(String) get onClientTaxCountryChange => _countryTaxController.sink.add;

  @override
  List<Stream<String>> getStreams() => [name];

  @override
  Map<String, String>? getFields() {
    var name = _nameController.valueOrNull;
    var taxId = _taxIdController.valueOrNull;
    var email = _emailController.valueOrNull;
    var phone = _phoneController.valueOrNull;
    var countryPhone = _countryPhoneController.valueOrNull;

    if (name == null || taxId == null || email == null || phone == null) {
      return null;
    }

    return {
      'client_name': name,
      'client_tax_identifier_tax_id': taxId,
      'client_email': email,
      'client_mobile_phone_phone_number': phone,
      'client_mobile_phone_country': countryPhone ?? 'BRA',
    };
  }
}

mixin EditInfoFormFieldsValidation {
  final nameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ150,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final taxIdValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        CPFCNPJValidator().validateCNPJ,
        FieldLengthValidator().maiorQ14,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final emailValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        Validator().isEmailValid,
        FieldLengthValidator().maiorQ80,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final phoneValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ30,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final countryPhoneValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ3,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
