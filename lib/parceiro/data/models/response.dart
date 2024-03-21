
import 'package:viggo_core_frontend/base/pagination_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';

class ParceiroResponse {
  late ParceiroApiDto parceiro;

  ParceiroResponse.fromJson(Map<String, dynamic> json) {
    parceiro = ParceiroApiDto.fromJson(json['parceiro']);
  }
}

class ParceirosResponse {
  late List<ParceiroApiDto> parceiros;
  late PaginationApiDto? pagination;

  ParceirosResponse.fromJson(Map<String, dynamic> json) {
    parceiros = List<ParceiroApiDto>.from(
        json['parceiros'].map((val) => ParceiroApiDto.fromJson(val)).toList());
    pagination = json['pagination'] != null
        ? PaginationApiDto.fromJson(json['pagination'])
        : null;
  }
}