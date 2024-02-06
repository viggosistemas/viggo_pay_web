import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class LoginFormFields extends BaseForm with LoginFormFieldsValidation {
  final _domainController = BehaviorSubject<String>();
  Stream<String> get domain =>
      _domainController.stream.transform(domainValidation);
  Function(String) get onDomainChange => _domainController.sink.add;

  final _usernameController = BehaviorSubject<String>();
  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidation);
  Function(String) get onEmailChange => _usernameController.sink.add;

  final _passwordController = BehaviorSubject<String>();
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidation);
  Function(String) get onPasswordChange => _passwordController.sink.add;

  final _rememberController = BehaviorSubject<bool>();
  Stream<bool> get remember => _rememberController.stream;
  Function(bool) get onRememberChange => _rememberController.sink.add;

  @override
  List<Stream<String>> getStreams() => [domain, username, password];

  @override
  Map<String, String>? getFields() {
    var domain = _domainController.valueOrNull;
    var username = _usernameController.valueOrNull;
    var password = _passwordController.valueOrNull;

    if (domain == null || username == null || password == null) return null;

    return {
      'domain': domain,
      'username': username,
      'password': password,
    };
  }

  Map<String, dynamic>? getRememberFields() {
    var domain = _domainController.valueOrNull;
    var username = _usernameController.valueOrNull;
    var remember = _rememberController.valueOrNull;

    if (domain == null || username == null || remember == null) return null;

    return {
      "domain_name": domain,
      "usernameOrEmail": username,
      "rememberCredentials": remember,
    };
  }
}

mixin LoginFormFieldsValidation {
  final domainValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [Validator().isRequired];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final usernameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [Validator().isRequired];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final passwordValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [Validator().isRequired];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
