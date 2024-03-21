import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/role/ui/list_roles/list_roles_grid.dart';

class ListRolesPage extends StatelessWidget {
  const ListRolesPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      changeTheme: changeTheme,
      child: const Expanded(
        child: ListRolesGrid(),
      ),
    );
  }
}
