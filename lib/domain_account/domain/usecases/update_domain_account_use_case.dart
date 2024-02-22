import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class UpdateDomainAccountUseCase {
  final DomainAccountRepository repository;

  UpdateDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, DomainAccountApiDto>> invoke({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      repository.updateEntity(id: id, body: body);
}
