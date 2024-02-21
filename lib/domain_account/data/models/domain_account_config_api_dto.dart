import 'package:viggo_pay_core_frontend/base/entity_api_dto.dart';

class DomainAccountConfigApiDto extends EntityDto {
  late String domainAccountId;
  late double taxa;
  late double porcentagem;

  DomainAccountConfigApiDto.fromJson(Map<String, dynamic> json) {
    super.entityFromJson(json);
    domainAccountId = json['domain_account_id'];
    taxa = json['taxa'];
    porcentagem = json['porcentagem'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = super.toJson();
    result['domain_account_id'] = domainAccountId;
    result['taxa'] = taxa;
    result['porcentagem'] = porcentagem;

    return result;
  }
}
