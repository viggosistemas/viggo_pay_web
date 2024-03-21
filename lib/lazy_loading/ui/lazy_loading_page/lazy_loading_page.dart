import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_page/lazy_loading_widget.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_view_model.dart';

class LazyLoadingPage extends StatelessWidget {
  const LazyLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    navigateTo(String route) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(route);
      });
    }

    return ChangeNotifierProvider(
      create: (_) => locator.get<LazyLoadingViewModel>(),
      child: Scaffold(
        body: Center(
          child: LazyLoadingWidget(
            onNavigateTo: navigateTo,
          ),
        ),
      ),
    );
  }
}
