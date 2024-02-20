// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:viggo_pay_admin/domain_account/data/models/response.dart';
import 'package:viggo_pay_core_frontend/base/base_api.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class DomainAccountApi extends BaseApi {
  DomainAccountApi({required super.settings});

  static const ENDPOINT = '/domain_accounts';

  Future<DomainAccountsResponse> getEntitiesByParams(
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
        return DomainAccountsResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<DomainAccountResponse> getEntityById(
    Map<String, dynamic> params,
  ) async {
    String id = params['id'];
    String? include = params['include'];
    Map<String, String> headers = getHeaders();

    String url = '$baseUrl$ENDPOINT/$id';
    if (include != null) url = '$url?include=$include';
    var response = await http.get(Uri.parse(url), headers: headers);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return DomainAccountResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }
}
