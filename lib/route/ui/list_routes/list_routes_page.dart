import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/route/ui/list_routes/list_route_web_view_model.dart';
import 'package:viggo_pay_admin/route/ui/list_routes/list_routes_grid.dart';

class ListRoutesPage extends StatelessWidget {
  const ListRoutesPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<ListRouteWebViewModel>(),
      child: AppBuilderMain(
        changeTheme: changeTheme,
        child: const Expanded(
          child: ListRoutesGrid(),
        ),
      ),
    );
  }
}
