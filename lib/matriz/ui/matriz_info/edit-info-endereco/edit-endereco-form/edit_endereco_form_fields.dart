import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/field_length_validator.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditInfoEnderecoFormFields extends BaseForm with EditInfosEnderecoFormFieldsValidation {
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

  final _cidadeController = BehaviorSubject<String>();
  Stream<String> get cidade =>
      _cidadeController.stream.transform(cidadeValidation);
  Function(String) get onCidadeChange => _cidadeController.sink.add;

  final _estadoController = BehaviorSubject<String>();
  Stream<String> get estado =>
      _estadoController.stream.transform(estadoValidation);
  Function(String) get onEstadoChange => _estadoController.sink.add;

  final _cepController = BehaviorSubject<String>();
  Stream<String> get cep => _cepController.stream.transform(cepValidation);
  Function(String) get onCepChange => _cepController.sink.add;

  final _paisController = BehaviorSubject<String>();
  Stream<String> get pais => _paisController.stream.transform(paisValidation);
  Function(String) get onPaisChange => _paisController.sink.add;

  @override
  List<Stream<String>> getStreams() => [
        logradouro,
        numero,
        complemento,
        bairro,
        cidade,
        estado,
        cep,
        pais,
      ];

  @override
  Map<String, String>? getFields() {
    var logradouro = _logradouroController.valueOrNull;
    var numero = _numeroController.valueOrNull;
    var complemento = _complementoController.valueOrNull;
    var bairro = _bairroController.valueOrNull;
    var cidade = _cidadeController.valueOrNull;
    var estado = _estadoController.valueOrNull;
    var cep = _cepController.valueOrNull;
    var pais = _paisController.valueOrNull;

    if (logradouro == null ||
        numero == null ||
        complemento == null ||
        bairro == null ||
        cidade == null ||
        estado == null ||
        cep == null ||
        pais == null) return null;

    return {
      'billing_address_logradouro': logradouro,
      'billing_address_numero': numero,
      'billing_address_complemento': complemento,
      'billing_address_bairro': bairro,
      'billing_address_cidade': cidade,
      'billing_address_estado': estado,
      'billing_address_cep': cep,
      'billing_address_pais': pais,
    };
  }
}

mixin EditInfosEnderecoFormFieldsValidation {
  final logradouroValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ100,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final numeroValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ10,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final complementoValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ500,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final bairroValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ100,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final cidadeValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ100,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final estadoValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ100,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final cepValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ20,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final paisValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ3,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  
  final establishmentDateValid = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        FieldLengthValidator().maiorQ10,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );

  final companyNameValid = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        FieldLengthValidator().maiorQ150,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
