import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domain_web_view_model.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domains_grid.dart';

class ListDomainsPage extends StatelessWidget {
  const ListDomainsPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<ListDomainWebViewModel>(),
      child: AppBuilderMain(
        changeTheme: changeTheme,
        child: const Expanded(
          child: ListDomainsGrid(),
        ),
      ),
    );
  }
}
