import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_extrato_domain_account_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';

class TimelineExtratoViewModel extends ChangeNotifier {
  bool isLoading = false;
  String materaId = '';
  String domainAccountId = '';

  //USE_CASES
  final GetDomainAccountByIdUseCase getDomainAccount;
  final GetDomainFromSettingsUseCase getDomainFromSettings;
  final GetExtratoDomainAccountUseCase getExtrato;

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<DomainAccountApiDto?> _streamMatrizController =
      StreamController<DomainAccountApiDto?>.broadcast();
  Stream<DomainAccountApiDto?> get matriz => _streamMatrizController.stream;
  
  final StreamController<List<dynamic>> _streamExtratoController =
      StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get extrato => _streamExtratoController.stream;

  TimelineExtratoViewModel({
    required this.getDomainAccount,
    required this.getDomainFromSettings,
    required this.getExtrato,
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
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
    return null;
  }

  void loadExtrato(String materaId) async {
    notifyLoading();
    Map<String, dynamic> data = {'id': materaId, 'account_id': materaId};

    var result = await getExtrato.invoke(body: data);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamExtratoController.isClosed) {
        _streamExtratoController.sink.add(result.right['statement']);
        notifyLoading();
      }
    }
  }
}