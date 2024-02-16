import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/app_bar.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_form.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key, required this.changeTheme});

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  var iconMode = Icons.dark_mode_outlined;
  dynamic colorIconMode = Colors.white;
  bool isActioned = false;

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode && !isActioned) {
      setState(() {
        iconMode = Icons.light_mode_outlined;
        colorIconMode = Colors.yellow;
      });
    }

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
          // actions: [
          //   IconButton(
          //     style: IconButton.styleFrom(
          //       foregroundColor: Colors.white,
          //     ),
          //     onPressed: () {
          //       setState(() {
          //         isActioned = true;
          //         if (isDarkMode) {
          //           iconMode = Icons.dark_mode_outlined;
          //           colorIconMode = Colors.white;
          //           widget.changeTheme(ThemeMode.light);
          //         } else {
          //           iconMode = Icons.light_mode_outlined;
          //           colorIconMode = Colors.yellow;
          //           widget.changeTheme(ThemeMode.dark);
          //         }
          //       });
          //     },
          //     icon: Icon(
          //       iconMode,
          //       color: colorIconMode,
          //     ),
          //   ),
          // ],
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
