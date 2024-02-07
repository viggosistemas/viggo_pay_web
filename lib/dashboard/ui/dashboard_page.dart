import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<AppBuilderViewModel>(context);

    // return StreamBuilder<Object>(
    //     stream: viewModel.isLogged,
    //     builder: (context, snapshot) {
    //       if (snapshot.data != null && snapshot.data == true) {
    //         showInfoMessage(
    //           context,
    //           2,
    //           Colors.green,
    //           'Seja bem-vindo, usuário!',
    //           'X',
    //           () {},
    //           Colors.white,
    //         );
    //       }

    return AppBuilder(
      child: Expanded(
        child: Container(
          child: const Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
    // }
    // );
  }
}
