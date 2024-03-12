import 'package:viggo_pay_core_frontend/base/entity_api_dto.dart';
import 'package:viggo_pay_core_frontend/localidades/data/models/municipio_dto.dart';

class ParceiroApiDto extends EntityDto {
  late String domainId;
  late String cpfCnpj;
  late String nomeRazaoSocial;
  late String? rgInscEst;
  late String? apelidoNomeFantasia;
  late List<ParceiroEndereco> enderecos;
  late List<ParceiroContato> contatos;
  bool selected = false;

  ParceiroApiDto.fromJson(Map<String, dynamic> json) {
    super.entityFromJson(json);
    domainId = json['domain_id'];
    cpfCnpj = json['cpf_cnpj'].toString().trim();
    nomeRazaoSocial = json['nome_razao_social'];
    rgInscEst = json['rg_insc_est'] ?? '';
    apelidoNomeFantasia = json['apelido_nome_fantasia'] ?? '';
    enderecos = List<ParceiroEndereco>.from(json['enderecos']
        .map((val) => ParceiroEndereco.fromJson(val))
        .toList());
    contatos = List<ParceiroContato>.from(
        json['contatos'].map((val) => ParceiroContato.fromJson(val)).toList());
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = super.toJson();
    result['domain_id'] = domainId;
    result['cpf_cnpj'] = cpfCnpj;
    result['nome_razao_social'] = nomeRazaoSocial;
    result['rg_insc_est'] = rgInscEst;
    result['apelido_nome_fantasia'] = apelidoNomeFantasia;
    result['enderecos'] = enderecos;
    result['contatos'] = contatos;
    result['selected'] = selected;

    return result;
  }
}

class ParceiroEndereco {
  late String logradouro;
  late String numero;
  late String complemento;
  late String bairro;
  late String cep;
  late String pontoReferencia;
  late String municipioId;
  late MunicipioApiDto? municipio;

  bool selected = false;

  ParceiroEndereco.fromJson(Map<String, dynamic> json) {
    logradouro = json['logradouro'];
    numero = json['numero'];
    complemento = json['complemento'];
    bairro = json['bairro'];
    cep = json['cep'];
    pontoReferencia = json['ponto_referencia'];
    municipioId = json['municipio_id'];
    municipio = json['municipio'] != null
        ? MunicipioApiDto.fromJson(json['municipio'])
        : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};

    result['logradouro'] = logradouro;
    result['numero'] = numero;
    result['complemento'] = complemento;
    result['bairro'] = bairro;
    result['cep'] = cep;
    result['ponto_referencia'] = pontoReferencia;
    result['municipio_id'] = municipioId;
    result['selected'] = selected;

    if(municipio != null) result['municipio'] = municipio;

    return result;
  }
}

class ParceiroContato {
  late String contato;
  late String tag;

  ParceiroContato.fromJson(Map<String, dynamic> json) {
    contato = json['contato'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['contato'] = contato;
    result['tag'] = tag;

    return result;
  }
}
