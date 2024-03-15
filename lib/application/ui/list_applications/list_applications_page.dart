import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/application/ui/list_applications/list_applications_grid.dart';

class ListApplicationsPage extends StatelessWidget {
  const ListApplicationsPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilderMain(
      changeTheme: changeTheme,
      child: const Expanded(
        child: ListApplicationsGrid(),
      ),
    );
  }
}
