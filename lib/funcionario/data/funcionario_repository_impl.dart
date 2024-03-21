import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/funcionario/data/funcionario_remote_data_source.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_dto_pagination.dart';
import 'package:viggo_pay_admin/funcionario/domain/funcionario_repository.dart';

class FuncionarioRepositoryImpl implements FuncionarioRepository {
  final FuncionarioRemoteDataSource remoteDataSource;

  FuncionarioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, FuncionarioDtoPagination>> getEntitiesByParams({
    Map<String, String> filters = const {},
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
    String? include,
  }) =>
      remoteDataSource.getEntitiesByParams(
        filters: filters,
        listOptions: listOptions,
        include: include,
      );

  @override
  Future<Either<NetworkException, FuncionarioApiDto>> getEntityById({
    required String id,
    String? include,
  }) =>
      remoteDataSource.getEntityById(id: id, include: include);

  @override
  Future<Either<NetworkException, FuncionarioApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.updateEntity(id: id, body: body);

  @override
  Future<Either<NetworkException, FuncionarioApiDto>> createEntity({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.createEntity(body: body);
}
