import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditApplicationFormFields extends BaseForm with EditApplicationsFormFieldsValidation {
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name => _nameController.stream.transform(nameValidation);
  Function(String) get onNameChange => _nameController.sink.add;

  final _descriptionController = BehaviorSubject<String>();
  Stream<String> get description => _descriptionController.stream.transform(descriptionValidation);
  Function(String) get onDescriptionChange => _descriptionController.sink.add;

  @override
  List<Stream<String>> getStreams() => [name];

  @override
  Map<String, String>? getFields() {
    var name = _nameController.valueOrNull;
    var description = _descriptionController.valueOrNull;

    if (name == null || description == null) {
      return null;
    }
    return {
      'name': name,
      'description': description
    };
  }
}

mixin EditApplicationsFormFieldsValidation {
  final nameValidation = StreamTransformer<String, String>.fromHandlers(
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
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
