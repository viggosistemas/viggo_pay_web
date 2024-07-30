import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_core_frontend/base/pagination_api_dto.dart';

class FuncionarioDtoPagination {
  final List<FuncionarioApiDto> funcionarios;
  final PaginationApiDto? pagination;

  FuncionarioDtoPagination({
    required this.funcionarios,
    this.pagination,
  });
}
