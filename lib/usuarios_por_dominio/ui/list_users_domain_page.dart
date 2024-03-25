import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/usuarios_por_dominio/ui/list_users_domain_grid.dart';

class ListUsersDomainPage extends StatelessWidget {
  const ListUsersDomainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      child: Expanded(
        child: ListUsersDomainGrid(),
      ),
    );
  }
}
