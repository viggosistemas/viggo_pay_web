import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/matriz_info_edit.dart';

class MatrizInfoPage extends StatelessWidget {
  const MatrizInfoPage({
    super.key,
    required this.changeTheme,
  });

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      changeTheme: changeTheme,
      child: const Expanded(
        child: MatrizInfoEdit(),
      ),
    );
  }
}
