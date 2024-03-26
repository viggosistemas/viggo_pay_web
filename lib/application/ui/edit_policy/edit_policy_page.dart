import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/application/ui/edit_policy/edit_policy_grid.dart';

class EditPolicyPage extends StatelessWidget {
  const EditPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      child: EditPolicyGrid(),
    );
  }
}
