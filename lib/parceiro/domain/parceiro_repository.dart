import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_dto_pagination.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

abstract class ParceiroRepository {

  Future<Either<NetworkException, ParceiroApiDto>> getEntityById({
    required String id,
    String? include,
  });

  Future<Either<NetworkException, ParceiroDtoPagination>> getEntitiesByParams({
    Map<String, String> filters = const {},
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
    String? include,
  });

  Future<Either<NetworkException, ParceiroApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, ParceiroApiDto>> createEntity({
    required Map<String, dynamic> body,
  });
}
