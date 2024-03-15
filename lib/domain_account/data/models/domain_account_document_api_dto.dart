import 'package:viggo_pay_core_frontend/base/entity_api_dto.dart';

class DomainAccountDocumentApiDto extends EntityDto {
  late String content;
  late String tipo;
  late String title;

  DomainAccountDocumentApiDto.fromJson(Map<String, dynamic> json) {
    super.entityFromJson(json);
    content = json['content'];
    tipo = json['tipo'];
    title = json['title'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = super.toJson();
    result['content'] = content;
    result['tipo'] = tipo;
    result['title'] = title;
    return result;
  }
}
