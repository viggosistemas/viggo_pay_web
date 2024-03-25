import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_grid.dart';

class ListUsersPage extends StatelessWidget {
  const ListUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      child: Expanded(
        child: ListUsersGrid(
          domainId: null,
        ),
      ),
    );
  }
}
