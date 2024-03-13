import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domains_grid.dart';

class ListDomainsPage extends StatelessWidget {
  const ListDomainsPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilderMain(
      changeTheme: changeTheme,
      child: const Expanded(
        child: ListDomainsGrid(),
      ),
    );
  }
}
