import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_dto_pagination.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

abstract class PixToSendRemoteDataSource {
  
  Future<Either<NetworkException, PixToSendDtoPagination>> getEntitiesByParams({
    required Map<String, String> filters,
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
    String? include,
  });
  
  Future<Either<NetworkException, PixToSendApiDto>> getEntityById({
    required String id,
    String? include,
  });
}
