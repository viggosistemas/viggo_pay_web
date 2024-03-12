import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/domain/funcionario_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class CreateFuncionarioUseCase {
  final FuncionarioRepository repository;

  CreateFuncionarioUseCase({required this.repository});

  Future<Either<NetworkException, FuncionarioApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.createEntity(body: body);
}
