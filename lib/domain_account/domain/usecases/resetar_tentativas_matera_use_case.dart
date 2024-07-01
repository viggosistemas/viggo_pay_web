import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/no_content_response.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_repository.dart';

class ResetarTentativasMateraUseCase {
  final DomainAccountRepository repository;

  ResetarTentativasMateraUseCase({required this.repository});

  Future<Either<NetworkException, NoContentApiDto>> invoke({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      repository.resetarNumTentativas(id: id, body: body);
}
