import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class ForgetPassWordFormFields extends BaseForm
    with ForgetPasswordFormFieldsValidation {
  final _domainController = BehaviorSubject<String>();
  Stream<String> get domain =>
      _domainController.stream.transform(domainValidation);
  Function(String) get onDomainChange => _domainController.sink.add;

  final _usernameController = BehaviorSubject<String>();
  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidation);
  Function(String) get onEmailChange => _usernameController.sink.add;

  @override
  List<Stream<String>> getStreams() => [domain, username];

  @override
  Map<String, String>? getFields() {
    var domain = _domainController.valueOrNull;
    var username = _usernameController.valueOrNull;

    if (domain == null || username == null) return null;

    return {
      'domain': domain,
      'username': username,
    };
  }
}

mixin ForgetPasswordFormFieldsValidation {
  final domainValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final usernameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        // Validator().isEmailValid, FIXME: POR ALGUM MOTIVO ELE NAO PERMITE PREENCHER O CAMPO
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
