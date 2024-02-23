import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_config_data_source.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_dto_pagination.dart';
import 'package:viggo_pay_admin/domain_account/data/models/response_domain_account_config.dart';
import 'package:viggo_pay_admin/domain_account/data/remote/domain_account_config_api.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/network/safe_api_call.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';
class DomainAccountConfigRemoteDataSourceImpl
    implements DomainAccountConfigRemoteDataSource {
  final DomainAccountConfigApi api;

  DomainAccountConfigRemoteDataSourceImpl({required this.api});

  @override
  @override
  Future<Either<NetworkException, DomainAccountTaxaDtoPagination>> getConfigById({
    required Map<String, String> filters,
    ListOptions? listOptions,
    String? include,
  }) {
    Map<String, dynamic> params = filters;
    if (listOptions != null) params['list_options'] = listOptions.name;
    if (include != null) params['include'] = include;

    return safeApiCall(api.getConfigId, params: params).mapRight(
      (right) => DomainAccountTaxaDtoPagination(
        domainAccountTaxas: (right as DomainAccountTaxasResponse).domainAccountTaxas,
        pagination: (right).pagination,
      ),
    );
  }

  @override
  Future<Either<NetworkException, DomainAccountConfigApiDto>> updateConfig({
    required String id,
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'id': id, 'body': body};
    return safeApiCall(api.editConfig, params: params)
        .mapRight((right) => (right as DomainAccountTaxaResponse).domainAccountTaxa);
  }
  
  @override
  Future<Either<NetworkException, DomainAccountConfigApiDto>> addConfig({required Map<String, dynamic> body}) {
    Map<String, dynamic> params = {'body': body};
    return safeApiCall(api.addConfig, params: params)
        .mapRight((right) => (right as DomainAccountTaxaResponse).domainAccountTaxa);
  }
}
