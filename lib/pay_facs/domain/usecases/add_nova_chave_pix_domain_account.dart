import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';

class AddChavePixDomainAccountUseCase {
  final PayFacsRepository repository;

  AddChavePixDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, ChavePixGeradaApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.addChavePix(body: body);
}
