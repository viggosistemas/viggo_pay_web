import 'package:viggo_core_frontend/base/pagination_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';

class DomainAccountTaxaResponse {
  late DomainAccountConfigApiDto domainAccountTaxa;

  DomainAccountTaxaResponse.fromJson(Map<String, dynamic> json) {
    domainAccountTaxa = DomainAccountConfigApiDto.fromJson(json['domain_account_taxa']);
  }
}

class DomainAccountTaxasResponse {
  late List<DomainAccountConfigApiDto> domainAccountTaxas;
  late PaginationApiDto? pagination;

  DomainAccountTaxasResponse.fromJson(Map<String, dynamic> json) {
    domainAccountTaxas = List<DomainAccountConfigApiDto>.from(
        json['domain_account_taxas'].map((val) => DomainAccountConfigApiDto.fromJson(val)).toList());
    pagination = json['pagination'] != null
        ? PaginationApiDto.fromJson(json['pagination'])
        : null;
  }
}
