import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_dto_pagination.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/pix_to_send_repository.dart';

class GetPixToSendsByParamsUseCase {
  final PixToSendRepository repository;

  GetPixToSendsByParamsUseCase({required this.repository});

  Future<Either<NetworkException, PixToSendDtoPagination>> invoke({
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
