import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditPixToSendFormFields extends BaseForm with EditPixToSendsFormFieldsValidation {
  final _aliasController = BehaviorSubject<String>();
  Stream<String> get alias =>
      _aliasController.stream.transform(aliasValidation);
  Function(String) get onAliasChange => _aliasController.sink.add;

  @override
  List<Stream<String>> getStreams() => [alias];

  @override
  Map<String, String>? getFields() {
    var alias = _aliasController.valueOrNull;

    if (alias == null) return null;

    return {
      'alias': alias,
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
}
