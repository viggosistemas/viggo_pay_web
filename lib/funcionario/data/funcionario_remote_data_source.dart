import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_dto_pagination.dart';

abstract class FuncionarioRemoteDataSource {
  Future<Either<NetworkException, FuncionarioDtoPagination>> getEntitiesByParams({
    required Map<String, String> filters,
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
    String? include,
  });

  Future<Either<NetworkException, FuncionarioApiDto>> getEntityById({
    required String id,
    String? include,
  });

  Future<Either<NetworkException, FuncionarioApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, FuncionarioApiDto>> createEntity({
    required Map<String, dynamic> body,
  });
}
