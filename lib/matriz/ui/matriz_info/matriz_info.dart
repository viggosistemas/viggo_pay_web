import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/matriz_info_edit.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';

class MatrizInfoPage extends StatelessWidget {
  const MatrizInfoPage({
    super.key,
    required this.changeTheme,
  });

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<MatrizViewModel>(),
      child: AppBuilderMain(
        changeTheme: changeTheme,
        child: const Expanded(
          child: MatrizInfoEdit(),
        ),
      ),
    );
  }
}
