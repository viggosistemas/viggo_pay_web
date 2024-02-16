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

  final _emailController = BehaviorSubject<String>();
  Stream<String> get email =>
      _emailController.stream.transform(emailValidation);
  Function(String) get onEmailChange => _emailController.sink.add;

  @override
  List<Stream<String>> getStreams() => [domain, email];

  @override
  Map<String, String>? getFields() {
    var domain = _domainController.valueOrNull;
    var email = _emailController.valueOrNull;

    if (domain == null || email == null) return null;

    return {
      'domain': domain,
      'email': email,
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

  final emailValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmailValid,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
