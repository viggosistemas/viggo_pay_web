import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_dto_pagination.dart';
import 'package:viggo_pay_admin/parceiro/data/parceiro_remote_data_source.dart';
import 'package:viggo_pay_admin/parceiro/domain/parceiro_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ParceiroRepositoryImpl implements ParceiroRepository {
  final ParceiroRemoteDataSource remoteDataSource;

  ParceiroRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, ParceiroDtoPagination>> getEntitiesByParams({
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
  Future<Either<NetworkException, ParceiroApiDto>> getEntityById({
    required String id,
    String? include,
  }) =>
      remoteDataSource.getEntityById(id: id, include: include);

  @override
  Future<Either<NetworkException, ParceiroApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.updateEntity(id: id, body: body);

  @override
  Future<Either<NetworkException, ParceiroApiDto>> createEntity({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.createEntity(body: body);
}
