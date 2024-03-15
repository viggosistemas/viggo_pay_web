import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_data_source.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_dto_pagination.dart';
import 'package:viggo_pay_admin/domain_account/data/models/response.dart';
import 'package:viggo_pay_admin/domain_account/data/remote/domain_account_api.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/network/no_content_response.dart';
import 'package:viggo_pay_core_frontend/network/safe_api_call.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class DomainAccountRemoteDataSourceImpl
    implements DomainAccountRemoteDataSource {
  final DomainAccountApi api;

  DomainAccountRemoteDataSourceImpl({required this.api});

  @override
  Future<Either<NetworkException, DomainAccountDtoPagination>>
      getEntitiesByParams({
    required Map<String, String> filters,
    ListOptions? listOptions,
    String? include,
  }) {
    Map<String, dynamic> params = filters;
    if (listOptions != null) params['list_options'] = listOptions.name;
    if (include != null) params['include'] = include;

    return safeApiCall(api.getEntitiesByParams, params: params).mapRight(
      (right) => DomainAccountDtoPagination(
        domainAccounts: (right as DomainAccountsResponse).domainAccounts,
        pagination: (right).pagination,
      ),
    );
  }

  @override
  Future<Either<NetworkException, DomainAccountApiDto>> getEntityById({
    required String id,
    String? include,
  }) {
    Map<String, dynamic> params = {'id': id};
    if (include != null) params['include'] = include;
    return safeApiCall(api.getEntityById, params: params)
        .mapRight((right) => (right as DomainAccountResponse).domainAccount);
  }

  @override
  Future<Either<NetworkException, DomainAccountApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'id': id, 'body': body};
    return safeApiCall(api.updateEntity, params: params)
        .mapRight((right) => (right as DomainAccountResponse).domainAccount);
  }

  @override
  Future<Either<NetworkException, NoContentApiDto>> updatePasswordPix({
    required String id,
    required Map<String, dynamic> body,
  }) {
    Map<String, dynamic> params = {'id': id, 'body': body};
    return safeApiCall(api.updatePasswordPix, params: params)
        .mapRight((right) => (right as NoContentResponse).noContent);
  }
  
  @override
  Future<Either<NetworkException, DomainAccountApiDto>> addDocuments({
    required String id,
    required Map<String, dynamic> body,
  }) {
    body['id'] = id;
    return safeApiCall(api.addDocuments, params: {'id': id, 'body': body})
        .mapRight((right) => (right as DomainAccountResponse).domainAccount);
  }

}
