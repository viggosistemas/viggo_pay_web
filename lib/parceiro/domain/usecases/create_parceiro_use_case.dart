import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/domain/parceiro_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class CreateParceiroUseCase {
  final ParceiroRepository repository;

  CreateParceiroUseCase({required this.repository});

  Future<Either<NetworkException, ParceiroApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.createEntity(body: body);
}
