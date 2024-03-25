import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_grid.dart';

class ListFuncionarioPage extends StatelessWidget {
  const ListFuncionarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBuilder(
      child: Expanded(
        child: ListFuncionarioGrid(),
      ),
    );
  }
}
