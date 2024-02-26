import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/pix_to_send_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class CreatePixToSendUseCase {
  final PixToSendRepository repository;

  CreatePixToSendUseCase({required this.repository});

  Future<Either<NetworkException, PixToSendApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.createEntity(body: body);
}