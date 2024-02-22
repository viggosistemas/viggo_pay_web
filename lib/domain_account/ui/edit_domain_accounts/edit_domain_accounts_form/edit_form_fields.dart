import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditDomainAccountFormFields extends BaseForm with EditDomainAccountsFormFieldsValidation {
  final _clientNameController = BehaviorSubject<String>();
  Stream<String> get clientName =>
      _clientNameController.stream.transform(clientNameValidation);
  Function(String) get onClientNameChange => _clientNameController.sink.add;

  @override
  List<Stream<String>> getStreams() => [clientName];

  @override
  Map<String, String>? getFields() {
    var clientName = _clientNameController.valueOrNull;

    if (clientName == null) return null;

    return {
      'client_name': clientName,
    };
  }
}

mixin EditDomainAccountsFormFieldsValidation {
  final clientNameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
