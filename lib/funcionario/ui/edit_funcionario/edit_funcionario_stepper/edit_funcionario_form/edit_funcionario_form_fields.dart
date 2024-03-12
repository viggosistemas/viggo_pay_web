import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/cpf_cnpj_validator.dart';
import 'package:viggo_pay_core_frontend/form/field_length_validator.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class EditFuncionarioFormFields extends BaseForm
    with EditFuncionarioFormFieldsValidation {
  final _cpfCnpjController = BehaviorSubject<String>();
  Stream<String> get cpfCnpj =>
      _cpfCnpjController.stream.transform(cpfCnpjValidation);
  Function(String) get onCpfCnpjChange => _cpfCnpjController.sink.add;

  final _nomeRazaoSocialController = BehaviorSubject<String>();
  Stream<String> get nomeRazaoSocial =>
      _nomeRazaoSocialController.stream.transform(nomeRazaoSocialValidation);
  Function(String) get onNomeRazaoSocialChange =>
      _nomeRazaoSocialController.sink.add;

  final _rgInscEstController = BehaviorSubject<String>();
  Stream<String> get rgInscEst =>
      _rgInscEstController.stream.transform(rgInscEstValidation);
  Function(String) get onRgInscEstChange => _rgInscEstController.sink.add;

  final _apelidoNomeFantasiaContoller = BehaviorSubject<String>();
  Stream<String> get apelidoNomeFantasia => _apelidoNomeFantasiaContoller.stream
      .transform(apelidoNomeFantasiaValidation);
  Function(String) get onApelidoNomeFantasiaChange =>
      _apelidoNomeFantasiaContoller.sink.add;

  final _userIdController = BehaviorSubject<String>();
  Stream<String> get userId =>
      _userIdController.stream.transform(userValidation);
  Function(String) get onUserIdChange => _userIdController.sink.add;

  @override
  List<Stream<String>> getStreams() => [
        cpfCnpj,
        nomeRazaoSocial,
        rgInscEst,
        apelidoNomeFantasia,
      ];

  @override
  Map<String, String>? getFields() {
    var cpfCnpj = _cpfCnpjController.valueOrNull;
    var nomeRazaoSocial = _nomeRazaoSocialController.valueOrNull;
    var rgInscEst = _rgInscEstController.valueOrNull;
    var apelidoNomeFantasia = _apelidoNomeFantasiaContoller.valueOrNull;
    var userId = _userIdController.valueOrNull;

    if (cpfCnpj == null || nomeRazaoSocial == null) return null;

    return {
      'cpf_cnpj': cpfCnpj,
      'nome_razao_social': nomeRazaoSocial,
      'rg_insc_est': rgInscEst ?? '',
      'apelido_nome_fantasia': apelidoNomeFantasia ?? '',
      'user_id': userId ?? '',
    };
  }
}

mixin EditFuncionarioFormFieldsValidation {
  final cpfCnpjValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        CPFCNPJValidator().validateCPFOuCNPJ,
        FieldLengthValidator().maiorQ14,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final nomeRazaoSocialValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ60,
        FieldLengthValidator().menorQ1,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final rgInscEstValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ20,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final apelidoNomeFantasiaValidation =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
        FieldLengthValidator().maiorQ60,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
  final userValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
