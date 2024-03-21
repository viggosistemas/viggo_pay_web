import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';

abstract class PayFacsRemoteDataSource {
  Future<Either<NetworkException, SaldoApiDto>> getSaldo({
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, List<ExtratoApiDto>>> getExtrato({
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, ExtratoSaldoApiDto>> getExtratoSaldo({
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, List<TransacaoApiDto>>> getTransacoes({
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, TransacaoApiDto>> getUltimaTransacao({
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, Uint8List>> cashoutViaPix({
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, List<ChavePixApiDto>>> getListPix({
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, DestinatarioApiDto>> consultarAliasDestinatario({
    required Map<String, dynamic> body,
  });
}
