import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_grid.dart';

class ListPixToSendPage extends StatelessWidget {
  const ListPixToSendPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilderMain(
      changeTheme: changeTheme,
      child: const Expanded(
        child: ListPixToSendGrid(),
      ),
    );
  }
}
