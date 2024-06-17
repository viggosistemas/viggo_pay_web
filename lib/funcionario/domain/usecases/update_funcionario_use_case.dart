import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/domain/funcionario_repository.dart';

class UpdateFuncionarioUseCase {
  final FuncionarioRepository repository;

  UpdateFuncionarioUseCase({required this.repository});

  Future<Either<NetworkException, FuncionarioApiDto>> invoke({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      repository.updateEntity(id: id, body: body);
}
