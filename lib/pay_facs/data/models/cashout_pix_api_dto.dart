class CashoutPixApiDto {
  late String externalIdentifier;
  late String transactionId;
  late String status;
  bool selected = false;

  CashoutPixApiDto.fromJson(Map<String, dynamic> json) {
    externalIdentifier = json['externalIdentifier'];
    transactionId = json['transactionId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['externalIdentifier'] = externalIdentifier;
    result['transactionId'] = transactionId;
    result['status'] = status;

    return result;
  }
}
