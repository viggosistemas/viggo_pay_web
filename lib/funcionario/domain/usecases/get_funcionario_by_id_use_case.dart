

import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/domain/funcionario_repository.dart';

class GetFuncionarioByIdUseCase {
  final FuncionarioRepository repository;

  GetFuncionarioByIdUseCase({required this.repository});

  Future<Either<NetworkException, FuncionarioApiDto>> invoke({
    required String id,
    String? include,
  }) =>
      repository.getEntityById(id: id, include: include);
}
