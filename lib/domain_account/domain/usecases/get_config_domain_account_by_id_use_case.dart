import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_dto_pagination.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_config_repository.dart';

class GetDomainAccountConfigByIdUseCase {
  final DomainAccountConfigRepository repository;

  GetDomainAccountConfigByIdUseCase({required this.repository});

  Future<Either<NetworkException, DomainAccountTaxaDtoPagination>> invoke({
    Map<String, String> filters = const {},
    ListOptions? listOptions,
    String? include,
  }) =>
      repository.getConfigById(
        filters: filters,
        listOptions: listOptions,
        include: include,
      );
}
