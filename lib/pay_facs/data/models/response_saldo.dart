
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';

class SaldoResponse {
  late SaldoApiDto saldo;

  SaldoResponse.fromJson(Map<String, dynamic> json) {
    saldo = SaldoApiDto.fromJson(json);
  }
}