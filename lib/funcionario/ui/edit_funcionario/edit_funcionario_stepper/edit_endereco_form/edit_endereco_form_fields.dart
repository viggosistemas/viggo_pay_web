import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/field_length_validator.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditEnderecoFormFields extends BaseForm
    with EditEnderecoFormFieldsValidation {
  final _logradouroController = BehaviorSubject<String>();
  Stream<String> get logradouro =>
      _logradouroController.stream.transform(logradouroValidation);
  Function(String) get onLogradouroChange => _logradouroController.sink.add;

  final _numeroController = BehaviorSubject<String>();
  Stream<String> get numero =>
      _numeroController.stream.transform(numeroValidation);
  Function(String) get onNumeroChange => _numeroController.sink.add;

  final _complementoController = BehaviorSubject<String>();
  Stream<String> get complemento =>
      _complementoController.stream.transform(complementoValidation);
  Function(String) get onComplementoChange => _complementoController.sink.add;

  final _bairroController = BehaviorSubject<String>();
  Stream<String> get bairro =>
      _bairroController.stream.transform(bairroValidation);
  Function(String) get onBairroChange => _bairroController.sink.add;

  final _cepController = BehaviorSubject<String>();
  Stream<String> get cep => _cepController.stream.transform(cepValidation);
  Function(String) get onCepChange => _cepController.sink.add;

  final _pontoReferenciaController = BehaviorSubject<String>();
  Stream<String> get pontoReferencia =>
      _pontoReferenciaController.stream.transform(pontoReferenciaValidation);
  Function(String) get onPontoReferenciaChange =>
      _pontoReferenciaController.sink.add;

  final _municipioController = BehaviorSubject<String>();
  Stream<String> get municipio =>
      _municipioController.stream.transform(municipioValidation);
  Function(String) get onMunicipioChange => _municipioController.sink.add;

  final _municipioNameController = BehaviorSubject<String>();
  Stream<String> get municipioName =>
      _municipioNameController.stream.transform(municipioValidation);
  Function(String) get onMunicipioNameChange =>
      _municipioNameController.sink.add;

  @override
  List<Stream<String>> getStreams() => [
        logradouro,
        numero,
        complemento,
        bairro,
        cep,
        pontoReferencia,
        municipio,
        municipioName,
      ];

  @override
  Map<String, String>? getFields() {
    var logradouro = _logradouroController.valueOrNull;
    var numero = _numeroController.valueOrNull;
    var complemento = _complementoController.valueOrNull;
    var bairro = _bairroController.valueOrNull;
    var cep = _cepController.valueOrNull;
    var pontoReferencia = _pontoReferenciaController.valueOrNull;
    var municipio = _municipioController.valueOrNull;

    if (logradouro == null ||
        numero == null ||
        bairro == null ||
        cep == null ||
        municipio == null) return null;

    return {
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento ?? '',
      'bairro': bairro,
      'cep': cep,
      'ponto_referencia': pontoReferencia ?? '',
      'municipio': municipio,
    };
  }
}

mixin EditEnderecoFormFieldsValidation {
  final logradouroValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ255,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final numeroValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ60,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final complementoValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ60,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final bairroValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ60,
        FieldLengthValidator().menorQ3,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final cepValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final pontoReferenciaValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ500
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final municipioValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
