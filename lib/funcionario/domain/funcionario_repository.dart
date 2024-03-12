import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_dto_pagination.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

abstract class FuncionarioRepository {

  Future<Either<NetworkException, FuncionarioApiDto>> getEntityById({
    required String id,
    String? include,
  });

  Future<Either<NetworkException, FuncionarioDtoPagination>> getEntitiesByParams({
    Map<String, String> filters = const {},
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
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
