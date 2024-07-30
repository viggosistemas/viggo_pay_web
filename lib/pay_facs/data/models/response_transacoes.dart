
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';

class TransacaoResponse {
  late TransacaoApiDto transacao;

  TransacaoResponse.fromJson(Map<String, dynamic> json) {
    transacao = TransacaoApiDto.fromJson(json);
  }
}

class TransacoesResponse {
  late List<TransacaoApiDto> transacoes;

  TransacoesResponse.fromJson(Map<String, dynamic> json) {
    transacoes = List<TransacaoApiDto>.from(
        json['transactions'].map((val) => TransacaoApiDto.fromJson(val)).toList());
  }
}
