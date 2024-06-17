import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';

class ConsultarAliasDestinatarioUseCase {
  final PayFacsRepository repository;

  ConsultarAliasDestinatarioUseCase({required this.repository});

  Future<Either<NetworkException, DestinatarioApiDto>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.consultarAliasDestinatario(body: body);
}
