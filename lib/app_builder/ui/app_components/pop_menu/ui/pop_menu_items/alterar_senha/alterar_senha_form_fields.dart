import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class AlterarSenhaFormFields extends BaseForm
    with AlterarSenhaFormFieldsValidation {
  final _senhaAntigaController = BehaviorSubject<String>();
  Stream<String> get senhaAntiga =>
      _senhaAntigaController.stream.transform(senhaAntigaValidation);
  Function(String) get onSenhaAntigaChange => _senhaAntigaController.sink.add;

  final _novaSenhaController = BehaviorSubject<String>();
  Stream<String> get novaSenha =>
      _novaSenhaController.stream.transform(novaSenhaValidation);
  Function(String) get onNovaSenhaChange => _novaSenhaController.sink.add;

  final _confirmarSenhaController = BehaviorSubject<String>();
  Stream<String> get confirmarSenha =>
      _confirmarSenhaController.stream.transform(confirmarSenhaValidation);
  Function(String) get onConfirmarSenha => _confirmarSenhaController.sink.add;

  @override
  List<Stream<String>> getStreams() => [senhaAntiga, novaSenha, confirmarSenha];

  @override
  Map<String, String>? getFields() {
    var senhaAntiga = _senhaAntigaController.valueOrNull;
    var novaSenha = _novaSenhaController.valueOrNull;
    var confirmarSenha = _confirmarSenhaController.valueOrNull;

    if (senhaAntiga == null || novaSenha == null || confirmarSenha == null) return null;

    return {
      'senhaAntiga': senhaAntiga,
      'novaSenha': novaSenha,
      'confirmarSenha': confirmarSenha,
    };
  }
}

mixin AlterarSenhaFormFieldsValidation {
  final senhaAntigaValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final novaSenhaValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        Validator().isPasswordStrong,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final confirmarSenhaValidation = StreamTransformer<String, String>.fromHandlers(
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
