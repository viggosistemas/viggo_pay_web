import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class GetSaldoDomainAccountUseCase {
  final PayFacsRepository repository;

  GetSaldoDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, SaldoApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.getSaldo(body: body);
}
