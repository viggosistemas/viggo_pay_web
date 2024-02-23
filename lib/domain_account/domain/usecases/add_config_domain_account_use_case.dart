import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_config_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class AddConfigDomainAccountUseCase {
  final DomainAccountConfigRepository repository;

  AddConfigDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, DomainAccountConfigApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.addConfig(body: body);
}
