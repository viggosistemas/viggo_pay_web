import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/domain/parceiro_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class UpdateParceiroUseCase {
  final ParceiroRepository repository;

  UpdateParceiroUseCase({required this.repository});

  Future<Either<NetworkException, ParceiroApiDto>> invoke({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      repository.updateEntity(id: id, body: body);
}
