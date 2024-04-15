import 'dart:async';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_extrato_pdf_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_extrato_com_saldo_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_extrato_domain_account_use_case.dart';

class TimelineExtratoViewModel extends BaseViewModel {
  String materaId = '';
  String domainAccountId = '';

  //USE_CASES
  final GetDomainAccountByIdUseCase getDomainAccount;
  final GetDomainFromSettingsUseCase getDomainFromSettings;
  final GetExtratoDomainAccountUseCase getExtrato;
  final GetExtratoComSaldoDomainAccountUseCase getExtratoSaldo;
  final GetExtratoPdfDomainAccountUseCase getExtratoPDF;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<DomainAccountApiDto?> _streamMatrizController =
      StreamController<DomainAccountApiDto?>.broadcast();
  Stream<DomainAccountApiDto?> get matriz => _streamMatrizController.stream;

  final StreamController<ExtratoSaldoApiDto> _streamExtratoController =
      StreamController<ExtratoSaldoApiDto>.broadcast();
  Stream<ExtratoSaldoApiDto> get extrato => _streamExtratoController.stream;

  final _streamExtratoPdfController = BehaviorSubject<Either<bool, Uint8List>?>();
  Stream<Either<bool, Uint8List>?> get extratoPdf => _streamExtratoPdfController.stream;

  TimelineExtratoViewModel({
    required this.getDomainAccount,
    required this.getDomainFromSettings,
    required this.getExtrato,
    required this.getExtratoSaldo,
    required this.getExtratoPDF,
  });

  void catchEntity() async {
    var result =
        await getDomainAccount.invoke(id: getDomainFromSettings.invoke()!.id);

    if (result.isRight) {
      _streamMatrizController.sink.add(result.right);
      domainAccountId = result.right.id;
      if (result.right.materaId != null) materaId = result.right.materaId!;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }

  void loadExtrato(
    String materaId,
    Map<String, String> params, {
    bool comSaldo = true,
  }) async {
    if (isLoading) return;

    setLoading();

    Map<String, dynamic> data = {
      'id': materaId,
      'account_id': materaId,
      'parametros': params,
    };

    var result = await getExtratoSaldo.invoke(body: data);

    setLoading();

    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamExtratoController.isClosed) {
        result.right.extrato.sort((a, b) => DateTime.parse(b.creditDate).compareTo(DateTime.parse(a.creditDate)));
        _streamExtratoController.sink.add(result.right);
      }
    }
  }

  Future<Uint8List?> gerarPdf(
    String domainAccountId,
    Map<String, String> params,
  ) async {
    if (isLoading) return null;
    setLoading(value: true);

    var result = await getExtratoPDF.invoke(
      id: domainAccountId,
      de: params['start'].toString(),
      ate: params['ending'].toString(),
    );

    if (result.isLeft) {
      postError(result.left.message);
      _streamExtratoPdfController.sink.add(const Left(true));
      setLoading(value: false);
      return null;
    } 
    setLoading(value: false);
    _streamExtratoPdfController.sink.add(Right(result.right));
    return result.right;
  }
}
