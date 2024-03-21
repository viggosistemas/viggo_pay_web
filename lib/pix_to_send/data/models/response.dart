
import 'package:viggo_core_frontend/base/pagination_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';

class PixToSendResponse {
  late PixToSendApiDto pixToSend;

  PixToSendResponse.fromJson(Map<String, dynamic> json) {
    pixToSend = PixToSendApiDto.fromJson(json['pix_to_send']);
  }
}

class PixToSendsResponse {
  late List<PixToSendApiDto> pixToSends;
  late PaginationApiDto? pagination;

  PixToSendsResponse.fromJson(Map<String, dynamic> json) {
    pixToSends = List<PixToSendApiDto>.from(
        json['pix_to_sends'].map((val) => PixToSendApiDto.fromJson(val)).toList());
    pagination = json['pagination'] != null
        ? PaginationApiDto.fromJson(json['pagination'])
        : null;
  }
}
