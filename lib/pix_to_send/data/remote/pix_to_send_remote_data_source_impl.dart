import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_dto_pagination.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/response.dart';
import 'package:viggo_pay_admin/pix_to_send/data/pix_to_send_data_source.dart';
import 'package:viggo_pay_admin/pix_to_send/data/remote/pix_to_send_api.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/network/safe_api_call.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class PixToSendRemoteDataSourceImpl
    implements PixToSendRemoteDataSource {
  final PixToSendApi api;

  PixToSendRemoteDataSourceImpl({required this.api});

  @override
  Future<Either<NetworkException, PixToSendDtoPagination>> getEntitiesByParams({
    required Map<String, String> filters,
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
    String? include,
  }) {
    Map<String, dynamic> params = filters;
    params['list_options'] = listOptions.name;
    if (include != null) params['include'] = include;

    return safeApiCall(api.getEntitiesByParams, params: params).mapRight(
      (right) => PixToSendDtoPagination(
        pixToSends: (right as PixToSendsResponse).pixToSends,
        pagination: (right).pagination,
      ),
    );
  }

  @override
  Future<Either<NetworkException, PixToSendApiDto>> getEntityById({
    required String id,
    String? include,
  }) {
    Map<String, dynamic> params = {'id': id};
    if (include != null) params['include'] = include;
    return safeApiCall(api.getEntityById, params: params)
        .mapRight((right) => (right as PixToSendResponse).pixToSend);
  }

  @override
  Future<Either<NetworkException, PixToSendApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'id': id, 'body': body};
    return safeApiCall(api.updateEntity, params: params)
        .mapRight((right) => (right as PixToSendResponse).pixToSend);
  }

  @override
  Future<Either<NetworkException, PixToSendApiDto>> createEntity({
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.createEntity, params: params)
        .mapRight((right) => (right as PixToSendResponse).pixToSend);
  }
}
