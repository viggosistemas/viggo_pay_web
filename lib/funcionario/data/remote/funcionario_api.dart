// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:viggo_pay_admin/funcionario/data/models/response.dart';
import 'package:viggo_core_frontend/base/base_api.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';

class FuncionarioApi extends BaseApi {
  FuncionarioApi({required super.settings});

  static const ENDPOINT = '/funcionarios';

  Future<FuncionariosResponse> getEntitiesByParams(
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
    Map<String, String> headers = getHeaders();

    String url = '$baseUrl$ENDPOINT/$id';
    if (include != null) url = '$url?include=$include';
    var response = await http.get(Uri.parse(url), headers: headers);
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
