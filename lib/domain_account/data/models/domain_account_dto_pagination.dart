import 'package:viggo_core_frontend/base/pagination_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';

class DomainAccountDtoPagination {
  final List<DomainAccountApiDto> domainAccounts;
  final PaginationApiDto? pagination;

  DomainAccountDtoPagination({
    required this.domainAccounts,
    this.pagination,
  });
}
