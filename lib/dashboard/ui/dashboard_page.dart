import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBuilderMain(
      child: Expanded(
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
