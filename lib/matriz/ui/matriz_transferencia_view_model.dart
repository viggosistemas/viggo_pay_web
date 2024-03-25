import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_config_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_password_pix_matera_use_case.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_alterar_senha_pix/alterar_senha_form_fields.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_escolher_pix/form_field.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_informar_senha/form_field.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_inicial_informar_valor/form_field.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/cashout_via_pix_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/consultar_alias_destinatario_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_saldo_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_transacoes_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_ultima_transacao_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/list_chave_pix_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_params_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/update_pix_to_send_use_case.dart';

class MatrizTransferenciaViewModel extends BaseViewModel {
  String materaId = '';
  String domainAccountId = '';
  String endToEndId = '';
  Map<String, dynamic> taxaMediatorFee = {};

  //USE_CASES
  final GetDomainAccountConfigByIdUseCase getConfigDomainAccount;
  final GetDomainAccountByIdUseCase getDomainAccount;
  final GetDomainFromSettingsUseCase getDomainFromSettings;
  final GetSaldoDomainAccountUseCase getSaldo;
  final GetTransacoesDomainAccountUseCase getTransacoes;
  final GetUltimaTransacaoDomainAccountUseCase getUltimaTransacao;
  final ListChavePixDomainAccountUseCase listChavePix;
  final GetPixToSendsByParamsUseCase listChavePixToSends;
  final ConsultarAliasDestinatarioUseCase consultarDestinatario;
  final UpdatePasswordPixUseCase updateSenhaPix;
  final UpdatePixToSendUseCase updatePixToSendSelect;
  final CashoutViaPixDomainAccountUseCase cashout;

  //FORMS_FIELDS
  final EditValorStepFormFields formStepValor = EditValorStepFormFields();
  final EditSelectPixStepFormFields formStepSelectPix =
      EditSelectPixStepFormFields();
  final EditSenhaStepFormFields formStepSenha = EditSenhaStepFormFields();

  final AlterarSenhaPixFormFields formSenha = AlterarSenhaPixFormFields();

  //STREAMS
  final StreamController<DomainAccountApiDto?> _streamMatrizController =
      StreamController<DomainAccountApiDto?>.broadcast();
  Stream<DomainAccountApiDto?> get matriz => _streamMatrizController.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<List<TransacaoApiDto>> _streamTransacoesController =
      StreamController<List<TransacaoApiDto>>.broadcast();
  Stream<List<TransacaoApiDto>> get transacoes =>
      _streamTransacoesController.stream;

  final StreamController<TransacaoApiDto> _streamUltimaTransacaoController =
      StreamController<TransacaoApiDto>.broadcast();
  Stream<TransacaoApiDto> get ultimaTransacao =>
      _streamUltimaTransacaoController.stream;

  final StreamController<SaldoApiDto> _streamSaldoController =
      StreamController<SaldoApiDto>.broadcast();
  Stream<SaldoApiDto> get saldo => _streamSaldoController.stream;

  final StreamController<List<dynamic>> _streamExtratoController =
      StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get extrato => _streamExtratoController.stream;

  final StreamController<ChavePixApiDto> _streamChavePixController =
      StreamController<ChavePixApiDto>.broadcast();
  Stream<ChavePixApiDto> get chavePix => _streamChavePixController.stream;

  final StreamController<DestinatarioApiDto> _streamDestinatarioController =
      StreamController<DestinatarioApiDto>.broadcast();
  Stream<DestinatarioApiDto> get destinatarioInfo =>
      _streamDestinatarioController.stream;

  final StreamController<List<PixToSendApiDto>>
      _streamChavePixToSendsController =
      StreamController<List<PixToSendApiDto>>.broadcast();
  Stream<List<PixToSendApiDto>> get chavePixToSends =>
      _streamChavePixToSendsController.stream;

  final _streamComprovanteController =
      BehaviorSubject<Either<bool, Uint8List>?>();
  Stream<Either<bool, Uint8List>?> get extratoPdf =>
      _streamComprovanteController.stream;

  MatrizTransferenciaViewModel({
    required this.getConfigDomainAccount,
    required this.cashout,
    required this.updateSenhaPix,
    required this.getDomainAccount,
    required this.getDomainFromSettings,
    required this.getSaldo,
    required this.listChavePix,
    required this.listChavePixToSends,
    required this.consultarDestinatario,
    required this.getTransacoes,
    required this.getUltimaTransacao,
    required this.updatePixToSendSelect,
  });

