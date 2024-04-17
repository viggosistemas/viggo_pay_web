// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:viggo_core_frontend/base/base_api.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/funcionario/data/models/response.dart';

class FuncionarioApi extends BaseApi {
  FuncionarioApi({required super.settings});

  static const ENDPOINT = '/funcionarios';

  Future<FuncionariosResponse> getEntitiesByParams(
    Map<String, dynamic> params,
  ) async {
    String url = handleFilters(ENDPOINT, params);

    var response = await get(url);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return FuncionariosResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<FuncionarioResponse> getEntityById(
    Map<String, dynamic> params,
  ) async {
    String id = params['id'];
    String? include = params['include'];
    String url = '$baseUrl$ENDPOINT/$id';

    if (include != null) url = '$url?include=$include';

    var response = await get(url);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return FuncionarioResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<FuncionarioResponse> updateEntity(Map<String, dynamic> params) async {
    String id = params['id'];
    Map<String, dynamic> body = params['body'];

    String url = '$ENDPOINT/$id';

    var response = await put(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return FuncionarioResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<FuncionarioResponse> createEntity(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];

    var response = await post(ENDPOINT, body: body);
    switch (response.statusCode) {
      case 201:
        Map<String, dynamic> json = jsonDecode(response.body);
        return FuncionarioResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }
}
