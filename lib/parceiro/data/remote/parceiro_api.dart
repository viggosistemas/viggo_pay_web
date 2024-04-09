// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:viggo_core_frontend/base/base_api.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/parceiro/data/models/response.dart';

class ParceiroApi extends BaseApi {
  ParceiroApi({required super.settings});

  static const ENDPOINT = '/parceiros';

  Future<ParceirosResponse> getEntitiesByParams(
    Map<String, dynamic> params,
  ) async {
    String url = handleFilters(ENDPOINT, params);

    var response = await get(url);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return ParceirosResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<ParceiroResponse> getEntityById(
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
        return ParceiroResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<ParceiroResponse> updateEntity(Map<String, dynamic> params) async {
    String id = params['id'];
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT/$id';

    var response = await put(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return ParceiroResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<ParceiroResponse> createEntity(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];

    var response = await post(ENDPOINT, body: body);
    switch (response.statusCode) {
      case 201:
        Map<String, dynamic> json = jsonDecode(response.body);
        return ParceiroResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }
}
