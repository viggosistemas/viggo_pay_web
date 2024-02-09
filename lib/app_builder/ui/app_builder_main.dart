import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';

class AppBuilderMain extends StatelessWidget {
  const AppBuilderMain({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<AppBuilderViewModel>(),
      child: AppBuilder(
        child: child,
      ),
    );
  }
}
