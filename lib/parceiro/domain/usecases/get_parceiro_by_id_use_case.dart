

import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/domain/parceiro_repository.dart';

class GetParceiroByIdUseCase {
  final ParceiroRepository repository;

  GetParceiroByIdUseCase({required this.repository});

  Future<Either<NetworkException, ParceiroApiDto>> invoke({
    required String id,
    String? include,
  }) =>
      repository.getEntityById(id: id, include: include);
}
