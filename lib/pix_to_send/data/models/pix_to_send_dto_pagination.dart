import 'package:viggo_core_frontend/base/pagination_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';

class PixToSendDtoPagination {
  final List<PixToSendApiDto> pixToSends;
  final PaginationApiDto? pagination;

  PixToSendDtoPagination({
    required this.pixToSends,
    this.pagination,
  });
}
