import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_grid.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_view_model.dart';

class ListFuncionarioPage extends StatelessWidget {
  const ListFuncionarioPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<ListFuncionarioViewModel>(),
      child: AppBuilderMain(
        changeTheme: changeTheme,
        child: const Expanded(
          child: ListFuncionarioGrid(),
        ),
      ),
    );
  }
}
