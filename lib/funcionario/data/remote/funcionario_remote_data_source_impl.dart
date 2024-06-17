import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/funcionario/data/funcionario_remote_data_source.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_dto_pagination.dart';
import 'package:viggo_pay_admin/funcionario/data/models/response.dart';
import 'package:viggo_pay_admin/funcionario/data/remote/funcionario_api.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/safe_api_call.dart';
import 'package:viggo_core_frontend/util/list_options.dart';

class FuncionarioRemoteDataSourceImpl implements FuncionarioRemoteDataSource {
  final FuncionarioApi api;

  FuncionarioRemoteDataSourceImpl({required this.api});

  @override
  Future<Either<NetworkException, FuncionarioDtoPagination>> getEntitiesByParams({
    required Map<String, String> filters,
    ListOptions? listOptions,
    String? include,
  }) {
    Map<String, dynamic> params = filters;
    if (listOptions != null) params['list_options'] = listOptions.name;
    if (include != null) params['include'] = include;

    return safeApiCall(api.getEntitiesByParams, params: params).mapRight(
      (right) => FuncionarioDtoPagination(
        funcionarios: (right as FuncionariosResponse).funcionarios,
        pagination: (right).pagination,
      ),
    );
  }

  @override
  Future<Either<NetworkException, FuncionarioApiDto>> getEntityById({
    required String id,
    String? include,
  }) {
    Map<String, dynamic> params = {'id': id};
    if (include != null) params['include'] = include;
    return safeApiCall(api.getEntityById, params: params)
        .mapRight((right) => (right as FuncionarioResponse).funcionario);
  }

  @override
  Future<Either<NetworkException, FuncionarioApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'id': id, 'body': body};
    return safeApiCall(api.updateEntity, params: params)
        .mapRight((right) => (right as FuncionarioResponse).funcionario);
  }

  @override
  Future<Either<NetworkException, FuncionarioApiDto>> createEntity({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.createEntity, params: params)
        .mapRight((right) => (right as FuncionarioResponse).funcionario);
  }
}
