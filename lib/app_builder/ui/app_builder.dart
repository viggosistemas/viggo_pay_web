import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/app_bar.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/main_rail.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class AppBuilder extends StatelessWidget {
  const AppBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(context) {
    void setScreen(String identifier) {
      if (identifier == 'Home') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(Routes.WORKSPACE);
        });
      } else if (identifier == 'Empresas') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(Routes.DOMAINS);
        });
      } else if (identifier == 'Logout') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.HOME, (r) => false);
      }
    }

    return ChangeNotifierProvider(
      create: (_) => locator.get<AppBuilderViewModel>(),
      child: Scaffold(
        appBar: AppBarPrivate(
          toolbarHeight: 50,
          actions: [
            Image.asset(
              'assets/images/ic_logo.png',
              width: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 20,
            ),
            PopMenuActionsUser(
              onSelectScreen: setScreen,
            )
          ],
        ),
        // TODO: CASO QUEIRAM UM DRAWER ESSA É A DINAMICA (MENU SANDUICHE)
        // drawer: MainDrawer(
        //   onSelectScreen: (String identifier) {
        //     Navigator.pop(context);
        //     if (identifier == 'filters') {
        //       // Navigator.of(context).pushReplacement(
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (ctx) => Text('aqui'),
        //         ),
        //       );
        //     }
        //   },
        // ),
        // body: Container(
        //   child: const Text(
        //     'Dashboard',
        //     style: TextStyle(
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        body: SafeArea(
          bottom: false,
          top: false,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: MainRail(
                  onSelectScreen: setScreen,
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
