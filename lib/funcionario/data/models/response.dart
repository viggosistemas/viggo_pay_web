
import 'package:viggo_core_frontend/base/pagination_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';

class FuncionarioResponse {
  late FuncionarioApiDto funcionario;

  FuncionarioResponse.fromJson(Map<String, dynamic> json) {
    funcionario = FuncionarioApiDto.fromJson(json['funcionario']);
  }
}

class FuncionariosResponse {
  late List<FuncionarioApiDto> funcionarios;
  late PaginationApiDto? pagination;

  FuncionariosResponse.fromJson(Map<String, dynamic> json) {
    funcionarios = List<FuncionarioApiDto>.from(
        json['funcionarios'].map((val) => FuncionarioApiDto.fromJson(val)).toList());
    pagination = json['pagination'] != null
        ? PaginationApiDto.fromJson(json['pagination'])
        : null;
  }
}
