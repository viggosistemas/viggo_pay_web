class SaldoApiDto {
  late String accountId;
  late String date;
  late double real;
  late double available;
  late double? overdraft;
  late double? blocked;
  late double? autoInvest;
  late double? emergencyAidBalance;
  late double? availableBalanceForTransactions;
  bool selected = false;

  SaldoApiDto.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    date = json['date'];
    real = json['real'];
    available = json['available'];
    overdraft = json['overdraft'];
    blocked = json['blocked'];
    autoInvest = json['autoInvest'];
    emergencyAidBalance = json['emergencyAidBalance'];
    availableBalanceForTransactions = json['availableBalanceForTransactions'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['accountId'] = accountId;
    result['date'] = date;
    result['real'] = real;
    result['available'] = available;
    if (overdraft != null) result['overdraft'] = overdraft;
    if (blocked != null) result['blocked'] = blocked;
    if (autoInvest != null) result['autoInvest'] = autoInvest;
    if (emergencyAidBalance != null) result['emergencyAidBalance'] = emergencyAidBalance;
    if (availableBalanceForTransactions != null) result['availableBalanceForTransactions'] = availableBalanceForTransactions;

    return result;
  }
}
