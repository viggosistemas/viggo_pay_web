import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_dto_pagination.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_repository.dart';

class GetDomainAccountsByParamsUseCase {
  final DomainAccountRepository repository;

  GetDomainAccountsByParamsUseCase({required this.repository});

  Future<Either<NetworkException, DomainAccountDtoPagination>> invoke({
    Map<String, String> filters = const {},
    ListOptions? listOptions,
    String? include,
  }) =>
      repository.getEntitiesByParams(
        filters: filters,
        listOptions: listOptions,
        include: include,
      );
}
