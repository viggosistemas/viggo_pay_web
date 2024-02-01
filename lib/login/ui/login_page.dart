import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/login/ui/login_form.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_admin/widgets/app_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    navigateWorkspace() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(Routes.WORKSPACE);
      });
    }

    return ChangeNotifierProvider(
      create: (_) => locator.get<LoginViewModel>(),
      child: Scaffold(
        appBar: const AppBarPrivate(),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login-bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginForm(onSucess: navigateWorkspace),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
