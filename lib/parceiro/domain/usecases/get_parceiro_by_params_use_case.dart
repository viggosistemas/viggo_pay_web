import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_dto_pagination.dart';
import 'package:viggo_pay_admin/parceiro/domain/parceiro_repository.dart';

class GetParceiroByParamsUseCase {
  final ParceiroRepository repository;

  GetParceiroByParamsUseCase({required this.repository});

  Future<Either<NetworkException, ParceiroDtoPagination>> invoke({
    Map<String, String> filters = const {},
    ListOptions listOptions = ListOptions.ACTIVE_ONLY,
    String? include,
  }) =>
      repository.getEntitiesByParams(
        filters: filters,
        listOptions: listOptions,
        include: include,
      );
}
