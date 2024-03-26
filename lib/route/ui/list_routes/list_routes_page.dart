import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/route/ui/list_routes/list_routes_grid.dart';

class ListRoutesPage extends StatelessWidget {
  const ListRoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBuilder(
      child: ListRoutesGrid(),
    );
  }
}
