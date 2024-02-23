import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_dto_pagination.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

abstract class DomainAccountConfigRemoteDataSource {

  Future<Either<NetworkException, DomainAccountTaxaDtoPagination>> getConfigById({
    required Map<String, String> filters,
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
