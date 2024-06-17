import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_dto_pagination.dart';
import 'package:viggo_pay_admin/funcionario/domain/funcionario_repository.dart';

class GetFuncionarioByParamsUseCase {
  final FuncionarioRepository repository;

  GetFuncionarioByParamsUseCase({required this.repository});

  Future<Either<NetworkException, FuncionarioDtoPagination>> invoke({
    Map<String, String> filters = const {},
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
    String? include,
  }) =>
      repository.getEntitiesByParams(
        filters: filters,
        listOptions: listOptions,
        include: include,
      );
}
