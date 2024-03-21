
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';

class ExtratoResponse {
  late ExtratoApiDto extrato;

  ExtratoResponse.fromJson(Map<String, dynamic> json) {
    extrato = ExtratoApiDto.fromJson(json);
  }
}

class ExtratosResponse {
  late List<ExtratoApiDto> extratos;

  ExtratosResponse.fromJson(Map<String, dynamic> json) {
    extratos = List<ExtratoApiDto>.from(
        json['statement'].map((val) => ExtratoApiDto.fromJson(val)).toList());
  }
}

class ExtratosSaldoResponse {
  late List<ExtratoApiDto> extrato;
  late double saldoInicial;
  late double saldoFinal;

  ExtratosSaldoResponse.fromJson(Map<String, dynamic> json) {
    extrato = List<ExtratoApiDto>.from(
        json['extrato'].map((val) => ExtratoApiDto.fromJson(val)).toList());
    saldoFinal = json['saldo_final'];
    saldoInicial = json['saldo_inicial'];
  }
}
