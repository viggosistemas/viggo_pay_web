import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/cpf_cnpj_validator.dart';
import 'package:viggo_pay_core_frontend/form/field_length_validator.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditInfoFormFields extends BaseForm with EditInfosFormFieldsValidation {
  final _clientNameController = BehaviorSubject<String>();
  Stream<String> get clientName =>
      _clientNameController.stream.transform(clientNameValidation);
  Function(String) get onClientNameChange => _clientNameController.sink.add;

  final _clientTaxIdController = BehaviorSubject<String>();
  Stream<String> get clientTaxId =>
      _clientTaxIdController.stream.transform(clientTaxIdValidation);
  Function(String) get onClientTaxIdChange => _clientTaxIdController.sink.add;

  final _clientTaxCountryController = BehaviorSubject<String>();
  Stream<String> get clientTaxCountry =>
      _clientTaxCountryController.stream.transform(clientTaxCountryValidation);
  Function(String) get onClientTaxCountryChange =>
      _clientTaxCountryController.sink.add;

  final _clientMobilePhoneController = BehaviorSubject<String>();
  Stream<String> get clientMobilePhone => _clientMobilePhoneController.stream
      .transform(clientMobilePhoneValidation);
  Function(String) get onClientMobilePhoneChange =>
      _clientMobilePhoneController.sink.add;

  final _clientMobilePhoneCountryController = BehaviorSubject<String>();
  Stream<String> get clientMobilePhoneCountry =>
      _clientMobilePhoneCountryController.stream
          .transform(clientMobilePhoneCountryValidation);
  Function(String) get onClientMobilePhoneCountryChange =>
      _clientMobilePhoneCountryController.sink.add;

  final _clientEmailController = BehaviorSubject<String>();
  Stream<String> get clientEmail =>
      _clientEmailController.stream.transform(clientEmailValidation);
  Function(String) get onClientEmailChange => _clientEmailController.sink.add;

  @override
  List<Stream<String>> getStreams() => [
        clientName,
        clientTaxId,
        clientTaxCountry,
        clientMobilePhone,
        clientMobilePhoneCountry,
        clientEmail,
      ];

  @override
  Map<String, String>? getFields() {
    var clientName = _clientNameController.valueOrNull;
    var clientTaxId = _clientTaxIdController.valueOrNull;
    var clientTaxCountry = _clientTaxCountryController.valueOrNull;
    var clientMobilePhone = _clientMobilePhoneController.valueOrNull;
    var clientMobilePhoneCountry =
        _clientMobilePhoneCountryController.valueOrNull;
    var clientEmail = _clientEmailController.valueOrNull;

    if (clientName == null ||
        clientTaxId == null ||
        clientTaxCountry == null ||
        clientMobilePhone == null ||
        clientMobilePhoneCountry == null ||
        clientEmail == null) return null;

    return {
      'client_name': clientName,
      'client_tax_identifier_tax_id': clientTaxId,
      'client_mobile_phone': clientMobilePhone,
      'client_mobile_phone_country': clientMobilePhoneCountry,
      'client_email': clientEmail,
      'client_tax_identifier_country': clientTaxCountry,
    };
  }
}

mixin EditInfosFormFieldsValidation {
  final clientNameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ150,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final clientTaxIdValidation = StreamTransformer<String, String>.fromHandlers(
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
  final clientTaxCountryValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ3,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final clientMobilePhoneValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ30,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final clientMobilePhoneCountryValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ3,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final clientEmailValidation = StreamTransformer<String, String>.fromHandlers(
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
}
