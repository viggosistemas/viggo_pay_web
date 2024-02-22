import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_dto_pagination.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

abstract class DomainAccountRepository {

  Future<Either<NetworkException, DomainAccountApiDto>> getEntityById({
    required String id,
    String? include,
  });

  Future<Either<NetworkException, DomainAccountDtoPagination>> getEntitiesByParams({
    Map<String, String> filters = const {},
    ListOptions? listOptions,
    String? include,
  });

  Future<Either<NetworkException, DomainAccountApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  });

}
