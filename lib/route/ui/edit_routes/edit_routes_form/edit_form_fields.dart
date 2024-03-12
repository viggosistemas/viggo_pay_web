import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditRouteFormFields extends BaseForm with EditRoutesFormFieldsValidation {
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name => _nameController.stream.transform(nameValidation);
  Function(String) get onNameChange => _nameController.sink.add;

  final _urlController = BehaviorSubject<String>();
  Stream<String> get url => _urlController.stream.transform(urlValidation);
  Function(String) get onUrlChange => _urlController.sink.add;

  final _methodController = BehaviorSubject<String>();
  Stream<String> get method =>
      _methodController.stream.transform(methodValidation);
  Function(String) get onMethodChange => _methodController.sink.add;

  final _bypassController = BehaviorSubject<bool?>();
  Stream<bool?> get bypass => _bypassController.stream;
  Function(bool?) get onBypassChange => _bypassController.sink.add;

  final _sysadminController = BehaviorSubject<bool?>();
  Stream<bool?> get sysadmin => _sysadminController.stream;
  Function(bool?) get onSysadminChange => _sysadminController.sink.add;

  @override
  List<Stream<String>> getStreams() => [name, url, method];

  @override
  Map<String, String>? getFields() {
    var name = _nameController.valueOrNull;
    var url = _urlController.valueOrNull;
    var method = _methodController.valueOrNull;
    var bypass = _bypassController.valueOrNull;
    var sysadmin = _sysadminController.valueOrNull;

    if (name == null || url == null || method == null) {
      return null;
    }
    return {
      'name': name,
      'url': url,
      'method': method,
      'bypass': bypass.toString(),
      'sysadmin': sysadmin.toString(),
    };
  }
}

mixin EditRoutesFormFieldsValidation {
  final nameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final urlValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final methodValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
