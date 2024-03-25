import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_form.dart';
import 'package:viggo_pay_admin/themes/theme_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key});
  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
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

    navigateToLogin() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(Routes.LOGIN_PAGE);
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
              themeViewModel.logoAsset,
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(themeViewModel.backgroundAsset),
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
    );
  }
}
