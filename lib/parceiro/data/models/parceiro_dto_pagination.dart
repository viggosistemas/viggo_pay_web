
import 'package:viggo_core_frontend/base/pagination_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';

class ParceiroDtoPagination {
  final List<ParceiroApiDto> parceiros;
  final PaginationApiDto? pagination;

  ParceiroDtoPagination({
    required this.parceiros,
    this.pagination,
  });
}
