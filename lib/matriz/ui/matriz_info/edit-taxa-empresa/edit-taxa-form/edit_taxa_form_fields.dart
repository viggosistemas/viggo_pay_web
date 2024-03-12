import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class ConfigMatrizTaxaFormFields extends BaseForm
    with ConfigMatrizTaxasFormFieldsValidation {
  final _porcentagemController = BehaviorSubject<bool>();
  Stream<bool> get porcentagem => _porcentagemController.stream;
  Function(bool) get onPorcentagemChange => _porcentagemController.sink.add;

  final _taxaController = BehaviorSubject<String>();
  Stream<String> get taxa => _taxaController.stream.transform(taxaValidation);
  Function(String) get onTaxaChange => _taxaController.sink.add;

  @override
  List<Stream<String>> getStreams() => [taxa];

  @override
  Map<String, String>? getFields() {
    var porcentagem = _porcentagemController.valueOrNull;
    var taxa = _taxaController.valueOrNull;

    if (porcentagem == null && taxa == null) {
      return null;
    } else if (porcentagem == null) {
      return {
        'taxa': taxa.toString(),
      };
    } else if (taxa == null) {
      return {
        'porcentagem': porcentagem.toString(),
      };
    } else {
      return {
        'porcentagem': porcentagem.toString(),
        'taxa': taxa.toString(),
      };
    }
  }
}

mixin ConfigMatrizTaxasFormFieldsValidation {
  final porcentagemValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final taxaValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
