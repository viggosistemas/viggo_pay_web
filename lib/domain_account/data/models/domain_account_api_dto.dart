import 'package:viggo_pay_core_frontend/base/entity_api_dto.dart';
import 'package:viggo_pay_core_frontend/util/date_converter.dart';

class DomainAccountApiDto extends EntityDto {
  late String? materaId;
  late String? materaStatus;
  late String? materaMessage;
  late String clientName;
  late String clientTaxIdentifierTaxId;
  late String? clientTaxIdentifierCountry;
  late String clientMobilePhone;
  late String clientMobilePhoneCountry;
  late String clientEmail;
  late String billingAddressLogradouro;
  late String billingAddressNumero;
  late String billingAddressComplemento;
  late String billingAddressBairro;
  late String billingAddressCidade;
  late String billingAddressEstado;
  late String billingAddressCep;
  late String billingAddressPais;
  late String? macMaquina;
  late DateTime? aceitacaoTermoDh;
  late double? lat;
  late double? lon;
  bool selected = false;

  DomainAccountApiDto.fromJson(Map<String, dynamic> json) {
    super.entityFromJson(json);
    materaId = json['matera_id'];
    materaStatus = json['matera_status'];
    materaMessage = json['matera_message'];

    clientName = json['client_name'];
    clientTaxIdentifierTaxId = json['client_tax_identifier_tax_id'];
    clientTaxIdentifierCountry = json['client_tax_identifier_country'];
    clientMobilePhone = json['client_mobile_phone_phone_number'];
    clientMobilePhoneCountry = json['client_mobile_phone_country'];
    clientEmail = json['client_email'];

    billingAddressLogradouro = json['billing_address_logradouro'];
    billingAddressNumero = json['billing_address_numero'];
    billingAddressComplemento = json['billing_address_complemento'];
    billingAddressBairro = json['billing_address_bairro'];
    billingAddressCidade = json['billing_address_cidade'];
    billingAddressEstado = json['billing_address_estado'];
    billingAddressCep = json['billing_address_cep'];
    billingAddressPais = json['billing_address_pais'];

    macMaquina = json['mac_maquina'];
    aceitacaoTermoDh = json['aceitacao_termo_dh'] != null
        ? DateConverter().deserializeDateTime(json['aceitacao_termo_dh'])
        : null;
    lat = json['lat'];
    lon = json['lon'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = super.toJson();
    if (materaId != null) result['matera_id'] = materaId;
    if (materaStatus != null) result['matera_status'] = materaStatus;
    if (materaMessage != null) result['matera_message'] = materaMessage;

    result['client_name'] = clientName;
    result['client_tax_identifier_tax_id'] = clientTaxIdentifierTaxId;
    result['client_tax_identifier_country'] = clientTaxIdentifierCountry;
    result['client_mobile_phone_phone_number'] = clientMobilePhone;
    result['client_mobile_phone_country'] = clientMobilePhoneCountry;
    result['client_email'] = clientEmail;

    result['billing_address_logradouro'] = billingAddressLogradouro;
    result['billing_address_numero'] = billingAddressNumero;
    result['billing_address_complemento'] = billingAddressComplemento;
    result['billing_address_bairro'] = billingAddressBairro;
    result['billing_address_cidade'] = billingAddressCidade;
    result['billing_address_estado'] = billingAddressEstado;
    result['billing_address_cep'] = billingAddressCep;
    result['billing_address_pais'] = billingAddressPais;

    result['selected'] = selected;

    result['client_name'] = clientName;
    result['client_tax_identifier_tax_id'] = clientTaxIdentifierTaxId;
    if (clientTaxIdentifierCountry != null)
      result['client_tax_identifier_country'] = clientTaxIdentifierCountry;

    if (macMaquina != null) result['mac_maquina'] = macMaquina;
    if (aceitacaoTermoDh != null)
      result['aceitacao_termo_dh'] =
          DateConverter().serializeDateTime(aceitacaoTermoDh!);
    if (lat != null) result['lat'] = lat;
    if (lon != null) result['lon'] = lon;

    return result;
  }
}
