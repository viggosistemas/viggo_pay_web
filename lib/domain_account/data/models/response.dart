
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_core_frontend/base/pagination_api_dto.dart';

class DomainAccountResponse {
  late DomainAccountApiDto domainAccount;

  DomainAccountResponse.fromJson(Map<String, dynamic> json) {
    domainAccount = DomainAccountApiDto.fromJson(json['domain_account']);
  }
}

class DomainAccountsResponse {
  late List<DomainAccountApiDto> domainAccounts;
  late PaginationApiDto? pagination;

  DomainAccountsResponse.fromJson(Map<String, dynamic> json) {
    domainAccounts = List<DomainAccountApiDto>.from(
        json['domain_accounts'].map((val) => DomainAccountApiDto.fromJson(val)).toList());
    pagination = json['pagination'] != null
        ? PaginationApiDto.fromJson(json['pagination'])
        : null;
  }
}
