import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/bytes_response.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/no_content_response.dart';
import 'package:viggo_core_frontend/network/safe_api_call.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_chave_pix.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_destinatario.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_extrato.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_saldo.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_transacoes.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/pay_facs_data_source.dart';
import 'package:viggo_pay_admin/pay_facs/data/remote/pay_facs_api.dart';

class PayFacsRemoteDataSourceImpl implements PayFacsRemoteDataSource {
  final PayFacsApi api;

  PayFacsRemoteDataSourceImpl({required this.api});

  @override
  Future<Either<NetworkException, Uint8List>> cashoutViaPix({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.cashoutViaPix, params: params).mapRight((right) => (right as BytesResponse).bytes);
  }

  @override
  Future<Either<NetworkException, List<ExtratoApiDto>>> getExtrato({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getExtrato, params: params).mapRight((right) => (right as ExtratosResponse).extratos);
  }

  @override
  Future<Either<NetworkException, ExtratoSaldoApiDto>> getExtratoSaldo({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getExtratoSaldo, params: params).mapRight(
      (right) => ExtratoSaldoApiDto(
        extrato: (right as ExtratosSaldoResponse).extrato,
        saldoFinal: (right).saldoFinal,
        saldoInicial: (right).saldoInicial,
      ),
    );
  }

  @override
  Future<Either<NetworkException, SaldoApiDto>> getSaldo({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getSaldo, params: params).mapRight((right) => (right as SaldoResponse).saldo);
  }

  @override
  Future<Either<NetworkException, List<TransacaoApiDto>>> getTransacoes({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getTransacoes, params: params).mapRight((right) => (right as TransacoesResponse).transacoes);
  }

  @override
  Future<Either<NetworkException, TransacaoApiDto>> getUltimaTransacao({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.getUltimaTransacao, params: params).mapRight((right) => (right as TransacaoResponse).transacao);
  }

  @override
  Future<Either<NetworkException, List<ChavePixApiDto>>> getListPix({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.listChavePix, params: params).mapRight((right) => (right as ChavesPixResponse).chavesPix);
  }

  @override
  Future<Either<NetworkException, DestinatarioApiDto>> consultarAliasDestinatario({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.consultarAliasDestinatario, params: params).mapRight((right) => (right as DestinatarioResponse).destinatario);
  }

  @override
  Future<Either<NetworkException, ChavePixGeradaApiDto>> addChavePix({required Map<String, dynamic> body}) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.addChavePix, params: params).mapRight((right) => (right as ChavePixGeradaResponse).chavePix);
  }

  @override
  Future<Either<NetworkException, NoContentApiDto>> deletarChavePix({required Map<String, dynamic> body}) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.deletarChavePix, params: params).mapRight((right) => (right as NoContentResponse).noContent);
  }
}
