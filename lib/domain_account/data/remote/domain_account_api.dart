// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:viggo_core_frontend/base/base_api.dart';
import 'package:viggo_core_frontend/network/bytes_response.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/no_content_response.dart';
import 'package:viggo_pay_admin/domain_account/data/models/response.dart';

class DomainAccountApi extends BaseApi {
  DomainAccountApi({required super.settings});

  static const ENDPOINT = '/domain_accounts';
  static const PASSWORD_ENDPOINT = '/update_password';
  static const EXTRATO_ENDPOINT = '/extrato_pdf';

  Future<DomainAccountsResponse> getEntitiesByParams(
    Map<String, dynamic> params,
  ) async {
    String url = handleFilters(ENDPOINT, params);

    var response = await get(url);
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
    String url = '$ENDPOINT/$id';

    if (include != null) url = '$url?include=$include';

    var response = await get(url);
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

  Future<DomainAccountResponse> updateEntity(
    Map<String, dynamic> params,
  ) async {
    String id = params['id'];
    Map<String, dynamic> body = params['body'];

    String url = '$ENDPOINT/$id';

    var response = await put(url, body: body);
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

  Future<NoContentResponse> updatePasswordPix(
    Map<String, dynamic> params,
  ) async {
    String id = params['id'];
    Map<String, dynamic> body = params['body'];

    String url = '$ENDPOINT/$id$PASSWORD_ENDPOINT';

    var response = await put(url, body: body);
    switch (response.statusCode) {
      case 204:
        return NoContentResponse(noContent: NoContentApiDto());
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<DomainAccountResponse> addDocuments(
    Map<String, dynamic> params,
  ) async {
    Map<String, dynamic> body = params['body'];
    String id = params['id'];

    String url = '$ENDPOINT/$id';

    var response = await put(url, body: body);
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

  Future<BytesResponse> extratoPDF(
    Map<String, dynamic> params,
  ) async {
    String id = params['id'];
    params.remove('id');
    String url = '$ENDPOINT/$id$EXTRATO_ENDPOINT';

    url = handleFilters(url, params);

    var response = await get(url);
    switch (response.statusCode) {
      case 200:
        return BytesResponse(bytes: response.bodyBytes);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }
}
