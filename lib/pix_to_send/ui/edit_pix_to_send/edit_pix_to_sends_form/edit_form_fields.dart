import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditPixToSendFormFields extends BaseForm
    with EditPixToSendsFormFieldsValidation {
  final _aliasController = BehaviorSubject<String>();
  Stream<String> get alias =>
      _aliasController.stream.transform(aliasValidation);
  Function(String) get onAliasChange => _aliasController.sink.add;

  final _pspIdController = BehaviorSubject<String>();
  Stream<String> get pspId =>
      _pspIdController.stream.transform(pspIdValidation);
  Function(String) get onPspIdChange => _pspIdController.sink.add;

  final _taxIdentifierTaxIdController = BehaviorSubject<String>();
  Stream<String> get taxIdentifierTaxId => _taxIdentifierTaxIdController.stream
      .transform(taxIdentifierTaxIdValidation);
  Function(String) get onTaxIdendifierTaxIdChange =>
      _taxIdentifierTaxIdController.sink.add;

  final _taxIdentifierCountryController = BehaviorSubject<String>();
  Stream<String> get taxIdentifierCountry =>
      _taxIdentifierCountryController.stream
          .transform(taxIdentifierCountryValidation);
  Function(String) get onTaxIdentifierCountryChange =>
      _taxIdentifierCountryController.sink.add;

  final _endToEndIdQueryController = BehaviorSubject<String>();
  Stream<String> get endToEndIdQuery =>
      _endToEndIdQueryController.stream.transform(endToEndIdQueryValidation);
  Function(String) get onEndToEndIdQueryChange =>
      _endToEndIdQueryController.sink.add;

  final _accountDestinationBranchController = BehaviorSubject<String>();
  Stream<String> get accountDestinationBranch =>
      _accountDestinationBranchController.stream
          .transform(accountDestinationBranchValidation);
  Function(String) get onAccountDestinationBranchChange =>
      _accountDestinationBranchController.sink.add;

  final _accountDestinationAccountController = BehaviorSubject<String>();
  Stream<String> get accountDestinationAccount =>
      _accountDestinationAccountController.stream
          .transform(accountDestinationAccountValidation);
  Function(String) get onAccountDestinationAccountChange =>
      _accountDestinationAccountController.sink.add;

  final _accountDestinationAccountTypeController = BehaviorSubject<String>();
  Stream<String> get accountDestinationAccountType =>
      _accountDestinationAccountTypeController.stream
          .transform(accountDestinationAccountTypeValidation);
  Function(String) get onAccountDestinationAccountTypeChange =>
      _accountDestinationAccountTypeController.sink.add;

  @override
  List<Stream<String>> getStreams() => [alias];

  @override
  Map<String, String>? getFields() {
    var alias = _aliasController.valueOrNull;
    var pspId = _pspIdController.valueOrNull;
    var taxIdentifierTaxId = _taxIdentifierTaxIdController.valueOrNull;
    var taxIdentifierCountry = _taxIdentifierCountryController.valueOrNull;
    var endToEndIdQuery = _endToEndIdQueryController.valueOrNull;
    var accountDestinationBranch =
        _accountDestinationBranchController.valueOrNull;
    var accountDestinationAccount =
        _accountDestinationAccountController.valueOrNull;
    var accountDestinationAccountType =
        _accountDestinationAccountTypeController.valueOrNull;

    if (alias == null ||
        pspId == null ||
        taxIdentifierTaxId == null ||
        taxIdentifierCountry == null ||
        endToEndIdQuery == null ||
        accountDestinationBranch == null ||
        accountDestinationAccount == null ||
        accountDestinationAccountType == null) return null;

    return {
      'alias': alias,
      'pspId': pspId,
      'taxIdentifierTaxId': taxIdentifierTaxId,
      'taxIdentifierCountry': taxIdentifierCountry,
      'endToEndIdQuery': endToEndIdQuery,
      'accountDestinationBranch': accountDestinationBranch,
      'accountDestinationAccount': accountDestinationAccount,
      'accountDestinationAccountType': accountDestinationAccountType,
    };
  }
}

mixin EditPixToSendsFormFieldsValidation {
  final aliasValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final pspIdValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final taxIdentifierTaxIdValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final taxIdentifierCountryValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final endToEndIdQueryValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final accountDestinationBranchValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final accountDestinationAccountValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final accountDestinationAccountTypeValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
