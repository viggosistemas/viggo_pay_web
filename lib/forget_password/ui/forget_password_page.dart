import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/app_bar.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_form.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class ForgetPassPage extends StatelessWidget {
  const ForgetPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    navigateToLogin() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(Routes.LOGIN_PAGE);
      });
    }

    return ChangeNotifierProvider(
      create: (_) => locator.get<ForgetPasswordViewModel>(),
      child: Scaffold(
        appBar: AppBarPrivate(
          toolbarHeight: 60,
        ),
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
                  ForgetPassForm(onSucess: navigateToLogin),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
