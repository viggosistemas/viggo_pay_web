import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/dominios_por_matriz/ui/list_domains_matriz_grid.dart';

class ListDomainsMatrizPage extends StatelessWidget {
  const ListDomainsMatrizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      child: ListDomainsMatrizGrid(),
    );
  }
}
