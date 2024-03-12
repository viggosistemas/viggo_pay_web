import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditSenhaStepFormFields extends BaseForm with EditSenhaFormFieldsValidation {
  final _senhaController = BehaviorSubject<String>();
  Stream<String> get senha =>
      _senhaController.stream.transform(senhaValidation);
  Function(String) get onSenhaChange => _senhaController.sink.add;

  @override
  List<Stream<String>> getStreams() => [senha];

  @override
  Map<String, String>? getFields() {
    var senha = _senhaController.valueOrNull;

    if(senha == null) return null;

    return {
      'senha': senha,
    };
  }
}

mixin EditSenhaFormFieldsValidation {
  final senhaValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        // FieldLengthValidator().menorQ6,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
