import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_grid.dart';

class ListDomainAccountPage extends StatelessWidget {
  const ListDomainAccountPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      changeTheme: changeTheme,
      child: const Expanded(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListDomainAccountsGrid(),
        ),
      ),
    );
  }
}
