import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/application/ui/list_applications/list_applications_grid.dart';

class ListApplicationsPage extends StatelessWidget {
  const ListApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBuilder(
      child: ListApplicationsGrid(),
    );
  }
}
