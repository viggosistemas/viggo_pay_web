import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_config_repository.dart';

class UpdateConfigDomainAccountUseCase {
  final DomainAccountConfigRepository repository;

  UpdateConfigDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, DomainAccountConfigApiDto>> invoke({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      repository.updateConfig(id: id, body: body);
}
