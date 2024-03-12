import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_chave_pix.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_destinatario.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_saldo.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_transacoes.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/pay_facs_data_source.dart';
import 'package:viggo_pay_admin/pay_facs/data/remote/pay_facs_api.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/network/safe_api_call.dart';

class PayFacsRemoteDataSourceImpl implements PayFacsRemoteDataSource {
  final PayFacsApi api;

  PayFacsRemoteDataSourceImpl({required this.api});

  @override
  Future<Either<NetworkException, dynamic>> cashoutViaPix({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.cashoutViaPix, params: params)
        .mapRight((right) => (right as dynamic));
  }

  @override
  Future<Either<NetworkException, dynamic>> getExtrato({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getExtrato, params: params)
        .mapRight((right) => (right as dynamic));
  }

  @override
  Future<Either<NetworkException, SaldoApiDto>> getSaldo({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getSaldo, params: params)
        .mapRight((right) => (right as SaldoResponse).saldo);
  }

  @override
  Future<Either<NetworkException, List<TransacaoApiDto>>> getTransacoes({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getTransacoes, params: params)
        .mapRight((right) => (right as TransacoesResponse).transacoes);
  }

  @override
  Future<Either<NetworkException, TransacaoApiDto>> getUltimaTransacao({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getUltimaTransacao, params: params)
        .mapRight((right) => (right as TransacaoResponse).transacao);
  }

  @override
  Future<Either<NetworkException, List<ChavePixApiDto>>> getListPix({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.listChavePix, params: params)
        .mapRight((right) => (right as ChavesPixResponse).chavesPix);
  }

  @override
  Future<Either<NetworkException, DestinatarioApiDto>> consultarAliasDestinatario({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.consultarAliasDestinatario, params: params)
        .mapRight((right) => (right as DestinatarioResponse).destinatario);
  }
}
