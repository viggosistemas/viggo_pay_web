

import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/pix_to_send_repository.dart';

class GetPixToSendByIdUseCase {
  final PixToSendRepository repository;

  GetPixToSendByIdUseCase({required this.repository});

  Future<Either<NetworkException, PixToSendApiDto>> invoke({
    required String id,
    String? include,
  }) =>
      repository.getEntityById(id: id, include: include);
}
