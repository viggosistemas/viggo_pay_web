// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:viggo_core_frontend/base/base_api.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/domain_account/data/models/response_domain_account_config.dart';

class DomainAccountConfigApi extends BaseApi {
  DomainAccountConfigApi({required super.settings});

  static const ENDPOINT = '/domain_account_taxas';

  Future<DomainAccountTaxaResponse> editConfig(Map<String, dynamic> params) async {
    String id = params['id'];
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT/$id';

    var response = await put(url, body: body);
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

    var response = await post(ENDPOINT, body: body);
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
    String url = handleFilters(ENDPOINT, params);
    var response = await get(url);
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
