import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
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
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class MatrizTransferenciaViewModel extends ChangeNotifier {
  bool isLoading = false;
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

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<List<TransacaoApiDto>> _streamTransacoesController =
      StreamController<List<TransacaoApiDto>>.broadcast();
  Stream<List<TransacaoApiDto>> get transacoes => _streamTransacoesController.stream;

  final StreamController<TransacaoApiDto> _streamUltimaTransacaoController =
      StreamController<TransacaoApiDto>.broadcast();
  Stream<TransacaoApiDto> get ultimaTransacao => _streamUltimaTransacaoController.stream;

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
  });

  void notifyLoading() {
    isLoading = !isLoading;
    // notifyListeners();
  }

  void catchEntity() async {
    var result =
        await getDomainAccount.invoke(id: getDomainFromSettings.invoke()!.id);

    if (result.isRight) {
      _streamMatrizController.sink.add(result.right);
      domainAccountId = result.right.id;
      if (result.right.materaId != null) materaId = result.right.materaId!;
      getConfigInfo(result.right.id);
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
    return null;
  }

  void getConfigInfo(String id) async {
    Map<String, String> filters = {'domain_account_id': id};
    var result = await getConfigDomainAccount.invoke(filters: filters);
    if (result.isRight && result.right.domainAccountTaxas.isNotEmpty) {
      var taxa = result.right.domainAccountTaxas[0].taxa;
      var isPorcentagem = result.right.domainAccountTaxas[0].porcentagem;
      taxaMediatorFee = {
        'taxa': taxa ?? 0.0,
        'porcentagem': isPorcentagem ?? false,
      };
      if(taxaMediatorFee['porcentagem']){
        taxaMediatorFee['taxa'] = taxaMediatorFee['taxa']/100;
      }
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
  }

  void loadSaldo(String materaId) async {
    notifyLoading();
    Map<String, dynamic> data = {
      'id': materaId,
      'account_id': materaId,
    };

    var result = await getSaldo.invoke(body: data);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamSaldoController.isClosed) {
        _streamSaldoController.sink.add(result.right);
        notifyLoading();
      }
    }
  }

  void loadChavePix(String materaId) async {
    notifyLoading();
    Map<String, dynamic> data = {
      'account_id': materaId,
    };

    var result = await listChavePix.invoke(body: data);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamChavePixController.isClosed) {
        _streamChavePixController.sink.add(result.right[0]);
        notifyLoading();
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
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
  }

  void loadTransacoes(String materaId) async {
    notifyLoading();
    Map<String, dynamic> data = {'id': materaId, 'account_id': materaId};

    var result = await getTransacoes.invoke(body: data);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamTransacoesController.isClosed) {
        _streamTransacoesController.sink.add(result.right);
        notifyLoading();
      }
    }
  }

  void loadUltimatransacao(String materaId) async {
    notifyLoading();
    Map<String, dynamic> data = {'id': materaId, 'account_id': materaId};

    var result = await getUltimaTransacao.invoke(body: data);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamUltimaTransacaoController.isClosed) {
        _streamUltimaTransacaoController.sink.add(result.right);
        notifyLoading();
      }
    }
  }

  void loadInfoDestinatario(
    String aliasCountry,
    String aliasValue,
  ) async {
    Map<String, String> body = {
      'account_id': materaId,
      'country': aliasCountry,
      'alias_destinatario': aliasValue,
    };
    var result = await consultarDestinatario.invoke(body: body);
    if (result.isRight) {
      endToEndId = result.right.endToEndId;
      _streamDestinatarioController.sink.add(result.right);
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
  }

  initValues() {
    formStepValor.onValorChange('0');
    formStepSelectPix.onContatoChange('');
    formStepSelectPix.onPixSelectChange('');
    formStepSenha.onSenhaChange('');
  }

  void onCashoutSubmit(
    BuildContext context,
  ) async {
    notifyLoading();
    var formFieldsSenha = formStepSenha.getFields()!;
    var formFieldsValor = formStepValor.getFields()!;
    var formFieldsPix = formStepSelectPix.getFields()!;
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
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamMatrizController.sink.add(null);
        _streamControllerSuccess.sink.add(true);
        catchEntity();
        notifyLoading();
      }
    }
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
    notifyLoading();

    Map<String, dynamic> params = {
      'old_password': '',
      'password': '',
    };
    var formFields = formSenha.getFields();
    params['old_password'] = formFields?['senhaAntiga'] == 'senha1'
        ? null
        : formFields!['senhaAntiga'];
    params['password'] = formFields!['novaSenha'];

    var result = await updateSenhaPix.invoke(id: domainAccountId, body: params);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamMatrizController.sink.add(null);
        _streamControllerSuccess.sink.add(true);
        catchEntity();
        notifyLoading();
      }
    }
  }
}
