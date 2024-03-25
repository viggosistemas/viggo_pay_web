import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/role/ui/list_roles/list_roles_grid.dart';

class ListRolesPage extends StatelessWidget {
  const ListRolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBuilder(
      child: Expanded(
        child: ListRolesGrid(),
      ),
    );
  }
}
