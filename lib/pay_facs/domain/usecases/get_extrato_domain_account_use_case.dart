import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';

class GetExtratoDomainAccountUseCase {
  final PayFacsRepository repository;

  GetExtratoDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, List<ExtratoApiDto>>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.getExtrato(body: body);
}
