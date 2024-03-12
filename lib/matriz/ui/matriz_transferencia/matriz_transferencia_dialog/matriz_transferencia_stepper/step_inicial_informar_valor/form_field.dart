import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditValorStepFormFields extends BaseForm with EditInfosFormFieldsValidation {
  final _valorController = BehaviorSubject<String>();
  Stream<String> get valor =>
      _valorController.stream.transform(valorValidation);
  Function(String) get onValorChange => _valorController.sink.add;

  @override
  List<Stream<String>> getStreams() => [valor];

  @override
  Map<String, String>? getFields() {
    var valor = _valorController.valueOrNull;

    return {
      'valor': valor ?? '0',
    };
  }
}

mixin EditInfosFormFieldsValidation {
  final valorValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
