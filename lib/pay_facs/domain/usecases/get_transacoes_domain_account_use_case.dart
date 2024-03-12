import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class GetTransacoesDomainAccountUseCase {
  final PayFacsRepository repository;

  GetTransacoesDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, List<TransacaoApiDto>>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.getTransacoes(body: body);
}
