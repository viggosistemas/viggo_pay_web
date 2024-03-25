import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_grid.dart';

class ListPixToSendPage extends StatelessWidget {
  const ListPixToSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBuilder(
      child: Expanded(
        child: ListPixToSendGrid(),
      ),
    );
  }
}
