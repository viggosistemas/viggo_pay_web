import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_grid.dart';

class ListFuncionarioPage extends StatelessWidget {
  const ListFuncionarioPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      changeTheme: changeTheme,
      child: const Expanded(
        child: ListFuncionarioGrid(),
      ),
    );
  }
}
