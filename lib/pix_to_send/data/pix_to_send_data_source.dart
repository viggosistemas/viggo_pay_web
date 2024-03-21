import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_dto_pagination.dart';

abstract class PixToSendRemoteDataSource {
  
  Future<Either<NetworkException, PixToSendDtoPagination>> getEntitiesByParams({
    required Map<String, String> filters,
    ListOptions? listOptions,
    String? include,
  });
  
  Future<Either<NetworkException, PixToSendApiDto>> getEntityById({
    required String id,
    String? include,
  });

  Future<Either<NetworkException, PixToSendApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, PixToSendApiDto>> createEntity({
    required Map<String, dynamic> body,
  });
}
