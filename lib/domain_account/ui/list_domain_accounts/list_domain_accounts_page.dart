import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_grid.dart';

class ListDomainAccountPage extends StatelessWidget {
  const ListDomainAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      child: ListDomainAccountsGrid(
        parentId: null,
      ),
    );
  }
}
