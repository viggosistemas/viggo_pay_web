import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';

class GetExtratoComSaldoDomainAccountUseCase {
  final PayFacsRepository repository;

  GetExtratoComSaldoDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, ExtratoSaldoApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.getExtratoSaldo(body: body);
}
