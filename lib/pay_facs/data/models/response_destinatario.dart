
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';

class DestinatarioResponse {
  late DestinatarioApiDto destinatario;

  DestinatarioResponse.fromJson(Map<String, dynamic> json) {
    destinatario = DestinatarioApiDto.fromJson(json);
  }
}