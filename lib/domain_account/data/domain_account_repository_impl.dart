import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_data_source.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_dto_pagination.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class DomainAccountRepositoryImpl implements DomainAccountRepository {
  final DomainAccountRemoteDataSource remoteDataSource;

  DomainAccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, DomainAccountDtoPagination>> getEntitiesByParams({
    Map<String, String> filters = const {},
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
    String? include,
  }) =>
      remoteDataSource.getEntitiesByParams(
        filters: filters,
        listOptions: listOptions,
        include: include,
      );


  @override
  Future<Either<NetworkException, DomainAccountApiDto>> getEntityById({
    required String id,
    String? include,
  }) =>
      remoteDataSource.getEntityById(id: id, include: include);
}
