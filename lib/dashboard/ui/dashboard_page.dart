import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/widgets/app_bar.dart';
import 'package:viggo_pay_admin/widgets/main_drawer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(context) {
    // showInfoMessage(
    //   context,
    //   20000,
    //   Colors.red,
    //   'Seja bem-vindo, usuário!',
    //   'X',
    //   () {},
    //   Colors.white,
    // );
    return Scaffold(
      appBar: const AppBarPrivate(),
      drawer: MainDrawer(
        onSelectScreen: (String identifier) {
          Navigator.pop(context);
          if (identifier == 'filters') {
            // Navigator.of(context).pushReplacement(
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => Text('aqui'),
              ),
            );
          }
        },
      ),
      body: Container(
        child: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
