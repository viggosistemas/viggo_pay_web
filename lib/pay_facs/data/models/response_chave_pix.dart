
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';

class ChavesPixResponse {
  late List<ChavePixApiDto> chavesPix;

  ChavesPixResponse.fromJson(Map<String, dynamic> json) {
    chavesPix = List<ChavePixApiDto>.from(
        json['aliases'].map((val) => ChavePixApiDto.fromJson(val)).toList());
  }
}
