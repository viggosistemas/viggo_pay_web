import 'package:viggo_pay_core_frontend/base/entity_api_dto.dart';

class DomainAccountConfigApiDto extends EntityDto {
  late String domainAccountId;
  late double? taxa;
  late bool? porcentagem;

  DomainAccountConfigApiDto.fromJson(Map<String, dynamic> json) {
    super.entityFromJson(json);
    domainAccountId = json['domain_account_id'];
    taxa = json['taxa'] ?? 0;
    porcentagem = json['porcentagem'] ?? false;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = super.toJson();
    result['domain_account_id'] = domainAccountId;

    if (taxa != null) result['taxa'] = taxa;
    if (porcentagem != null) result['porcentagem'] = porcentagem;

    return result;
  }
}
