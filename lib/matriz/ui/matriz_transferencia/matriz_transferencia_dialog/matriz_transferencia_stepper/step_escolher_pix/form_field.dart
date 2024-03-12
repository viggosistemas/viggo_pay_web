import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditSelectPixStepFormFields extends BaseForm
    with EditInfosFormFieldsValidation {
  final _contatoController = BehaviorSubject<String>();
  Stream<String> get contato =>
      _contatoController.stream.transform(contatoValidation);
  Function(String) get onContatoChange => _contatoController.sink.add;

  final _pixSelectController = BehaviorSubject<String>();
  Stream<String> get pixSelect =>
      _pixSelectController.stream.transform(pixSelectValidation);
  Function(String) get onPixSelectChange => _pixSelectController.sink.add;

  @override
  List<Stream<String>> getStreams() => [pixSelect];

  @override
  Map<String, String>? getFields() {
    var contato = _contatoController.valueOrNull;
    var pixSelect = _pixSelectController.valueOrNull;

    if(pixSelect == null) return null;

    return {
      'contato': contato ?? '',
      'pixSelect': pixSelect,
    };
  }
}

mixin EditInfosFormFieldsValidation {
  final contatoValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final pixSelectValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
