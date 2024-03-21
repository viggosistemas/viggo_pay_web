class DestinatarioApiDto {
  late String alias;
  late String aliasType;
  late String aliasHolderName;
  late String aliasHolderTaxId;
  late String aliasHolderCountry;
  late String aliasHolderTaxIdMasked;
  late String accountDestination;
  late String accountBranchDestination;
  late String accountTypeDestination;
  late String pspId;
  late String pspCountry;
  late String pspName;
  late String endToEndId;

  bool selected = false;

  DestinatarioApiDto.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    aliasType = json['aliasType'];
    aliasHolderName = json['aliasAccountHolder']['name'];
    aliasHolderTaxId = json['aliasAccountHolder']['taxIdentifier']['taxId'];
    aliasHolderCountry = json['aliasAccountHolder']['taxIdentifier']['country'];
    aliasHolderTaxIdMasked = json['aliasAccountHolder']['taxIdentifier']['taxIdMasked'];
    accountBranchDestination = json['accountDestination']['branch'];
    accountDestination = json['accountDestination']['account'];
    accountTypeDestination = json['accountDestination']['accountType'];
    pspId = json['psp']['id'];
    pspCountry = json['psp']['country'];
    pspName = json['psp']['name'];
    endToEndId = json['endToEndId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['alias'] = alias;
    result['aliasType'] = aliasType;
    result['aliasAccountHolder']['name'] = aliasHolderName;
    result['aliasAccountHolder']['taxIdentifier']['taxId'] = aliasHolderTaxId;
    result['aliasAccountHolder']['taxIdentifier']['country'] = aliasHolderCountry;
    result['aliasAccountHolder']['taxIdentifier']['taxIdMasked'] = aliasHolderTaxIdMasked;
    result['accountDestination']['branch'] = accountBranchDestination;
    result['accountDestination']['account'] = accountDestination;
    result['accountDestination']['accountType'] = accountTypeDestination;
    result['psp']['id'] = pspId;
    result['psp']['country'] = pspCountry;
    result['psp']['name'] = pspName;
    result['endToEndId'] = endToEndId;

    return result;
  }
}
