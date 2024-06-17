import 'package:viggo_core_frontend/base/pagination_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';

class DomainAccountTaxaDtoPagination {
  final List<DomainAccountConfigApiDto> domainAccountTaxas;
  final PaginationApiDto? pagination;

  DomainAccountTaxaDtoPagination({
    required this.domainAccountTaxas,
    this.pagination,
  });
}
