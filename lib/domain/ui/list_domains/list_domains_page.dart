import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domains_grid.dart';

class ListDomainsPage extends StatelessWidget {
  const ListDomainsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBuilder(
      child: Expanded(
        child: ListDomainsGrid(),
      ),
    );
  }
}
