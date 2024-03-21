
import 'package:viggo_pay_admin/pay_facs/data/models/cashout_pix_api_dto.dart';

class CashoutPixResponse {
  late CashoutPixApiDto cashout;

  CashoutPixResponse.fromJson(Map<String, dynamic> json) {
    cashout = CashoutPixApiDto.fromJson(json);
  }
}