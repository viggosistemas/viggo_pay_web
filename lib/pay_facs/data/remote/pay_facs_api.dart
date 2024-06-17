// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:viggo_core_frontend/base/base_api.dart';
import 'package:viggo_core_frontend/network/bytes_response.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/no_content_response.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_chave_pix.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_destinatario.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_extrato.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_saldo.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/response_transacoes.dart';

class PayFacsApi extends BaseApi {
  PayFacsApi({required super.settings});

  static const ENDPOINT = '/pay_facs';
  static const SALDO_ENDPOINT = '/get_saldo';
  static const EXTRATO_ENDPOINT = '/get_extrato';
  static const EXTRATO_SALDO_ENDPOINT = '/get_extrato_com_saldo';
  static const TRANSACOES_ENDPOINT = '/get_transacoes';
  static const ULTIMA_TRANSACAO_ENDPOINT = '/get_ultima_transacao';
  static const CASHOUT_ENDPOINT = '/cashout_via_pix';
  static const PIX_ENDPOINT = '/list_chaves_pix';
  static const DESTINATARIO_ENDPOINT = '/consultar_alias_destinatario';
  static const DELETAR_CHAVE_PIX = '/deletar_chave_pix';
  static const ADD_CHAVE_PIX = '/add_chave_pix';

  Future<SaldoResponse> getSaldo(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$SALDO_ENDPOINT';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return SaldoResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<ExtratosResponse> getExtrato(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$EXTRATO_ENDPOINT';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return ExtratosResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<ExtratosSaldoResponse> getExtratoSaldo(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$EXTRATO_SALDO_ENDPOINT';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return ExtratosSaldoResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<TransacoesResponse> getTransacoes(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$TRANSACOES_ENDPOINT';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return TransacoesResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<TransacaoResponse> getUltimaTransacao(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$ULTIMA_TRANSACAO_ENDPOINT';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return TransacaoResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<BytesResponse> cashoutViaPix(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$CASHOUT_ENDPOINT';

    var response = await post(url, body: body);
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

  Future<ChavesPixResponse> listChavePix(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$PIX_ENDPOINT';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return ChavesPixResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<DestinatarioResponse> consultarAliasDestinatario(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$DESTINATARIO_ENDPOINT';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return DestinatarioResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<NoContentResponse> deletarChavePix(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$DELETAR_CHAVE_PIX';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 202:
        return NoContentResponse(noContent: NoContentApiDto());
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }

  Future<ChavePixGeradaResponse> addChavePix(Map<String, dynamic> params) async {
    Map<String, dynamic> body = params['body'];
    String url = '$ENDPOINT$ADD_CHAVE_PIX';

    var response = await post(url, body: body);
    switch (response.statusCode) {
      case 202:
        Map<String, dynamic> json = jsonDecode(response.body);
        return ChavePixGeradaResponse.fromJson(json);
      default:
        throw NetworkException(
          message: response.body,
          isRetryAble: false,
          code: response.statusCode,
        );
    }
  }
}
