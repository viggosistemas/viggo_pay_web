import 'package:viggo_pay_core_frontend/base/entity_api_dto.dart';

// ignore: constant_identifier_names
enum Aliastype { TAX_ID, EMAIL, PHONE, EVP }
class PixToSendApiDto extends EntityDto {
  late String domainAccountId;
  late String alias;
  late String aliasType;
  //info dono
  late String holderName;
  late String holderTaxIdentifierTaxId;
  late String holderTaxIdentifierCountry;
  late String holderTaxIdentifierTaxIdMasked;
  //info conta
  late String destinationBranch;
  late String destinationAccount;
  late String destinationAccountType;
  //banco
  late String pspId;
  late String pspName;
  late String pspCountry;
  
  bool selected = false;

  PixToSendApiDto.fromJson(Map<String, dynamic> json) {
    super.entityFromJson(json);
    domainAccountId = json['domain_account_id'];
    alias = json['alias'];
    aliasType = json['alias_type'];
    holderName = json['holder_name'];
    holderTaxIdentifierTaxId = json['holder_tax_identifier_tax_id'];
    holderTaxIdentifierCountry = json['holder_tax_identifier_country'];
    holderTaxIdentifierTaxIdMasked = json['holder_tax_identifier_tax_id_masked'];
    destinationBranch = json['destination_branch'];
    destinationAccount = json['destination_account'];
    destinationAccountType = json['destination_account_type'];
    pspId = json['psp_id'];
    pspName = json['psp_name'];
    pspCountry = json['psp_country'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = super.toJson();
    result['domain_account_id'] = domainAccountId;
    result['alias'] = alias;
    result['alias_type'] = aliasType;
    result['holder_name'] = holderName;
    result['holder_tax_identifier_tax_id'] = holderTaxIdentifierTaxId;
    result['holder_tax_identifier_country'] = holderTaxIdentifierCountry;
    result['holder_tax_identifier_tax_id_masked'] = holderTaxIdentifierTaxIdMasked;
    result['destination_branch'] = destinationBranch;
    result['destination_account'] = destinationAccount;
    result['destination_account_type'] = destinationAccountType;
    result['psp_id'] = pspId;
    result['psp_name'] = pspName;
    result['psp_country'] = pspCountry;
    result['selected'] = selected;

    return result;
  }
}
