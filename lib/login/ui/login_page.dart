import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/login/ui/login_form.dart';
import 'package:viggo_pay_admin/themes/theme_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ThemeViewModel themeViewModel = locator.get<ThemeViewModel>();

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
        Navigator.of(context).pushReplacementNamed(Routes.WORKSPACE);
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              themeViewModel.logoAsset(Theme.of(context).brightness),
              width: 80,
              height: 80,
            ),
          ],
        ),
        actions: [
          OnHoverButton(
            child: IconButton(
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isActioned = true;
                  if (isDarkMode) {
                    iconMode = Icons.dark_mode_outlined;
                    colorIconMode = Colors.white;
                    themeViewModel.changeTheme(ThemeMode.light.name);
                  } else {
                    iconMode = Icons.light_mode_outlined;
                    colorIconMode = Colors.yellow;
                    themeViewModel.changeTheme(ThemeMode.dark.name);
                  }
                });
              },
              icon: Icon(
                iconMode,
                color: colorIconMode,
              ),
            ),
          ),
        ],
        shadowColor: Colors.black,
        elevation: 8,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(themeViewModel.backgroundAsset(Theme.of(context).brightness)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginForm(onSucess: navigateWorkspace),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/logo-viggo.png',
                  width: 80,
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
