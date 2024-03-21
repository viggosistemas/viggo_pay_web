import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_dto_pagination.dart';

abstract class DomainAccountConfigRepository {

  Future<Either<NetworkException, DomainAccountTaxaDtoPagination>> getConfigById({
    Map<String, String> filters = const {},
    ListOptions? listOptions,
    String? include,
  });

  Future<Either<NetworkException, DomainAccountConfigApiDto>> addConfig({
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, DomainAccountConfigApiDto>> updateConfig({
    required String id,
    required Map<String, dynamic> body,
  });

}
