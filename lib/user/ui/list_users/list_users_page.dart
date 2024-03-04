import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_grid.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_web_view_model.dart';

class ListUsersPage extends StatelessWidget {
  const ListUsersPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<ListUserWebViewModel>(),
      child: AppBuilderMain(
        changeTheme: changeTheme,
        child: const Expanded(
          child: ListUsersGrid(),
        ),
      ),
    );
  }
}
