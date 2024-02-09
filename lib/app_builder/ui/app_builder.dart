import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/app_bar.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/main_rail.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu.dart';

class AppBuilder extends StatelessWidget {
  const AppBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(context) {
    void setScreen(String? route) {
      //TODO: SE ESTIVER LOGGED NO APP STATE NAO DEVE SAIR PRA LOGIN DEVE SE MANTER NO DASHBOARD
      if (route == 'LOGIN_PAGE') {
        Navigator.of(context).pushNamedAndRemoveUntil(route!, (r) => false);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(route!);
      });
    }
    return Scaffold(
      appBar: AppBarPrivate(
        toolbarHeight: 50,
        // showDrawerOrBack: true, TODO: USAR NO DRAWER
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                width: 5,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            child: Image.asset(
              'assets/images/ic_logo.png',
              width: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          PopMenuActionsUser(
            onSelectScreen: setScreen,
          )
        ],
      ),
      // TODO: USAR NO DRAWER
      // drawer: MainDrawer(
      //   onSelectScreen: setScreen,
      // ),
      // body: child,
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
    );
  }
}
