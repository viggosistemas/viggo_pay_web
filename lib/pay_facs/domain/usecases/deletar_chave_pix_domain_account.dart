import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/no_content_response.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';

class DeletarChavePixDomainAccountUseCase {
  final PayFacsRepository repository;

  DeletarChavePixDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, NoContentApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.deletarChavePix(body: body);
}
