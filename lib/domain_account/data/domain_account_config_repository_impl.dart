import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_config_data_source.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_dto_pagination.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_config_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class DomainAccountConfigRepositoryImpl
    implements DomainAccountConfigRepository {
  final DomainAccountConfigRemoteDataSource remoteDataSource;

  DomainAccountConfigRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, DomainAccountConfigApiDto>> addConfig({
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.addConfig(
        body: body,
      );

  @override
  Future<Either<NetworkException, DomainAccountTaxaDtoPagination>>
      getConfigById({
    Map<String, String> filters = const {},
    ListOptions? listOptions,
    String? include,
  }) =>
          remoteDataSource.getConfigById(
            filters: filters,
            listOptions: listOptions,
            include: include,
          );

  @override
  Future<Either<NetworkException, DomainAccountConfigApiDto>> updateConfig({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.updateConfig(
        id: id,
        body: body,
      );
}