  void catchEntity() async {
    if (isLoading) return;
    setLoading();

    var result =
        await getDomainAccount.invoke(id: getDomainFromSettings.invoke()!.id);

    setLoading();
    if (result.isRight) {
      _streamMatrizController.sink.add(result.right);
      domainAccountId = result.right.id;
      if (result.right.materaId != null) materaId = result.right.materaId!;
      getConfigInfo(result.right.id);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }

  void getConfigInfo(String id) async {
    if (isLoading) return;
    setLoading();

    Map<String, String> filters = {'domain_account_id': id};
    var result = await getConfigDomainAccount.invoke(filters: filters);
    setLoading();

    if (result.isRight && result.right.domainAccountTaxas.isNotEmpty) {
      var taxa = result.right.domainAccountTaxas[0].taxa;
      var isPorcentagem = result.right.domainAccountTaxas[0].porcentagem;
      taxaMediatorFee = {
        'taxa': taxa ?? 0.0,
        'porcentagem': isPorcentagem ?? false,
      };
      if (taxaMediatorFee['porcentagem']) {
        taxaMediatorFee['taxa'] = taxaMediatorFee['taxa'] / 100;
      }
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void loadSaldo(String materaId) async {
    Map<String, dynamic> data = {
      'id': materaId,
      'account_id': materaId,
    };

    var result = await getSaldo.invoke(body: data);
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamSaldoController.isClosed) {
        _streamSaldoController.sink.add(result.right);
      }
    }
  }

  void loadChavePix(String materaId) async {
    Map<String, dynamic> data = {
      'account_id': materaId,
    };

    var result = await listChavePix.invoke(body: data);
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamChavePixController.isClosed) {
        _streamChavePixController.sink.add(result.right[0]);
      }
    }
  }

  void loadChavePixToSends(String domainAccountId) async {
    Map<String, String> filters = {
      'order_by': 'alias',
      'list_options': ListOptions.ACTIVE_ONLY.name,
      'domain_account_id': domainAccountId,
    };
    var result = await listChavePixToSends.invoke(filters: filters);
    if (result.isRight) {
      _streamChavePixToSendsController.sink.add(result.right.pixToSends);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void loadTransacoes(String materaId) async {
    Map<String, dynamic> data = {
      'id': materaId,
      'account_id': materaId,
      'parametros': {
        'begin': DateFormat('yyyy-MM-dd')
            .format(DateTime(DateTime.now().year, DateTime.now().month, 1)),
        'end': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'status': 'APPROVED',
        'paymentTypes': 'WithdrawInstantPayment',
        'pageLimit': 5
      }
    };

    var result = await getTransacoes.invoke(body: data);
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamTransacoesController.isClosed) {
        _streamTransacoesController.sink.add(result.right);
      }
    }
  }

  void loadUltimatransacao(String materaId) async {
    Map<String, dynamic> data = {
      'id': materaId,
      'account_id': materaId,
      'parametros': {
        'status': 'APPROVED',
        'paymentTypes': 'WithdrawInstantPayment',
      }
    };

    var result = await getUltimaTransacao.invoke(body: data);
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamUltimaTransacaoController.isClosed) {
        _streamUltimaTransacaoController.sink.add(result.right);
      }
    }
  }

  void loadInfoDestinatario(
    String? accountMateraId,
    String aliasCountry,
    String aliasValue,
  ) async {
    Map<String, String> body = {
      'account_id': accountMateraId ?? materaId,
      'country': aliasCountry,
      'alias_destinatario': aliasValue,
    };
    var result = await consultarDestinatario.invoke(body: body);

    if (result.isLeft) {
      postError(result.left.message);
    } else {
      endToEndId = result.right.endToEndId;
      var pixSelect = PixToSendApiDto.fromJson(
          jsonDecode(formStepSelectPix.pixSelect.value!));
      if (pixSelect.destinationAccount != result.right.accountDestination &&
          pixSelect.destinationBranch !=
              result.right.accountBranchDestination) {
        pixSelect.destinationAccount = result.right.accountDestination;
        pixSelect.destinationBranch = result.right.accountBranchDestination;
        var resultPix = await updatePixToSendSelect.invoke(id: pixSelect.id, body: body);
        if(resultPix.isRight){
          _streamDestinatarioController.sink.add(result.right);
        }
      } else {
        _streamDestinatarioController.sink.add(result.right);
      }
    }
  }

  initValues() {
    formStepValor.valor.onValueChange('0');
    formStepSelectPix.contato.onValueChange('');
    formStepSelectPix.pixSelect.onValueChange('');
    formStepSenha.senha.onValueChange('');
  }

  Future<Uint8List?> onCashoutSubmit(
    BuildContext context,
  ) async {
    if (isLoading) return null;
    setLoading(value: true);

    var formFieldsSenha = formStepSenha.getValues()!;
    var formFieldsValor = formStepValor.getValues()!;
    var formFieldsPix = formStepSelectPix.getValues()!;
    final pixSelected = PixToSendApiDto.fromJson(
        jsonDecode(formFieldsPix['pixSelect'].toString()));

    Map<String, dynamic> params = {
      'id': materaId,
      'account_id': materaId,
      'totalAmount': double.parse(formFieldsValor['valor'].toString()),
      'mediatorFee': taxaMediatorFee['taxa'],
      'currency': 'BRL',
      'natureza': 'WEB',
      'password': encryptPassword(formFieldsSenha['senha'].toString()),
      'withdrawInfo': {
        'withdrawType': 'InstantPayment',
        'instantPayment': {
          'recipient': {
            'alias': pixSelected.alias,
            'endToEndIdQuery': endToEndId,
            'pspId': pixSelected.pspId,
            'taxIdentifier': {
              'taxId': pixSelected.holderTaxIdentifierTaxId,
              'country': pixSelected.holderTaxIdentifierCountry,
            },
            'accountDestination': {
              'branch': pixSelected.destinationBranch,
              'account': pixSelected.destinationAccount,
              'accountType': pixSelected.destinationAccountType
            }
          }
        }
      },
    };

    var result = await cashout.invoke(body: params);
    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
      _streamComprovanteController.sink.add(const Left(true));
      setLoading(value: false);
      return null;
    }
    setLoading(value: false);
    _streamComprovanteController.sink.add(Right(result.right));
    return result.right;
  }

  String encryptPassword(String value) {
    var bytes1 = utf8.encode(value);
    var digest1 = sha256.convert(bytes1);

    return digest1.toString();
  }

  void onSubmitSenha(
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;
    setLoading();

    Map<String, dynamic> params = {
      'old_password': '',
      'password': '',
    };
    var formFields = formSenha.getValues();
    params['old_password'] = formFields?['senhaAntiga'] == 'senha1'
        ? null
        : formFields!['senhaAntiga'];
    params['password'] = formFields!['novaSenha'];

    var result = await updateSenhaPix.invoke(id: domainAccountId, body: params);
    setLoading();

    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamMatrizController.sink.add(null);
        _streamControllerSuccess.sink.add(true);
        catchEntity();
      }
    }
  }
}
