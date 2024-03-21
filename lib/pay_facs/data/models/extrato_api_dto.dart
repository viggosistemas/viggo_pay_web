class ExtratoSaldoApiDto{
  late List<ExtratoApiDto> extrato;
  late double saldoInicial;
  late double saldoFinal;

  ExtratoSaldoApiDto({
    required this.extrato,
    required this.saldoFinal,
    required this.saldoInicial,
  });
}


class ExtratoApiDto {
  late String transactionId;
  late String description;
  late String? comment;
  late String transactionType;
  late String entryDate;
  late String creditDate;
  late double amount;
  late String type;
  late double historyCode;
  late double? saldoPre;
  late double? saldoPos;
  late CounterPartApiDto? counterPart;

  bool selected = false;

  ExtratoApiDto.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    description = json['description'];
    comment = json['comment'];
    transactionType = json['transactionType'];
    entryDate = json['entryDate'];
    creditDate = json['creditDate'];
    amount = json['amount'];
    type = json['type'];
    historyCode = json['historyCode'];
    saldoPre = json['saldo_pre'] ?? 0;
    saldoPos = json['saldo_pos'] ?? 0;
    counterPart = json['counterPart'] != null
        ? CounterPartApiDto.fromJson(json['counterPart'])
        : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['transactionId'] = transactionId;
    result['description'] = description;
    result['comment'] = comment;
    result['transactionType'] = transactionType;
    result['entryDate'] = entryDate;
    result['creditDate'] = creditDate;
    result['amount'] = amount;
    result['type'] = type;
    result['historyCode'] = historyCode;
    result['counterPart'] = counterPart;
    result['saldo_pre'] = saldoPre;
    result['saldo_pos'] = saldoPos;

    return result;
  }
}

class CounterPartApiDto {
  late String clientType;
  late String name;
  late String taxIdentifierTaxId;
  late String taxIdentifierCountry;

  CounterPartApiDto.fromJson(Map<String, dynamic> json) {
    clientType = json['clientType'];
    name = json['name'];
    taxIdentifierTaxId = json['taxIdentifierTaxId'];
    taxIdentifierCountry = json['taxIdentifierCountry'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['clientType'] = clientType;
    result['name'] = name;
    result['taxIdentifierTaxId'] = taxIdentifierTaxId;
    result['taxIdentifierCountry'] = taxIdentifierCountry;

    return result;
  }
}
