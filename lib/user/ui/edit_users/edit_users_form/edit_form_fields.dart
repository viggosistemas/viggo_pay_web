import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditUsersFormField extends BaseForm with EditUsersFormFieldValidation {
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name =>
      _nameController.stream.transform(nameValidation);
  Function(String) get onNameChange => _nameController.sink.add;

  final _emailController = BehaviorSubject<String>();
  Stream<String> get email =>
      _emailController.stream.transform(emailValidation);
  Function(String) get onEmailChange => _emailController.sink.add;

  final _domainIdController = BehaviorSubject<String>();
  Stream<String> get domainId =>
      _domainIdController.stream.transform(domainValidation);
  Function(String) get onDomainIdChange =>
      _domainIdController.sink.add;


  @override
  List<Stream<String>> getStreams() => [name];

  @override
  Map<String, String>? getFields() {
    var name = _nameController.valueOrNull;
    var email = _emailController.valueOrNull;
    var domainId = _domainIdController.valueOrNull;

    if (name == null || email == null) return null;

    return {
      'name': name,
      'email': email,
      'domain_id': domainId ?? '',
    };
  }
}

mixin EditUsersFormFieldValidation {
  final nameValidation = StreamTransformer<String, String>.fromHandlers(
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
        Validator().isEmptyValue,
        Validator().isEmailValid
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final domainValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
