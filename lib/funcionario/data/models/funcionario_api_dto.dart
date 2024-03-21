import 'package:viggo_core_frontend/base/entity_api_dto.dart';
import 'package:viggo_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';

class FuncionarioApiDto extends EntityDto {
  late String domainAccountId;
  late String? userId;
  late ParceiroApiDto? parceiro;
  late UserApiDto? user;
  bool selected = false;

  FuncionarioApiDto.fromJson(Map<String, dynamic> json) {
    super.entityFromJson(json);
    domainAccountId = json['domain_account_id'];
    parceiro = json['parceiro'] != null
        ? ParceiroApiDto.fromJson(json['parceiro'])
        : null;
    user = json['user'] != null
        ? UserApiDto.fromJson(json['user'])
        : null;
    userId = json['user_id'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = super.toJson();
    result['domain_account_id'] = domainAccountId;
    result['userId'] = userId;
    result['selected'] = selected;

    if (user != null) {
      result['user'] = user;
    }

    if (parceiro != null) {
      result['parceiro'] = parceiro;
    }

    return result;
  }
}