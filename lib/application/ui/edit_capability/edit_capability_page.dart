import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/application/ui/edit_capability/edit_capability_grid.dart';

class EditCapabilityPage extends StatelessWidget {
  const EditCapabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      child: Expanded(
        child: EditCapabilityGrid(),
      ),
    );
  }
}
