import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditDomainFormFields extends BaseForm
    with EditDomainsFormFieldsValidation {
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name => _nameController.stream.transform(nameValidation);
  Function(String) get onNameChange => _nameController.sink.add;

  final _displayNameController = BehaviorSubject<String>();
  Stream<String> get displayName =>
      _displayNameController.stream.transform(displayNameValidation);
  Function(String) get onDisplayNameChange => _displayNameController.sink.add;

  final _applicationIdController = BehaviorSubject<String>();
  Stream<String> get applicationId =>
      _applicationIdController.stream.transform(applicationValidation);
  Function(String) get onApplicationIdChange =>
      _applicationIdController.sink.add;

  final _descriptionController = BehaviorSubject<String>();
  Stream<String> get description =>
      _descriptionController.stream.transform(descriptionValidation);
  Function(String) get onDescriptionChange => _descriptionController.sink.add;

  final _emailController = BehaviorSubject<String>();
  Stream<String> get email =>
      _emailController.stream.transform(emailValidation);
  Function(String) get onEmailChange => _emailController.sink.add;

  final _passwordController = BehaviorSubject<String>();
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidation);
  Function(String) get onPasswordChange => _passwordController.sink.add;

  @override
  List<Stream<String>> getStreams() =>
      [name, displayName, description, applicationId];

  @override
  Map<String, String>? getFields() {
    var name = _nameController.valueOrNull;
    var displayName = _displayNameController.valueOrNull;
    var description = _descriptionController.valueOrNull;
    var applicationId = _applicationIdController.valueOrNull;
    var email = _emailController.valueOrNull;
    var password = _passwordController.valueOrNull;

    if (name == null || displayName == null || applicationId == null) {
      return null;
    }
    return {
      'name': name,
      'display_name': displayName,
      'description': description ?? '',
      'application_id': applicationId,
      'email': email ?? '',
      'password': password ?? '',
    };
  }
}

mixin EditDomainsFormFieldsValidation {
  final nameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final displayNameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final descriptionValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final applicationValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
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
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final passwordValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        Validator().isPasswordStrong,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
