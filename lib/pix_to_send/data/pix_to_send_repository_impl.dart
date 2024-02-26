import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_dto_pagination.dart';
import 'package:viggo_pay_admin/pix_to_send/data/pix_to_send_data_source.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/pix_to_send_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class PixToSendRepositoryImpl implements PixToSendRepository {
  final PixToSendRemoteDataSource remoteDataSource;

  PixToSendRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, PixToSendDtoPagination>> getEntitiesByParams({
    Map<String, String> filters = const {},
    ListOptions? listOptions,
    String? include,
  }) =>
      remoteDataSource.getEntitiesByParams(
        filters: filters,
        listOptions: listOptions,
        include: include,
      );

  @override
  Future<Either<NetworkException, PixToSendApiDto>> getEntityById({
    required String id,
    String? include,
  }) =>
      remoteDataSource.getEntityById(id: id, include: include);

  @override
  Future<Either<NetworkException, PixToSendApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.updateEntity(id: id, body: body);

  @override
  Future<Either<NetworkException, PixToSendApiDto>> createEntity({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.createEntity(body: body);
}
