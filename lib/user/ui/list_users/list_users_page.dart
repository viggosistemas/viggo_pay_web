import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_grid.dart';

class ListUsersPage extends StatelessWidget {
  const ListUsersPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilderMain(
      changeTheme: changeTheme,
      child: const Expanded(
        child: ListUsersGrid(),
      ),
    );
  }
}
