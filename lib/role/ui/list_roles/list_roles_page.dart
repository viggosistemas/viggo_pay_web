import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/role/ui/list_roles/list_role_web_view_model.dart';
import 'package:viggo_pay_admin/role/ui/list_roles/list_roles_grid.dart';

class ListRolesPage extends StatelessWidget {
  const ListRolesPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<ListRoleWebViewModel>(),
      child: AppBuilderMain(
        changeTheme: changeTheme,
        child: const Expanded(
          child: ListRolesGrid(),
        ),
      ),
    );
  }
}
