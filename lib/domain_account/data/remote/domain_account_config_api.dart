// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:viggo_pay_admin/domain_account/data/models/response_domain_account_config.dart';
import 'package:viggo_pay_core_frontend/base/base_api.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class DomainAccountConfigApi extends BaseApi {
  DomainAccountConfigApi({required super.settings});

  static const ENDPOINT = '/domain_account_taxas';

  Future<DomainAccountTaxaResponse> editConfig(Map<String, dynamic> params) async {
    String id = params['id'];
    Map<String, dynamic> body = params['body'];
    Map<String, String> headers = getHeaders();

    body = cleanEntity(body);
    String url = '$baseUrl$ENDPOINT/$id';

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return DomainAccountTaxaResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<DomainAccountTaxaResponse> addConfig(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    Map<String, String> headers = getHeaders();

    body = cleanEntity(body);
    String url = '$baseUrl$ENDPOINT';

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    switch (response.statusCode) {
      case 201:
        Map<String, dynamic> json = jsonDecode(response.body);
        return DomainAccountTaxaResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<DomainAccountTaxasResponse> getConfigId(
    Map<String, dynamic> params,
  ) async {
    String url = '$baseUrl$ENDPOINT';
    Map<String, String> headers = getHeaders();

    // Monta os filtros da entidade baseado nos parâmetros solicitados
    url = handleFilters(url, params);

    // Envia requisição e trata retorno
    var response = await http.get(Uri.parse(url), headers: headers);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return DomainAccountTaxasResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }
}
