import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/field_length_validator.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditContatoFormFields extends BaseForm
    with EditContatoFormFieldsValidation {
  final _contatoController = BehaviorSubject<String>();
  Stream<String> get contato =>
      _contatoController.stream.transform(contatoValidation);
  Function(String) get onContatoChange => _contatoController.sink.add;

  final _contatosController = BehaviorSubject<String>();
  Stream<String> get contatos =>
      _contatosController.stream;
  Function(String) get onContatosChange => _contatosController.sink.add;

  @override
  List<Stream<String>> getStreams() => [contato];

  @override
  Map<String, String>? getFields() {
    var contato = _contatoController.valueOrNull;
    var contatos = _contatosController.valueOrNull;

    return {
      'contato': contato ?? '',
      'contatos': contatos ?? ''
    };
  }
}

mixin EditContatoFormFieldsValidation {
  final contatoValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ100,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
