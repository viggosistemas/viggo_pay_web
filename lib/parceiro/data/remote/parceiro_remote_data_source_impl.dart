import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/safe_api_call.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_dto_pagination.dart';
import 'package:viggo_pay_admin/parceiro/data/models/response.dart';
import 'package:viggo_pay_admin/parceiro/data/parceiro_remote_data_source.dart';
import 'package:viggo_pay_admin/parceiro/data/remote/parceiro_api.dart';

class ParceiroRemoteDataSourceImpl implements ParceiroRemoteDataSource {
  final ParceiroApi api;

  ParceiroRemoteDataSourceImpl({required this.api});

  @override
  Future<Either<NetworkException, ParceiroDtoPagination>> getEntitiesByParams({
    required Map<String, String> filters,
    ListOptions? listOptions,
    String? include,
  }) {
    Map<String, dynamic> params = filters;
    if (listOptions != null) params['list_options'] = listOptions.name;
    if (include != null) params['include'] = include;

    return safeApiCall(api.getEntitiesByParams, params: params).mapRight(
      (right) => ParceiroDtoPagination(
        parceiros: (right as ParceirosResponse).parceiros,
        pagination: (right).pagination,
      ),
    );
  }

  @override
  Future<Either<NetworkException, ParceiroApiDto>> getEntityById({
    required String id,
    String? include,
  }) {
    Map<String, dynamic> params = {'id': id};
    if (include != null) params['include'] = include;
    return safeApiCall(api.getEntityById, params: params)
        .mapRight((right) => (right as ParceiroResponse).parceiro);
  }

  @override
  Future<Either<NetworkException, ParceiroApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'id': id, 'body': body};
    return safeApiCall(api.updateEntity, params: params)
        .mapRight((right) => (right as ParceiroResponse).parceiro);
  }

  @override
  Future<Either<NetworkException, ParceiroApiDto>> createEntity({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.createEntity, params: params)
        .mapRight((right) => (right as ParceiroResponse).parceiro);
  }
}
