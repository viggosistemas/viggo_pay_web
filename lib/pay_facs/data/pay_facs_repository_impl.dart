import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/pay_facs_data_source.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class PayFacsRepositoryImpl implements PayFacsRepository {
  final PayFacsRemoteDataSource remoteDataSource;

  PayFacsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, dynamic>> cashoutViaPix({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.cashoutViaPix(body: body);

  @override
  Future<Either<NetworkException, dynamic>> getExtrato({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.getExtrato(body: body);

  @override
  Future<Either<NetworkException, SaldoApiDto>> getSaldo({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.getSaldo(body: body);

  @override
  Future<Either<NetworkException, List<TransacaoApiDto>>> getTransacoes({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.getTransacoes(body: body);

  @override
  Future<Either<NetworkException, TransacaoApiDto>> getUltimaTransacao({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.getUltimaTransacao(body: body);


  @override
  Future<Either<NetworkException, List<ChavePixApiDto>>> getListPix({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.getListPix(body: body);

  @override
  Future<Either<NetworkException, DestinatarioApiDto>> consultarAliasDestinatario({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.consultarAliasDestinatario(body: body);
}
