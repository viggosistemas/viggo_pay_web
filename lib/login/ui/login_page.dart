import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/app_bar.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/login/ui/login_form.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.changeTheme});

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

    navigateWorkspace() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showInfoMessage(
          context,
          2,
          Colors.green,
          'Seja Bem-vindo!',
          'X',
          () {},
          Colors.white,
        );
        Navigator.of(context).pushReplacementNamed(Routes.WORKSPACE);
      });
    }

    return ChangeNotifierProvider(
      create: (_) => locator.get<LoginViewModel>(),
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
