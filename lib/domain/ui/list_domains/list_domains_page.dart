import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domains_grid.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_view_model.dart';

class ListDomainsPage extends StatelessWidget {
  const ListDomainsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<ListDomainViewModel>(),
      child: const AppBuilderMain(
        child: Expanded(
          child: ListDomainsGrid(),
        ),
      ),
    );
  }
}
