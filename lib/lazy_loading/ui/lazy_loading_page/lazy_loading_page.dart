import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_page/lazy_loading_widget.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class LazyLoadingPage extends StatelessWidget {
  const LazyLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        Navigator.of(context).pushNamed(Routes.WORKSPACE);
      });
    }

    navigateToLogin() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(Routes.LOGIN_PAGE);
      });
    }

    return ChangeNotifierProvider(
      create: (_) => locator.get<LazyLoadingViewModel>(),
      child: Scaffold(
        body: Center(
          child: LazyLoadingWidget(
            onNavigateToLogin: navigateToLogin,
            onNavigateToWorkSpace: navigateWorkspace,
          ),
        ),
      ),
    );
  }
}
