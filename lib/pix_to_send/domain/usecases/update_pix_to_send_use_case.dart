import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/pix_to_send_repository.dart';

class UpdatePixToSendUseCase {
  final PixToSendRepository repository;

  UpdatePixToSendUseCase({required this.repository});

  Future<Either<NetworkException, PixToSendApiDto>> invoke({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      repository.updateEntity(id: id, body: body);
}
