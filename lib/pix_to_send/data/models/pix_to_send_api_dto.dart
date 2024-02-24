import 'package:viggo_pay_core_frontend/base/entity_api_dto.dart';

class PixToSendApiDto extends EntityDto {
  late String domainAccountId;
  late String pspId;
  late String taxIdentifierTaxId;
  late String taxIdentifierCountry;
  late String alias;
  late String? endToEndIdQuery;
  late String? accountDestinationBranch;
  late String accountDestinationAccount;
  late String accountDestinationAccountType;
  bool selected = false;

  PixToSendApiDto.fromJson(Map<String, dynamic> json) {
    super.entityFromJson(json);
    domainAccountId = json['domain_account_id'];
    pspId = json['psp_id'];
    taxIdentifierTaxId = json['tax_identifier_tax_id'];
    taxIdentifierCountry = json['tax_identifier_country'];
    alias = json['alias'];
    endToEndIdQuery = json['end_to_end_id_query'];
    accountDestinationBranch = json['account_destination_branch'];
    accountDestinationAccount = json['account_destination_account'];
    accountDestinationAccountType = json['account_destination_account_type'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = super.toJson();
    result['domain_account_id'] = domainAccountId;
    result['psp_id'] = pspId;
    result['tax_identifier_tax_id'] = taxIdentifierTaxId;
    result['tax_identifier_country'] = taxIdentifierCountry;
    result['alias'] = alias;
    
    if (endToEndIdQuery != null) result['end_to_end_id_query'] = endToEndIdQuery;
    if (accountDestinationBranch != null) result['account_destination_branch'] = accountDestinationBranch;
    
    result['account_destination_account'] = accountDestinationAccount;
    result['account_destination_account_type'] = accountDestinationAccountType;
    result['selected'] = selected;

    return result;
  }
}
