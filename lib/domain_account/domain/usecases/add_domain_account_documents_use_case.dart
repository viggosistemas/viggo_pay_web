import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_repository.dart';

class AddDomainAccountDocumentsUseCase {
  final DomainAccountRepository repository;

  AddDomainAccountDocumentsUseCase({required this.repository});

  Future<Either<NetworkException, DomainAccountApiDto>> invoke(
    String id,
    Map<String, dynamic> body,
  ) =>
      repository.addDocuments(id, body);
}
