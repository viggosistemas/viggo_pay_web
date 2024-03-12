class TransacaoApiDto {
  late String accountHolderId;
  late String accountId;
  late String? transactionId;
  late String? endToEndId;
  late String transactionType;
  late String? transactionStatus;
  late String? counterPartName;
  late double? totalAmount;
  late double? paidAmount;
  late double? currentAmount;
  late String transactionDate;
  late InstantPaymentApiDto? instantPayment;
  bool selected = false;

  TransacaoApiDto.fromJson(Map<String, dynamic> json) {
    accountHolderId = json['accountHolderId'];
    accountId = json['accountId'];
    transactionId = json['transactionId'];
    endToEndId = json['endToEndId'];
    transactionType = json['transactionType'];
    transactionStatus = json['transactionStatus'];
    totalAmount = json['totalAmount'];
    paidAmount = json['paidAmount'];
    counterPartName = json['counterPart'] != null ? json['counterPart']['name'] : null;
    currentAmount = json['currentAmount'];
    transactionDate = json['transactionDate'];
    instantPayment = json['instantPayment'] != null
        ? InstantPaymentApiDto.fromJson(json['instantPayment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['accountHolderId'] = accountHolderId;
    result['accountId'] = accountId;
    result['transactionId'] = transactionId;
    result['endToEndId'] = endToEndId;
    result['transactionType'] = transactionType;
    result['transactionStatus'] = transactionStatus;
    result['totalAmount'] = totalAmount;
    result['paidAmount'] = paidAmount;
    result['transactionDate'] = transactionDate;
    result['instantPayment'] = instantPayment;

    return result;
  }
}

class InstantPaymentApiDto {
  late InstantPaymentSenderApiDto sender;
  late InstantePaymentRecipientApiDto recipient;
  late String endToEndId;
  late String? legacyReconciliationIdentifier;
  late List<PaymentReceivedDto>? paymentReceived;

  InstantPaymentApiDto.fromJson(Map<String, dynamic> json) {
    sender = InstantPaymentSenderApiDto.fromJson(json['sender']);
    recipient = InstantePaymentRecipientApiDto.fromJson(json['recipient']);
    paymentReceived = json['paymentReceived'] != null
        ? List<PaymentReceivedDto>.from(json['paymentReceived']
            .map((val) => PaymentReceivedDto.fromJson(val))
            .toList())
        : [];
    endToEndId = json['endToEndId'];
    legacyReconciliationIdentifier = json['legacyReconciliationIdentifier'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['sender'] = sender;
    result['recipient'] = recipient;
    result['endToEndId'] = endToEndId;

    return result;
  }
}

class InstantPaymentSenderApiDto {
  late String name;
  late String taxIdentifierTaxId;
  late String taxIdentifierCountry;
  late String taxIdentifierTaxIdMasked;
  late String accountBranch;
  late String account;
  late String accountType;
  late String pspId;
  late String pspName;
  late String pspCountry;
  late List<String>? pspCurrencies;

  InstantPaymentSenderApiDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    taxIdentifierTaxId = json['taxIdentifier']['taxId'];
    taxIdentifierCountry = json['taxIdentifier']['country'];
    taxIdentifierTaxIdMasked = json['taxIdentifier']['taxIdMasked'];
    accountBranch = json['account']['branch'];
    account = json['account']['account'];
    accountType = json['account']['accountType'];
    pspId = json['psp']['id'];
    pspName = json['psp']['name'];
    pspCountry = json['psp']['country'];
    pspCurrencies = json['psp']['currencies'] != null
        ? List<String>.from(json['psp']['currencies'])
        : [];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['name'] = name;
    result['taxIdentifier']['taxId'] = taxIdentifierTaxId;
    result['taxIdentifier']['country'] = taxIdentifierCountry;
    result['taxIdentifier']['taxIdMasked'] = taxIdentifierTaxIdMasked;
    result['account']['branch'] = accountBranch;
    result['account']['account'] = account;
    result['account']['accountType'] = accountType;
    result['psp']['id'] = pspId;
    result['psp']['name'] = pspName;
    result['psp']['country'] = pspCountry;
    result['psp']['currencies'] = pspCurrencies;

    return result;
  }
}

class InstantePaymentRecipientApiDto {
  late String alias;
  late String name;
  late String taxIdentifierTaxId;
  late String taxIdentifierCountry;
  late String taxIdentifierTaxIdMasked;
  late String accountBranch;
  late String account;
  late String accountType;
  late String pspId;
  late String pspName;
  late String pspCountry;

  InstantePaymentRecipientApiDto.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    name = json['name'];
    taxIdentifierTaxId = json['taxIdentifier']['taxId'];
    taxIdentifierCountry = json['taxIdentifier']['country'];
    taxIdentifierTaxIdMasked = json['taxIdentifier']['taxIdMasked'];
    accountBranch = json['account']['branch'];
    account = json['account']['account'];
    accountType = json['account']['accountType'];
    pspId = json['psp']['id'];
    pspName = json['psp']['name'];
    pspCountry = json['psp']['country'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['alias'] = alias;
    result['name'] = name;
    result['taxIdentifier']['taxId'] = taxIdentifierTaxId;
    result['taxIdentifier']['country'] = taxIdentifierCountry;
    result['taxIdentifier']['taxIdMasked'] = taxIdentifierTaxIdMasked;
    result['account']['branch'] = accountBranch;
    result['account']['account'] = account;
    result['account']['accountType'] = accountType;
    result['psp']['id'] = pspId;
    result['psp']['name'] = pspName;
    result['psp']['country'] = pspCountry;

    return result;
  }
}

class PaymentReceivedDto {
  late InstantPaymentSenderApiDto sender;
  late double? receivedAmount;
  late String transactionTimestamp;
  late String legacyTransactionId;
  late String endToEndId;

  PaymentReceivedDto.fromJson(Map<String, dynamic> json) {
    sender = InstantPaymentSenderApiDto.fromJson(json['sender']);
    receivedAmount = json['receivedAmount'];
    transactionTimestamp = json['transactionTimestamp'];
    legacyTransactionId = json['legacyTransactionId'];
    endToEndId = json['endToEndId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['sender'] = sender;
    result['receivedAmount'] = receivedAmount;
    result['transactionTimestamp'] = transactionTimestamp;
    result['legacyTransactionId'] = legacyTransactionId;
    result['endToEndId'] = endToEndId;

    return result;
  }
}
